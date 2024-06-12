#!/bin/bash

# Function to display help
display_help() {
    echo "Usage: $0 [--timeout <seconds>] [--namespace <namespace>] [--all-namespaces] [--verbose]"
    echo
    echo "   --timeout <seconds>   Set the timeout period in seconds (default is 300 seconds)"
    echo "   --namespace <namespace> Specify the namespace to check for pods"
    echo "   --all-namespaces      Check for pods in all namespaces"
    echo "   --verbose             Enable verbose mode to list pods and their states"
    echo "   --help                Display this help message and exit"
    exit 0
}

# Default timeout and verbose mode
timeout=300
verbose=false
namespace=""
all_namespaces=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --timeout)
            timeout="$2"
            shift
            ;;
        --namespace)
            namespace="$2"
            shift
            ;;
        --all-namespaces)
            all_namespaces=true
            ;;
        --verbose)
            verbose=true
            ;;
        --help)
            display_help
            ;;
        *)
            echo "Unknown parameter passed: $1"
            display_help
            exit 1
            ;;
    esac
    shift
done

# Check for conflicting arguments
if [[ -n "$namespace" && "$all_namespaces" == true ]]; then
    echo "Error: --namespace and --all-namespaces cannot be used together."
    display_help
    exit 1
fi

# Check if neither --namespace nor --all-namespaces is provided
if [[ -z "$namespace" && "$all_namespaces" != true ]]; then
    echo "Error: You must specify either --namespace or --all-namespaces."
    display_help
    exit 1
fi

declare -A printed_pods
declare -A pod_list

# Fetch all pods only once
if [[ "$all_namespaces" == true ]]; then
    all_pods=$(kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{" "}{.metadata.ownerReferences[?(@.kind=="Job")].kind}{"\n"}{end}')
else
    all_pods=$(kubectl get pods -n ${namespace} -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.metadata.name}{" "}{.metadata.ownerReferences[?(@.kind=="Job")].kind}{"\n"}{end}')
fi

# Store the pod list
while IFS= read -r pod; do
    namespace=$(echo ${pod} | awk '{print $1}')
    pod_name=$(echo ${pod} | awk '{print $2}')
    owner_kind=$(echo ${pod} | awk '{print $3}')
    pod_key="${namespace}/${pod_name}"
    pod_list[${pod_key}]="${owner_kind}"
done <<< "${all_pods}"

end=$((SECONDS+${timeout}))

while (( SECONDS < end )); do
    all_ready=true

    if [[ "$verbose" == true ]]; then
        echo "Checking pod states..."
    fi

    for pod_key in "${!pod_list[@]}"; do
        namespace=$(echo ${pod_key} | cut -d '/' -f 1)
        pod_name=$(echo ${pod_key} | cut -d '/' -f 2)
        owner_kind=${pod_list[${pod_key}]}

        phase=$(kubectl get pod ${pod_name} -n ${namespace} -o jsonpath='{.status.phase}')

        if [[ "${owner_kind}" == "Job" ]]; then
            if [[ "${phase}" == "Succeeded" ]]; then
                if [[ -z "${printed_pods[${pod_key}]}" ]]; then
                    echo "Pod ${pod_name} in namespace ${namespace} created by Job is ${phase}"
                    printed_pods[${pod_key}]=1
                fi
            else
                all_ready=false
                if [[ "$verbose" == true ]]; then
                    echo "Waiting for pod ${pod_name} in namespace ${namespace} created by Job to succeed. Current state: ${phase}"
                fi
            fi
        else
            if [[ "${phase}" == "Running" || "${phase}" == "Succeeded" ]]; then
                if [[ -z "${printed_pods[${pod_key}]}" ]]; then
                    echo "Pod ${pod_name} in namespace ${namespace} is ${phase}"
                    printed_pods[${pod_key}]=1
                fi
            else
                all_ready=false
                if [[ "$verbose" == true ]]; then
                    echo "Waiting for pod ${pod_name} in namespace ${namespace} to be Running or Succeeded. Current state: ${phase}"
                fi
            fi
        fi
    done

    if [[ "${all_ready}" == true ]]; then
        echo "All pods are either Running or Completed"
        exit 0
    fi

    sleep 5
done

echo "Timeout waiting for all pods to be either Running or Completed"
exit 1

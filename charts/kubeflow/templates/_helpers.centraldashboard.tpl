{{- define "kubeflow.centraldashboard.name" -}}
{{- printf "centraldashboard" }}
{{- end }}

{{- define "kubeflow.centraldashboard.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.centraldashboard.name" .) }}
{{- end }}

{{- define "kubeflow.centraldashboard.selectorLabels" -}}
{{ include "kubeflow.common.selectorLabels" . }}
{{ include "kubeflow.component.selectorLabels" (include "kubeflow.centraldashboard.name" .) }}
{{- end }}

{{- define "kubeflow.centraldashboard.image" -}}
{{- $registry := default .Values.defaults.image.registry .Values.centraldashboard.image.registryOverwrite -}}
{{- $repository :=  .Values.centraldashboard.image.repository -}}
{{- $tag := default .Values.defaults.image.tag .Values.centraldashboard.image.tagOverwrite -}}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}

{{- define "kubeflow.centraldashboard.imagePullPolicy" -}}
{{- $pullPolicy := default .Values.defaults.image.pullPolicy .Values.centraldashboard.image.pullPolicyOverwrite -}}
{{- $pullPolicy }}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.enabled" -}}
{{- $componentAutoscaling := .Values.centraldashboard.autoscaling -}}
{{- $defaultAutoscaling := .Values.defaults.autoscaling -}}
  {{- if $componentAutoscaling -}}
    {{- if eq nil $componentAutoscaling.enabled -}}
        {{- $defaultAutoscaling.enabled }}
    {{- else -}}
        {{- $componentAutoscaling.enabled }}
    {{- end -}}
  {{- else -}}
    {{- $defaultAutoscaling.enabled }}
  {{- end -}}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.minReplicas" -}}
{{- $componentAutoscaling := .Values.centraldashboard.autoscaling -}}
{{- $defaultAutoscaling := .Values.defaults.autoscaling -}}
  {{- if $componentAutoscaling -}}
    {{- default $defaultAutoscaling.minReplicas $componentAutoscaling.minReplicas }}
  {{- else -}}
    {{- $defaultAutoscaling.minReplicas }}
  {{- end -}}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.maxReplicas" -}}
{{- $componentAutoscaling := .Values.centraldashboard.autoscaling -}}
{{- $defaultAutoscaling := .Values.defaults.autoscaling -}}
  {{- if $componentAutoscaling -}}
    {{- default $defaultAutoscaling.maxReplicas $componentAutoscaling.maxReplicas }}
  {{- else -}}
    {{- $defaultAutoscaling.maxReplicas }}
  {{- end -}}
{{- end }}

{{- define "kubeflow.centraldashboard.serviceAccountName" -}}
{{- if .Values.centraldashboard.serviceAccount.create }}
{{- default (include "kubeflow.centraldashboard.name" .) .Values.centraldashboard.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.centraldashboard.serviceAccount.name -}}
{{- end }}
{{- end }}

{{- define "kubeflow.centraldashboard.clusterRoleName" -}}
{{- include "kubeflow.centraldashboard.name" . }}
{{- end }}

{{- define "kubeflow.centraldashboard.config.name" -}}
{{ printf "%s-config" (include "kubeflow.centraldashboard.name" .) }}
{{- end }}
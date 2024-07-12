{{/*
Kubeflow katib object names.
*/}}
{{- define "kubeflow.katib.baseName" -}}
{{- printf "katib" }}
{{- end }}

{{/*
Kubeflow katib object names.
*/}}
{{- define "kubeflow.katib.ui.baseName" -}}
{{- printf "katib-ui" }}
{{- end }}

{{- define "kubeflow.katib.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.katib.baseName" .)
    .
)}}
{{- end }}

{{- define "kubeflow.katib.ui.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.katib.ui.baseName" .)
    .
)}}
{{- end }}

{{- define "kubeflow.katib.serviceAccountName" -}}
{{- include "kubeflow.component.serviceAccountName"  (
    list
    (include "kubeflow.katib.name" .)
    .Values.katib.serviceAccount)
}}
{{- end }}

{{- define "kubeflow.katib.roleName" -}}
{{- include "kubeflow.katib.name" . }}
{{- end }}

{{- define "kubeflow.katib.roleBindingName" -}}
{{- include "kubeflow.katib.name" . }}
{{- end }}

{{- define "kubeflow.katib.clusterRoleName" -}}
{{- include "kubeflow.katib.name" . }}
{{- end }}

{{- define "kubeflow.katib.clusterRoleBindingName" -}}
{{- include "kubeflow.katib.name" . }}
{{- end }}

{{- define "kubeflow.katib.config.name" -}}
{{ printf "%s-config" (include "kubeflow.katib.name" .) }}
{{- end }}

{{- define "kubeflow.katib.authorizationPolicyExtAuthName" -}}
{{ include "kubeflow.component.authorizationPolicyExtAuthName" (
    list
    (include "kubeflow.katib.name" .)
    .Values.istioIntegration
)}}
{{- end }}

{{/*
Kubeflow katib Service.
*/}}
{{- define "kubeflow.katib.svc.name" -}}
{{ include "kubeflow.component.svc.name" (
    include "kubeflow.katib.name" .
)}}
{{- end }}

{{- define "kubeflow.katib.svc.addressWithNs" -}}
{{ include "kubeflow.component.svc.addressWithNs"  (
    list
    .
    (include "kubeflow.katib.name" .)
)}}
{{- end }}

{{- define "kubeflow.katib.svc.addressWithSvc" -}}
{{ include "kubeflow.component.svc.addressWithSvc"  (
    list
    .
    (include "kubeflow.katib.name" .)
)}}
{{- end }}

{{- define "kubeflow.katib.svc.fqdn" -}}
{{ include "kubeflow.component.svc.fqdn"  (
    list
    .
    (include "kubeflow.katib.ui.baseName" .)
)}}
{{- end }}

{{/*
Kubeflow katib object labels.
*/}}
{{- define "kubeflow.katib.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.katib.name" .) }}
{{- end }}

{{- define "kubeflow.katib.selectorLabels" -}}
{{ include "kubeflow.common.selectorLabels" . }}
{{ include "kubeflow.component.selectorLabels" (include "kubeflow.katib.name" .) }}
{{- end }}

{{- define "kubeflow.katib.ui.selectorLabels" -}}
{{ include "kubeflow.common.selectorLabels" . }}
{{ include "kubeflow.component.selectorLabels" (include "kubeflow.katib.ui.name" .) }}
{{- end }}

{{/*
Kubeflow katib container image settings.
*/}}
{{- define "kubeflow.katib.image" -}}
{{ include "kubeflow.component.image" (list .Values.defaults.image .Values.katib.image) }}
{{- end }}

{{- define "kubeflow.katib.imagePullPolicy" -}}
{{ include "kubeflow.component.imagePullPolicy" (list .Values.defaults.image .Values.katib.image) }}
{{- end }}

{{/*
Kubeflow katib Autoscaling and Availability.
*/}}
{{- define "kubeflow.katib.autoscaling.enabled" -}}
{{ include "kubeflow.component.autoscaling.enabled" (list .Values.defaults.autoscaling .Values.katib.autoscaling) }}
{{- end }}

{{- define "kubeflow.katib.autoscaling.minReplicas" -}}
{{ include "kubeflow.component.autoscaling.minReplicas" (list .Values.defaults.autoscaling .Values.katib.autoscaling) }}
{{- end }}

{{- define "kubeflow.katib.autoscaling.maxReplicas" -}}
{{ include "kubeflow.component.autoscaling.maxReplicas" (list .Values.defaults.autoscaling .Values.katib.autoscaling) }}
{{- end }}

{{- define "kubeflow.katib.autoscaling.targetCPUUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetCPUUtilizationPercentage" (list .Values.defaults.autoscaling .Values.katib.autoscaling) }}
{{- end }}

{{- define "kubeflow.katib.autoscaling.targetMemoryUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetMemoryUtilizationPercentage" (list .Values.defaults.autoscaling .Values.katib.autoscaling) }}
{{- end }}

{{- define "kubeflow.katib.pdb.values" -}}
{{- include "kubeflow.component.pdb.values" (
    list
    .Values.defaults.podDisruptionBudget
    .Values.katib.podDisruptionBudget
)}}
{{- end }}

{{/*
Kubeflow katib Security Context.
*/}}
{{- define "kubeflow.katib.containerSecurityContext" -}}
{{ include "kubeflow.component.containerSecurityContext" (
    list
    .Values.defaults.containerSecurityContext
    .Values.katib.containerSecurityContext
)}}
{{- end }}

{{/*
Kubeflow katib Scheduling.
*/}}
{{- define "kubeflow.katib.topologySpreadConstraints" -}}
{{ include "kubeflow.component.topologySpreadConstraints" (
    list
    .Values.defaults.topologySpreadConstraints
    .Values.katib.topologySpreadConstraints
)}}
{{- end }}

{{- define "kubeflow.katib.nodeSelector" -}}
{{ include "kubeflow.component.nodeSelector" (
    list
    .Values.defaults.nodeSelector
    .Values.katib.nodeSelector
)}}
{{- end }}

{{- define "kubeflow.katib.tolerations" -}}
{{ include "kubeflow.component.tolerations" (
    list
    .Values.defaults.tolerations
    .Values.katib.tolerations
)}}
{{- end }}

{{- define "kubeflow.katib.affinity" -}}
{{ include "kubeflow.component.affinity" (
    list
    .Values.defaults.affinity
    .Values.katib.affinity
)}}
{{- end }}

{{/*
Kubeflow katib enable and create toggles.
*/}}
{{- define "kubeflow.katib.enabled" -}}
{{- .Values.katib.enabled }}
{{- end }}

{{- define "kubeflow.katib.createIstioIntegrationObjects" -}}
{{- ternary true "" (
    and
    (include "kubeflow.katib.enabled" . | eq "true")
    .Values.istioIntegration.enabled
)}}
{{- end }}

{{- define "kubeflow.katib.rbac.createRoles" -}}
{{- and
    (include "kubeflow.katib.enabled" . | eq "true")
    .Values.katib.rbac.create }}
{{- end }}

{{- define "kubeflow.katib.createServiceAccount" -}}
{{- and
    (include "kubeflow.katib.enabled" . | eq "true")
    .Values.katib.serviceAccount.create
}}
{{- end }}

{{- define "kubeflow.katib.pdb.create" -}}
{{- include "kubeflow.component.pdb.create" (
    list
    (include "kubeflow.katib.enabled" .)
    .Values.defaults.podDisruptionBudget
    .Values.katib.podDisruptionBudget
)}}
{{- end }}

{{/*
Kubeflow Katib enable.
*/}}
{{- define "kubeflow.katib.enabled" -}}
{{- .Values.katib.enabled }}
{{- end }}
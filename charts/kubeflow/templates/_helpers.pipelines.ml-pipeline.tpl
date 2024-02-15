{{/*
ML Pipeline (ml-pipeline) is also known as Api Server (api-server)
*/}}

{{/*
Kubeflow Pipelines ML Pipeline object names.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.baseName" -}}
{{- printf "ml-pipeline" }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.pipelines.mlPipeline.baseName" .)
    .
)}}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.rbac.serviceAccountName" -}}
{{- include "kubeflow.component.serviceAccountName"  (
    list
    (include "kubeflow.pipelines.mlPipeline.name" .)
    .Values.pipelines.mlPipeline.rbac.serviceAccount)
}}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.roleName" -}}
{{- include "kubeflow.pipelines.mlPipeline.name" . }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.roleBindingName" -}}
{{- include "kubeflow.pipelines.mlPipeline.roleName" . }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.svc.name" -}}
{{ print (include "kubeflow.pipelines.mlPipeline.name" .) }}
{{- end }}

{{/*
Kubeflow Pipelines ML Pipeline object labels.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.pipelines.name" .) }}
{{ include "kubeflow.component.subcomponent.labels" (include "kubeflow.pipelines.mlPipeline.name" .) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.selectorLabels" -}}
{{ include "kubeflow.common.selectorLabels" . }}
{{ include "kubeflow.component.selectorLabels" (include "kubeflow.pipelines.name" .) }}
{{ include "kubeflow.component.subcomponent.labels" (include "kubeflow.pipelines.mlPipeline.name" .) }}
{{- end }}

{{/*
Kubeflow Pipelines ML Pipeline container image settings.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.image" -}}
{{ include "kubeflow.component.image" (list .Values.pipelines.image .Values.pipelines.mlPipeline.image) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.imagePullPolicy" -}}
{{ include "kubeflow.component.imagePullPolicy" (list .Values.pipelines.image .Values.pipelines.mlPipeline.image) }}
{{- end }}


{{/*
Kubeflow Pipelines ML Pipeline Autoscaling and Availability.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.autoscaling.enabled" -}}
{{ include "kubeflow.component.autoscaling.enabled" (list .Values.defaults.autoscaling .Values.pipelines.mlPipeline.autoscaling) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.autoscaling.minReplicas" -}}
{{ include "kubeflow.component.autoscaling.minReplicas" (list .Values.defaults.autoscaling .Values.pipelines.mlPipeline.autoscaling) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.autoscaling.maxReplicas" -}}
{{ include "kubeflow.component.autoscaling.maxReplicas" (list .Values.defaults.autoscaling .Values.pipelines.mlPipeline.autoscaling) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.autoscaling.targetCPUUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetCPUUtilizationPercentage" (list .Values.defaults.autoscaling .Values.pipelines.mlPipeline.autoscaling) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.autoscaling.targetMemoryUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetMemoryUtilizationPercentage" (list .Values.defaults.autoscaling .Values.pipelines.mlPipeline.autoscaling) }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.pdb.values" -}}
{{- include "kubeflow.component.pdb.values" (
    list
    .Values.defaults.podDisruptionBudget
    .Values.pipelines.mlPipeline.podDisruptionBudget
)}}
{{- end }}

{{/*
Kubeflow Pipelines ML Pipeline Security Context.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.containerSecurityContext" -}}
{{- include "kubeflow.component.containerSecurityContext" (
    list
    .Values.defaults.containerSecurityContext
    .Values.pipelines.mlPipeline.containerSecurityContext
)}}
{{- end }}

{{/*
Kubeflow Pipelines ML Pipeline Scheduling.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.topologySpreadConstraints" -}}
{{ include "kubeflow.component.topologySpreadConstraints" (
    list
    .Values.defaults.topologySpreadConstraints
    .Values.pipelines.mlPipeline.topologySpreadConstraints
)}}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.nodeSelector" -}}
{{ include "kubeflow.component.nodeSelector" (
    list
    .Values.defaults.nodeSelector
    .Values.pipelines.mlPipeline.nodeSelector
)}}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.tolerations" -}}
{{ include "kubeflow.component.tolerations" (
    list
    .Values.defaults.tolerations
    .Values.pipelines.mlPipeline.tolerations
)}}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.affinity" -}}
{{ include "kubeflow.component.affinity" (
    list
    .Values.defaults.affinity
    .Values.pipelines.mlPipeline.affinity
)}}
{{- end }}

{{/*
Kubeflow Pipelines ML Pipeline enable and create toggles.
*/}}
{{- define "kubeflow.pipelines.mlPipeline.enabled" -}}
{{- and
    (include "kubeflow.pipelines.enabled" . | eq "true")
    .Values.pipelines.mlPipeline.enabled
}}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.rbac.createRoles" -}}
{{- and
    (include "kubeflow.pipelines.mlPipeline.enabled" . | eq "true")
    .Values.pipelines.mlPipeline.rbac.create }}
{{- end }}

{{- define "kubeflow.pipelines.mlPipeline.rbac.createServiceAccount" -}}
{{- and
    (include "kubeflow.pipelines.mlPipeline.enabled" . | eq "true")
    (include "kubeflow.pipelines.mlPipeline.rbac.createRoles" . | eq "true")
    .Values.pipelines.mlPipeline.rbac.serviceAccount.create
}}
{{- end }}
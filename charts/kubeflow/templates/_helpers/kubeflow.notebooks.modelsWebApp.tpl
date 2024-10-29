{{/*
Kubeflow Notebooks Models Web App object names.
*/}}
{{- define "kubeflow.notebooks.modelsWebApp.baseName" -}}
{{- printf "models-web-app" }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.notebooks.modelsWebApp.baseName" .)
    .
)}}
{{- end }}

{{/*
Kubeflow Notebooks Models Web App enable and create toggles.
*/}}
{{- define "kubeflow.notebooks.modelsWebApp.enabled" -}}
{{- ternary true "" (
    and
    (include "kubeflow.notebooks.enabled" . | eq "true")
    .Values.notebooks.modelsWebApp.enabled
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.createServiceAccount" -}}
{{- ternary true "" (
and
    (include "kubeflow.notebooks.modelsWebApp.enabled" . | eq "true")
    .Values.notebooks.modelsWebApp.serviceAccount.create
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.serviceAccountName" -}}
{{- include "kubeflow.component.serviceAccountName"  (list (include "kubeflow.notebooks.modelsWebApp.name" .) .Values.notebooks.modelsWebApp.serviceAccount) }}
{{- end }}

{{/*
Kubeflow Notebooks Models Web App object labels.
*/}}
{{- define "kubeflow.notebooks.modelsWebApp.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.notebooks.name" .) }}
{{ include "kubeflow.component.subcomponent.labels" (include "kubeflow.notebooks.modelsWebApp.name" .) }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.configMapName" -}}
{{- printf "%s-%s" (include "kubeflow.notebooks.modelsWebApp.name" .) "viewer-spec" }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.mainClusterRoleName" -}}
{{- printf "%s-%s"
    (include "kubeflow.fullname" .)
    (include "kubeflow.notebooks.modelsWebApp.name" .)
}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.mainClusterRoleBindingName" -}}
{{- include "kubeflow.notebooks.modelsWebApp.mainClusterRoleName" . }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.rbac.createRole" -}}
{{- ternary true "" (
    and
    (include "kubeflow.notebooks.modelsWebApp.enabled" . | eq "true")
    .Values.notebooks.modelsWebApp.rbac.create
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.image" -}}
{{ include "kubeflow.component.image" (list .Values.defaults.image .Values.notebooks.modelsWebApp.image) }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.imagePullPolicy" -}}
{{ include "kubeflow.component.imagePullPolicy" (list .Values.defaults.image .Values.notebooks.modelsWebApp.image) }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.selectorLabels" -}}
{{ include "kubeflow.common.selectorLabels" . }}
{{ include "kubeflow.component.selectorLabels" (include "kubeflow.notebooks.name" .) }}
{{ include "kubeflow.component.subcomponent.labels" (include "kubeflow.notebooks.modelsWebApp.name" .) }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.svc.name" -}}
{{ include "kubeflow.component.svc.name" (
    include "kubeflow.notebooks.modelsWebApp.name" .
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.nodeSelector" -}}
{{ include "kubeflow.component.nodeSelector" (
    list
    .Values.defaults.nodeSelector
    .Values.notebooks.modelsWebApp.nodeSelector
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.tolerations" -}}
{{ include "kubeflow.component.tolerations" (
    list
    .Values.defaults.tolerations
    .Values.notebooks.modelsWebApp.tolerations
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.affinity" -}}
{{ include "kubeflow.component.affinity" (
    list
    .Values.defaults.affinity
    .Values.notebooks.modelsWebApp.affinity
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.topologySpreadConstraints" -}}
{{ include "kubeflow.component.topologySpreadConstraints" (
    list
    .Values.defaults.topologySpreadConstraints
    .Values.notebooks.modelsWebApp.topologySpreadConstraints
)}}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.autoscaling.enabled" -}}
{{ include "kubeflow.component.autoscaling.enabled" (list .Values.defaults.autoscaling .Values.notebooks.modelsWebApp.autoscaling) }}
{{- end }}

{{- define "kubeflow.notebooks.modelsWebApp.autoscaling.minReplicas" -}}
{{ include "kubeflow.component.autoscaling.minReplicas" (list .Values.defaults.autoscaling .Values.notebooks.modelsWebApp.autoscaling) }}
{{- end }}

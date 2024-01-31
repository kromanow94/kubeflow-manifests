{{- define "kubeflow.centraldashboard.baseName" -}}
{{- printf "centraldashboard" }}
{{- end }}

{{- define "kubeflow.centraldashboard.name" -}}
{{ include "kubeflow.centraldashboard.baseName" . }}
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
{{ include "kubeflow.component.image" (list .Values.defaults.image .Values.centraldashboard.image) }}
{{- end }}

{{- define "kubeflow.centraldashboard.imagePullPolicy" -}}
{{ include "kubeflow.component.imagePullPolicy" (list .Values.defaults.image .Values.centraldashboard.image) }}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.enabled" -}}
{{ include "kubeflow.component.autoscaling.enabled" (list .Values.defaults.autoscaling .Values.centraldashboard.autoscaling) }}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.minReplicas" -}}
{{ include "kubeflow.component.autoscaling.minReplicas" (list .Values.defaults.autoscaling .Values.centraldashboard.autoscaling) }}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.maxReplicas" -}}
{{ include "kubeflow.component.autoscaling.maxReplicas" (list .Values.defaults.autoscaling .Values.centraldashboard.autoscaling) }}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.targetCPUUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetCPUUtilizationPercentage" (list .Values.defaults.autoscaling .Values.centraldashboard.autoscaling) }}
{{- end }}

{{- define "kubeflow.centraldashboard.autoscaling.targetMemoryUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetMemoryUtilizationPercentage" (list .Values.defaults.autoscaling .Values.centraldashboard.autoscaling) }}
{{- end }}


{{- define "kubeflow.centraldashboard.nodeSelector" -}}
{{- if .Values.centraldashboard.nodeSelector -}}
  {{- toYaml .Values.centraldashboard.nodeSelector }}
{{- else if .Values.defaults.nodeSelector -}}
  {{- toYaml .Values.defaults.nodeSelector }}
{{- end }}
{{- end }}

{{- define "kubeflow.centraldashboard.tolerations" -}}
{{- if .Values.centraldashboard.tolerations -}}
  {{- toYaml .Values.centraldashboard.tolerations }}
{{- else if .Values.defaults.tolerations -}}
  {{- toYaml .Values.defaults.tolerations }}
{{- end }}
{{- end }}

{{- define "kubeflow.centraldashboard.affinity" -}}
{{- if .Values.centraldashboard.affinity -}}
  {{- toYaml .Values.centraldashboard.affinity }}
{{- else if .Values.defaults.affinity -}}
  {{- toYaml .Values.defaults.affinity }}
{{- end }}
{{- end }}

{{- define "kubeflow.centraldashboard.topologySpreadConstraints" -}}
{{- if .Values.centraldashboard.topologySpreadConstraints -}}
  {{- toYaml .Values.centraldashboard.topologySpreadConstraints }}
{{- else if .Values.defaults.topologySpreadConstraints -}}
  {{- toYaml .Values.defaults.topologySpreadConstraints }}
{{- end }}
{{- end }}

{{- define "kubeflow.centraldashboard.containerSecurityContext" -}}
{{ include "kubeflow.component.containerSecurityContext" (
    list
    .Values.defaults.containerSecurityContext
    .Values.centraldashboard.containerSecurityContext
)}}
{{- end }}


{{- define "kubeflow.centraldashboard.rbac.serviceAccountName" -}}
{{- include "kubeflow.component.serviceAccountName"  (list (include "kubeflow.centraldashboard.name" .) .Values.centraldashboard.rbac.serviceAccount) }}
{{- end }}

{{- define "kubeflow.centraldashboard.roleName" -}}
{{- include "kubeflow.centraldashboard.name" . }}
{{- end }}

{{- define "kubeflow.centraldashboard.roleBindingName" -}}
{{- include "kubeflow.centraldashboard.name" . }}
{{- end }}

{{- define "kubeflow.centraldashboard.clusterRoleName" -}}
{{- include "kubeflow.centraldashboard.name" . }}
{{- end }}

{{- define "kubeflow.centraldashboard.clusterRoleBindingName" -}}
{{- include "kubeflow.centraldashboard.name" . }}
{{- end }}

{{- define "kubeflow.centraldashboard.config.name" -}}
{{ printf "%s-config" (include "kubeflow.centraldashboard.name" .) }}
{{- end }}

{{- define "kubeflow.centraldashboard.svc.name" -}}
{{ print (include "kubeflow.centraldashboard.name" .) }}
{{- end }}

{{- define "kubeflow.centraldashboard.svc.host" -}}
{{ printf "%s.%s.svc.%s"
  (include "kubeflow.centraldashboard.svc.name" .)
  (include "kubeflow.namespace" .)
  .Values.clusterDomain
}}
{{- end }}

{{- define "kubeflow.centraldashboard.authorizationPolicyExtAuthName" -}}
{{ include "kubeflow.component.authorizationPolicyExtAuthName" (
    list
    (include "kubeflow.centraldashboard.name" .)
    .Values.istioIntegration
)}}
{{- end }}

{{- define "kubeflow.centraldashboard.enabled" -}}
{{- .Values.centraldashboard.enabled }}
{{- end }}

{{- define "kubeflow.centraldashboard.createIstioIntegrationObjects" -}}
{{- and
  (include "kubeflow.centraldashboard.enabled" . | eq "true" )
  .Values.istioIntegration.enabled }}
{{- end }}

{{- define "kubeflow.centraldashboard.rbac.createRoles" -}}
{{- and
    (include "kubeflow.centraldashboard.enabled" . | eq "true")
    .Values.centraldashboard.rbac.create }}
{{- end }}

{{- define "kubeflow.centraldashboard.rbac.createServiceAccount" -}}
{{- and
    (include "kubeflow.centraldashboard.enabled" . | eq "true")
    (include "kubeflow.centraldashboard.rbac.createRoles" . | eq "true")
    .Values.centraldashboard.rbac.serviceAccount.create
}}
{{- end }}

{{- define "kubeflow.centraldashboard.createPDB" -}}
{{- and
  .Values.centraldashboard.enabled
  .Values.centraldashboard.podDisruptionBudget }}
{{- end }}
{{/*
Kubeflow Katib dbmanager object names.
*/}}
{{- define "kubeflow.katib.dbmanager.baseName" -}}
{{- printf "katib-db-manager" }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.katib.dbmanager.baseName" .)
    .
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.serviceAccountName" -}}
{{- include "kubeflow.component.serviceAccountName"  (
    list
    (include "kubeflow.katib.dbmanager.name" .)
    .Values.dbmanager.serviceAccount
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.serviceAccountPrincipal" -}}
{{- include "kubeflow.component.serviceAccountPrincipal" (
    list
    .
    (include "kubeflow.katib.dbmanager.serviceAccountName" .)
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.mainClusterRoleName" -}}
{{- include "kubeflow.katib.dbmanager.name" . }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.mainClusterRoleBindingName" -}}
{{- include "kubeflow.katib.dbmanager.mainClusterRoleName" . }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.leaderElectionRoleName" -}}
{{- printf "%s-%s-%s"
    (include "kubeflow.fullname" .)
    (include "kubeflow.katib.dbmanager.name" .)
    "leader-election"
}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.leaderElectionRoleBindingName" -}}
{{- include "kubeflow.katib.dbmanager.leaderElectionRoleName" . }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.kfNbAdminClusterRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "katib-admin" }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.kfNbEditClusterRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "katib-edit" }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.kfNbViewClusterRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "katib-view" }}
{{- end }}

{{/*
Role Aggregation Rule Labels
*/}}
{{- define "kubeflow.katib.dbmanager.kfNbAdminClusterRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.katib.dbmanager.kfNbAdminClusterRoleName" .) -}}
{{- end }}

{{/*
Kubeflow Katib dbmanager Service.
*/}}
{{- define "kubeflow.katib.dbmanager.svc.name" -}}
{{ include "kubeflow.component.svc.name" (
    include "kubeflow.katib.dbmanager.name" .
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.svc.addressWithNs" -}}
{{ include "kubeflow.component.svc.addressWithNs"  (
    list
    .
    (include "kubeflow.katib.dbmanager.name" .)
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.svc.addressWithSvc" -}}
{{ include "kubeflow.component.svc.addressWithSvc"  (
    list
    .
    (include "kubeflow.katib.dbmanager.name" .)
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.svc.fqdn" -}}
{{ include "kubeflow.component.svc.fqdn"  (
    list
    .
    (include "kubeflow.katib.dbmanager.name" .)
)}}
{{- end }}

{{/*
Kubeflow Katib dbmanager object labels.
*/}}
{{- define "kubeflow.katib.dbmanager.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.katib.name" .) }}
{{ include "kubeflow.component.subcomponent.labels" (include "kubeflow.katib.dbmanager.name" .) }}
{{- end }}

{{- define "kubeflow.katib.dbmanager.selectorLabels" -}}
{{ include "kubeflow.common.selectorLabels" . }}
{{ include "kubeflow.component.selectorLabels" (include "kubeflow.katib.name" .) }}
{{ include "kubeflow.component.subcomponent.labels" (include "kubeflow.katib.dbmanager.name" .) }}
{{- end }}

{{/*
Kubeflow Katib dbmanager container image settings.
*/}}
{{- define "kubeflow.katib.dbmanager.image" -}}
{{ include "kubeflow.component.image" (
    list
    .Values.defaults.image
    .Values.dbmanager.image
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.imagePullPolicy" -}}
{{ include "kubeflow.component.imagePullPolicy" (
    list
    .Values.defaults.image
    .Values.dbmanager.image
)}}
{{- end }}

{{/*
Kubeflow Katib dbmanager Autoscaling and Availability.
*/}}
{{- define "kubeflow.katib.dbmanager.autoscaling.minReplicas" -}}
{{ include "kubeflow.component.autoscaling.minReplicas" (
    list
    .Values.defaults.autoscaling
    .Values.dbmanager.autoscaling
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.autoscaling.maxReplicas" -}}
{{ include "kubeflow.component.autoscaling.maxReplicas" (
    list
    .Values.defaults.autoscaling
    .Values.dbmanager.autoscaling
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.autoscaling.targetCPUUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetCPUUtilizationPercentage" (
    list
    .Values.defaults.autoscaling
    .Values.dbmanager.autoscaling
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.autoscaling.targetMemoryUtilizationPercentage" -}}
{{ include "kubeflow.component.autoscaling.targetMemoryUtilizationPercentage" (
    list
    .Values.defaults.autoscaling
    .Values.dbmanager.autoscaling
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.pdb.values" -}}
{{- include "kubeflow.component.pdb.values" (
    list
    .Values.defaults.podDisruptionBudget
    .Values.dbmanager.podDisruptionBudget
)}}
{{- end }}

{{/*
Kubeflow Katib dbmanager Security Context.
*/}}
{{- define "kubeflow.katib.dbmanager.containerSecurityContext" -}}
{{ include "kubeflow.component.containerSecurityContext" (
    list
    .Values.defaults.containerSecurityContext
    .Values.dbmanager.containerSecurityContext
)}}
{{- end }}

{{/*
Kubeflow Katib dbmanager Scheduling.
*/}}
{{- define "kubeflow.katib.dbmanager.topologySpreadConstraints" -}}
{{ include "kubeflow.component.topologySpreadConstraints" (
    list
    .Values.defaults.topologySpreadConstraints
    .Values.dbmanager.topologySpreadConstraints
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.nodeSelector" -}}
{{ include "kubeflow.component.nodeSelector" (
    list
    .Values.defaults.nodeSelector
    .Values.dbmanager.nodeSelector
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.tolerations" -}}
{{ include "kubeflow.component.tolerations" (
    list
    .Values.defaults.tolerations
    .Values.dbmanager.tolerations
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.affinity" -}}
{{ include "kubeflow.component.affinity" (
    list
    .Values.defaults.affinity
    .Values.dbmanager.affinity
)}}
{{- end }}

{{/*
Kubeflow Katib dbmanager enable and create toggles.
*/}}
{{- define "kubeflow.katib.dbmanager.enabled" -}}
{{- ternary true "" (
    and
    (include "kubeflow.katib.enabled" . | eq "true")
    .Values.dbmanager.enabled
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.autoscaling.enabled" -}}
{{ include "kubeflow.component.autoscaling.enabled" (
    list
    .Values.defaults.autoscaling
    .Values.dbmanager.autoscaling
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.rbac.createRoles" -}}
{{- ternary true "" (
    and
    (include "kubeflow.katib.dbmanager.enabled" . | eq "true")
    .Values.dbmanager.rbac.create
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.createServiceAccount" -}}
{{- ternary true "" (
and
    (include "kubeflow.katib.dbmanager.enabled" . | eq "true")
    .Values.dbmanager.serviceAccount.create
)}}
{{- end }}

{{- define "kubeflow.katib.dbmanager.pdb.create" -}}
{{- include "kubeflow.component.pdb.create" (
    list
    (include "kubeflow.katib.dbmanager.enabled" .)
    .Values.defaults.podDisruptionBudget
    .Values.dbmanager.podDisruptionBudget
)}}
{{- end }}

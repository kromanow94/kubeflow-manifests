{{- define "kubeflow.roles.baseName" -}}
{{- print "kubeflow-roles" }}
{{- end }}

{{- define "kubeflow.roles.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.roles.baseName" .)
    .
)}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.roles.name" .) }}
{{- end }}

{{/*
Kubeflow Main Role Names.
*/}}
{{- define "kubeflow.kubeflow-roles.kubeflowAdminRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "admin" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowEditRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "edit" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowViewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "view" }}
{{- end }}


{{/*
Kubeflow Kubernetes Role Names.
*/}}
{{- define "kubeflow.kubeflow-roles.kubernetesAdminRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "kubernetes-admin" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesEditRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "kubernetes-edit" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesViewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "kubernetes-view" }}
{{- end }}

{{/*
Kubeflow Pipelines Role Names.
*/}}
{{- define "kubeflow.kubeflow-roles.kubeflowPipelinesAdminRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "pipelines-admin" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowPipelinesEditRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "pipelines-edit" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowPipelinesViewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "pipelines-view" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.aggregateToKubeflowPipelinesEditRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "aggregate-pipelines-edit" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.aggregateToKubeflowPipelinesViewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "aggregate-pipelines-view" }}
{{- end }}

{{/*
    ###################################
    ### Role Aggreation Rule Labels ###
    ###################################
*/}}

{{/*
Kubeflow Main Role Labels.
*/}}
{{- define "kubeflow.kubeflow-roles.kubeflowAdminRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubeflowAdminRoleName" .) -}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowEditRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubeflowEditRoleName" .) -}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowViewRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubeflowViewRoleName" .) -}}
{{- end }}

{{/*
Kubeflow Kubernetes Role Labels.
*/}}
{{- define "kubeflow.kubeflow-roles.kubernetesAdminRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubernetesAdminRoleName" .) -}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesEditRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubernetesEditRoleName" .) -}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesViewRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubernetesViewRoleName" .) -}}
{{- end }}

{{/*
Kubeflow Pipelines Role Labels.
*/}}
{{- define "kubeflow.kubeflow-roles.kubeflowPipelinesAdminRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubeflowPipelinesAdminRoleName" .) -}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowPipelinesEditRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubeflowPipelinesEditRoleName" .) -}}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubeflowPipelinesViewRoleLabel" -}}
{{- include "kubeflow.aggregationRule.labelBase" (include "kubeflow.kubeflow-roles.kubeflowPipelinesViewRoleName" .) -}}
{{- end }}
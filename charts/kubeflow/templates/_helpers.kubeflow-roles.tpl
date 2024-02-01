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

{{- define "kubeflow.kubeflow-roles.adminRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "admin" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.editRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "edit" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.viewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "view" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesAdminRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "kubernetes-admin" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesEditRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "kubernetes-edit" }}
{{- end }}

{{- define "kubeflow.kubeflow-roles.kubernetesViewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "kubernetes-view" }}
{{- end }}
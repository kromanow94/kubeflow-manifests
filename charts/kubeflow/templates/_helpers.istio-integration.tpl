{{- define "kubeflow.istio-integration.name" -}}
{{- print "istio-integration" }}
{{- end }}

{{- define "kubeflow.istio-integration.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.istio-integration.name" .) }}
{{- end }}

{{- define "kubeflow.istio-integration.istioAdminRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "istio-admin" }}
{{- end }}

{{- define "kubeflow.istio-integration.istioEditRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "istio-edit" }}
{{- end }}

{{- define "kubeflow.istio-integration.istioViewRoleName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "istio-view" }}
{{- end }}
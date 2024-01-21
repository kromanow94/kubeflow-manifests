{{- define "kubeflow.notebooks.controller.name" -}}
{{- printf "notebook-controller" }}
{{- end }}

{{- define "kubeflow.notebooks.controller.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.notebooks.controller.name" .) }}
{{- end }}
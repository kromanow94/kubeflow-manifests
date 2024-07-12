{{/*
Knative Integration helpers.
*/}}

{{- define "kubeflow.knativeIntegration.enabled" -}}
{{- .Values.knativeIntegration.enabled }}
{{- end }}

{{- define "kubeflow.knativeIntegration.createIstioIntegrationObjects" -}}
{{- ternary true "" (
    and
    (include "kubeflow.knativeIntegration.enabled" . | eq "true")
    .Values.knativeIntegration.istioIntegration.enabled
)}}
{{- end }}

{{/*
Kubeflow Network Policies enable and create toggles.
*/}}
{{- define "kubeflow.networkPolicies.enabled" -}}
{{- ternary true "" (
    .Values.networkPolicies.enabled
)}}
{{- end }}

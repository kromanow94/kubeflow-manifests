{{- define "kubeflow.oauth2ProxyIntegration.istio.enabled" -}}
{{- ternary true "" (
    and
    .Values.istioIntegration.enabled
)}}
{{- end }}

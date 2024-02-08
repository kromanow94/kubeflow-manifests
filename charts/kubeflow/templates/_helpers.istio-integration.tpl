{{/*
Istio Integration object names.
*/}}

{{- define "kubeflow.istio-integration.baseName" -}}
{{- print "istio-integration" }}
{{- end }}

{{- define "kubeflow.istio-integration.name" -}}
{{- include "kubeflow.component.name" (
    list
    (include "kubeflow.istio-integration.baseName" .)
    .
)}}
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

{{- define "kubeflow.istio-integration.m2m.requestAuthenticationName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "m2m" }}
{{- end }}

{{- define "kubeflow.istio-integration.m2m.selfSigned.jobName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "configure-self-signed-m2m" }}
{{- end }}

{{- define "kubeflow.istio-integration.m2m.selfSigned.inClusterClusterRoleBindingName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "unauthenticated-oidc-viewer" }}
{{- end }}

{{- define "kubeflow.istio-integration.userAuth.requestAuthenticationName" -}}
{{- printf "%s-%s" (include "kubeflow.fullname" .) "user-auth" }}
{{- end }}

{{/*
Istio Integration object labels.
*/}}
{{- define "kubeflow.istio-integration.labels" -}}
{{ include "kubeflow.common.labels" . }}
{{ include "kubeflow.component.labels" (include "kubeflow.istio-integration.name" .) }}
{{- end }}

{{/*
Istio Integration enable and create toggles.
*/}}
{{- define "kubeflow.istio-integration.enabled" -}}
{{- .Values.istioIntegration.enabled }}
{{- end }}

{{- define "kubeflow.istio-integration.m2m.enabled" -}}
{{- and
  (include "kubeflow.istio-integration.enabled" . | eq "true" )
  .Values.istioIntegration.m2m.enabled
}}
{{- end }}

{{- define "kubeflow.istio-integration.m2m.selfSigned.autoJwksDiscovery" -}}
{{- and
  (include "kubeflow.istio-integration.enabled" . | eq "true" )
  .Values.istioIntegration.m2m.selfSigned.autoJwksDiscovery
}}
{{- end }}

{{- define "kubeflow.istio-integration.m2m.inCluster" -}}
{{- and
  (include "kubeflow.istio-integration.enabled" . | eq "true" )
  .Values.istioIntegration.m2m.inCluster
}}
{{- end }}
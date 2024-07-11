{{/*
Expand the name of the chart.
*/}}
{{- define "kubeflow.katib.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubeflow.katib.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubeflow.common.labels" -}}
helm.sh/chart: {{ include "kubeflow.katib.chart" . }}
{{ include "kubeflow.common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "kubeflow.common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kubeflow.katib.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component specific labels
*/}}
{{- define "kubeflow.component.labels" -}}
{{ include "kubeflow.component.selectorLabels" . }}
{{- end }}

{{/*
Component specific selector labels
*/}}
{{- define "kubeflow.component.selectorLabels" -}}
app.kubernetes.io/component: {{ . }}
{{- end }}

Namespace for all resources to be installed into
If not defined in values file then the helm release namespace is used
By default this is not set so the helm release namespace will be used

This gets around an problem within helm discussed here
https://github.com/helm/helm/issues/5358
{{- default .Values.namespace .Release.Namespace }}
*/}}
{{- define "kubeflow.namespace" -}}
{{- default .Release.Namespace .Values.namespace }}
{{- end -}}

{{- define "kubeflow.component.svc.fqdn" -}}
{{- $ctx := index . 0 -}}
{{- $componentName := index . 1 -}}
{{ printf "%s.%s.svc.%s"
    $componentName
    (include "kubeflow.namespace" $ctx)
    $ctx.Values.clusterDomain
}}
{{- end }}
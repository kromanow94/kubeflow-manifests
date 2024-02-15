{{/*
Expand the name of the chart.
*/}}
{{- define "kubeflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kubeflow.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kubeflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kubeflow.common.labels" -}}
helm.sh/chart: {{ include "kubeflow.chart" . }}
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
app.kubernetes.io/name: {{ include "kubeflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Kubeflow Component Names.

Changing this function will reflect on all component and subcomponent names.
*/}}
{{- define "kubeflow.component.name" -}}
{{- $componentName := index . 0 -}}
{{- $context := index . 1 -}}
{{- $componentName }}
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

{{/*
subcomponent specific labels
*/}}
{{- define "kubeflow.component.subcomponent.labels" -}}
{{ include "kubeflow.component.subcomponent.selectorLabels" . }}
{{- end }}

{{/*
subcomponent specific selector labels
*/}}
{{- define "kubeflow.component.subcomponent.selectorLabels" -}}
app.kubernetes.io/subcomponent: {{ . }}
{{- end }}

{{/*
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


{{- define "kubeflow.component.autoscaling.enabled" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- if eq nil $componentAutoscaling.enabled -}}
      {{- $defaultAutoscaling.enabled }}
  {{- else -}}
      {{- $componentAutoscaling.enabled }}
  {{- end -}}
{{- else -}}
  {{- $defaultAutoscaling.enabled }}
{{- end -}}
{{- end }}


{{- define "kubeflow.component.autoscaling.minReplicas" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- default $defaultAutoscaling.minReplicas $componentAutoscaling.minReplicas }}
{{- else -}}
  {{- $defaultAutoscaling.minReplicas }}
{{- end -}}
{{- end }}

{{- define "kubeflow.component.autoscaling.maxReplicas" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- default $defaultAutoscaling.maxReplicas $componentAutoscaling.maxReplicas }}
{{- else -}}
  {{- $defaultAutoscaling.maxReplicas }}
{{- end -}}
{{- end }}

{{- define "kubeflow.component.autoscaling.targetCPUUtilizationPercentage" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- default $defaultAutoscaling.targetCPUUtilizationPercentage $componentAutoscaling.targetCPUUtilizationPercentage }}
{{- else -}}
  {{- $defaultAutoscaling.targetCPUUtilizationPercentage }}
{{- end -}}
{{- end }}

{{- define "kubeflow.component.autoscaling.targetMemoryUtilizationPercentage" -}}
{{- $defaultAutoscaling := index . 0 -}}
{{- $componentAutoscaling := index . 1 -}}
{{- if $componentAutoscaling -}}
  {{- default $defaultAutoscaling.targetMemoryUtilizationPercentage $componentAutoscaling.targetMemoryUtilizationPercentage }}
{{- else -}}
  {{- $defaultAutoscaling.targetMemoryUtilizationPercentage }}
{{- end -}}
{{- end }}


{{- define "kubeflow.component.image" -}}
{{- $defaultImage := index . 0 -}}
{{- $componentImage := index . 1 -}}
{{- $registry := default $defaultImage.registry $componentImage.registryOverwrite -}}
{{- $repository :=  $componentImage.repository -}}
{{- $tag := default $defaultImage.tag $componentImage.tagOverwrite -}}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}

{{- define "kubeflow.component.imagePullPolicy" -}}
{{- $defaultImage := index . 0 -}}
{{- $componentImage := index . 1 -}}
{{- $pullPolicy := default $defaultImage.pullPolicy $componentImage.pullPolicyOverwrite -}}
{{- $pullPolicy }}
{{- end }}

{{- define "kubeflow.component.serviceAccountName" -}}
{{- $componentName := index . 0 -}}
{{- $componentSA := index . 1 -}}
{{- if $componentSA.create }}
  {{- default $componentName $componentSA.name }}
{{- else }}
  {{- default "default" $componentSA.name -}}
{{- end }}
{{- end }}

{{- define "kubeflow.component.authorizationPolicyExtAuthName" -}}
{{- $componentName := index . 0 -}}
{{- $istioIntegration := index . 1 -}}
{{- $providerName := $istioIntegration.envoyExtAuthzHttpExtensionProviderName -}}
{{ printf "%s-%s" $componentName $providerName }}
{{- end }}

{{/*
Kubeflow Component Security Context.
*/}}
{{- define "kubeflow.component.containerSecurityContext" -}}
{{- $defaultContext := index . 0 -}}
{{- $componentContext := index . 1 -}}
{{- if $componentContext -}}
  {{- toYaml $componentContext }}
{{- else if $defaultContext -}}
  {{- toYaml $defaultContext }}
{{- end }}
{{- end }}

{{/*
Kubeflow Component Scheduling.

TODO: investigate if this can be simply used like:
{{- include "mychart.affinity" . | nindent 8 }}
{{- include "mychart.nodeSelector" . | nindent 8 }}
{{- include "mychart.tolerations" . | nindent 8 }}
{{- include "mychart.topologySpreadConstraints" . | nindent 8 }}
https://chat.openai.com/share/c66d86ba-3b98-4942-a605-56b98889a313
*/}}
{{- define "kubeflow.component.topologySpreadConstraints" -}}
{{- $defaultConstraints := index . 0 -}}
{{- $componentConstraints := index . 1 -}}
{{- if $componentConstraints -}}
  {{- toYaml $componentConstraints }}
{{- else if $defaultConstraints -}}
  {{- toYaml $defaultConstraints }}
{{- end }}
{{- end }}

{{- define "kubeflow.component.nodeSelector" -}}
{{- $defaultNodeSelector := index . 0 -}}
{{- $componentNodeSelector := index . 1 -}}
{{- if $componentNodeSelector -}}
  {{- toYaml $componentNodeSelector }}
{{- else if $defaultNodeSelector -}}
  {{- toYaml $defaultNodeSelector }}
{{- end }}
{{- end }}

{{- define "kubeflow.component.tolerations" -}}
{{- $defaultTolerations := index . 0 -}}
{{- $componentTolerations := index . 1 -}}
{{- if $componentTolerations -}}
  {{- toYaml $componentTolerations }}
{{- else if $defaultTolerations -}}
  {{- toYaml $defaultTolerations }}
{{- end }}
{{- end }}

{{- define "kubeflow.component.affinity" -}}
{{- $defaultAffinity := index . 0 -}}
{{- $componentAffinity := index . 1 -}}
{{- if $componentAffinity -}}
  {{- toYaml $componentAffinity }}
{{- else if $defaultAffinity -}}
  {{- toYaml $defaultAffinity }}
{{- end }}
{{- end }}

{{- define "kubeflow.component.pdb.create" -}}
{{- $componentEnabled := index . 0 -}}
{{- $defaultPDB := index . 1 -}}
{{- $componentPDB := index . 2 -}}
{{- and
  (or $defaultPDB $componentPDB)
  ($componentEnabled | eq "true")
}}
{{- end }}

{{- define "kubeflow.component.pdb.values" -}}
{{- $defaultPDB := index . 0 -}}
{{- $componentPDB := index . 1 -}}
{{ toYaml (default $defaultPDB $componentPDB) }}
{{- end }}
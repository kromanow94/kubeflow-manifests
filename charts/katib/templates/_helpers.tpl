{{- define "katib.db-secret" -}}
{{- default .Values.database.type }}
{{- end }}
{{/* Generate a full name */}}
{{- define "springboot-postgres.fullname" -}}
{{- printf "%s" .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/* Standard labels */}}
{{- define "springboot-postgres.labels" -}}
app.kubernetes.io/name: {{ include "springboot-postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "springboot-postgres.name" -}}
{{- .Chart.Name -}}
{{- end }}
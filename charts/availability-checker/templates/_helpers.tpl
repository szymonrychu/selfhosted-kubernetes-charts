{{/*
Expand the name of the chart.
*/}}
{{- define "availability-checker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "availability-checker.fullname" -}}
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
{{- define "availability-checker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "availability-checker.labels" -}}
helm.sh/chart: {{ include "availability-checker.chart" . }}
{{ include "availability-checker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "availability-checker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "availability-checker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of nodeRebooter service account to use
*/}}
{{- define "availability-checker.nodeRebooter.serviceAccountName" -}}
{{- if .Values.nodeRebooter.serviceAccount.create }}
{{- default (include "availability-checker.fullname" .) .Values.nodeRebooter.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.nodeRebooter.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of ingressHostsChecker service account to use
*/}}
{{- define "availability-checker.ingressHostsChecker.serviceAccountName" -}}
{{- if .Values.ingressHostsChecker.serviceAccount.create }}
{{- default (include "availability-checker.fullname" .) .Values.ingressHostsChecker.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.ingressHostsChecker.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "cas-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cas-server.fullname" -}}
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
{{- define "cas-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cas-server.labels" -}}
helm.sh/chart: {{ include "cas-server.chart" . }}
{{ include "cas-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cas-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cas-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cas-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cas-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper cas-server image name
*/}}
{{- define "cas-server.imageName" -}}
{{- $repositoryName := .Values.image.repository  | toString -}}
{{- $registryName := default "" .Values.image.registry  | toString -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag  | toString -}}
{{- if ne $registryName "" }}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
    {{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return log directory volume
*/}}
{{- define "cas-server.logdir" -}}
{{- if .Values.logdir.hostPath }}
hostPath:
  path: {{ .Values.logdir.hostPath }}
  type: Directory
{{- else if .Values.logdir.claimName }}
persistentVolumeClaim:
  claimName: {{ .Values.logdir.claimName }}
{{- else }}
emptyDir: {}
{{- end }}
{{- end -}}

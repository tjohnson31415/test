{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "product-abc.chart" -}}
  {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "product-abc.fullname" -}}
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
Common labels
*/}}
{{- define "product-abc.labels" -}}
  {{- $params := . -}}
  {{- $root := index $params 0 -}}
  {{- $compName := index $params 1 -}}
helm.sh/chart: {{ include "product-abc.chart" $root }}
{{ include "product-abc.selectorLabels" (list $root $compName) }}
{{- if $root.Chart.AppVersion }}
app.kubernetes.io/version: {{ $root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $root.Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "product-abc.selectorLabels" -}}
  {{- $params := . -}}
  {{- $root := index $params 0 -}}
  {{- $compName := index $params 1 -}}
app.kubernetes.io/name: {{ include "product-abc.fullname" $root }}
app.kubernetes.io/component: {{ $compName }}
app.kubernetes.io/instance: {{ $root.Release.Name }}
{{- end }}

{{/*
Image reference
*/}}
{{- define "product-abc.image" -}}
  {{- $params := . -}}
  {{- $root := index $params 0 -}}
  {{- $imageName := index $params 1 -}}

  {{- $registry := $root.Values.imageRegistry }}
  {{- with (index $root.Values.images $imageName) }}
    {{- if .digest -}}
{{ printf "%s/%s@%s" $registry .repository .digest }}
    {{- else -}}
{{ printf "%s/%s:%s" $registry .repository .tag }}
    {{- end }}
  {{- end }}
{{- end }}

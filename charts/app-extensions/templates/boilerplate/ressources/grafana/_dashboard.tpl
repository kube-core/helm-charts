{{- define "app-extensions.grafana-dashboard" -}}
{{- $values := .value }}
{{- $common := .common }}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}

apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDashboard
metadata:
  name: {{ $resourceName }}
spec:
  instanceSelector:
    matchLabels:
      dashboards: "grafana"
  folder: {{ $values.folder }}
  datasources:
    {{- toYaml $values.datasources | nindent 4 }}
  plugins:
    {{- toYaml $values.plugins | nindent 4 }}
  {{- if $values.source.url }}
  url: {{ $values.source.url }}
  {{- else if $values.source.grafana.id }}
  grafanaCom:
    id: {{ $values.source.grafana.id }}
    revision: {{ $values.source.grafana.revision | default "null" }}
  {{- end }}
{{- end }}

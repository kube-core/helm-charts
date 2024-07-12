{{- define "app-extensions.grafana-datasource" -}}
{{- $values := .value }}
{{- $common := .common }}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}

apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDatasource
metadata:
  name: {{ $resourceName }}
spec:
  instanceSelector:
    matchLabels:
      dashboards: "grafana"
  datasource:
    name: {{ $resourceName }}
    type: {{ $values.type }}
    access: proxy
    url: {{ $values.url }}
    isDefault: {{ $values.isDefault }}
    jsonData:
      {{- toYaml $values.jsonData | nindent 6 }}
  plugins:
    {{- toYaml $values.plugins | nindent 4 }}
{{- end }}

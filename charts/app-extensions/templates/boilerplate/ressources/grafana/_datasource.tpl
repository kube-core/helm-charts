{{- define "app-extensions.grafana-datasource" -}}
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
    name: prom1
    type: prometheus
    access: proxy
    url: http://prometheus-service:9090
    isDefault: true
    jsonData:
      "tlsSkipVerify": true
      "timeInterval": "5s"
{{- end }}

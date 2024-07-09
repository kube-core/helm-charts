{{- define "app-extensions.grafana-dashboard" -}}
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
  folder: "custom folder"
  url: "https://raw.githubusercontent.com/grafana-operator/grafana-operator/master/examples/dashboard_from_url/dashboard.json"
{{- end }}

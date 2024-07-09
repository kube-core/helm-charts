{{- define "app-extensions.grafana" -}}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}
apiVersion: grafana.integreatly.org/v1beta1
kind: Grafana
metadata:
  name: {{ $resourceName }}
    labels:
      dashboards: "grafana"
spec:
  config:
    log:
      mode: "console"
      console:
        format: "json"
    auth:
      disable_login_form: "false"
    security:
      admin_user: root
      admin_password: secret
  deployment:
    spec:
      template:
        spec:
          containers:
            - name: grafana
              env:
                - name: GF_SECURITY_ADMIN_USER
                  valueFrom:
                    secretKeyRef:
                      key: GF_SECURITY_ADMIN_USER
                      name: credentials
                - name: GF_SECURITY_ADMIN_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      key: GF_SECURITY_ADMIN_PASSWORD
                      name: credentials
{{- end }}

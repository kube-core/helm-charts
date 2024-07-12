{{- define "app-extensions.grafana-instance" }}
{{- $values := .value }}
{{- $common := .common }}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}

{{- $settings := $values.settings }}

apiVersion: grafana.integreatly.org/v1beta1
kind: Grafana
metadata:
  name: {{ $resourceName }}
  labels:
    dashboards: "grafana" ## TO REVIEW
spec:
  config:
    log:
      mode: "console"
    log.console:
      format: "json"
    {{- if $settings.anonymousUsers.allowAccess }}
    auth.anonymous:
      enabled: "true"
      org_role: {{ $settings.anonymousUsers.defaultRole | quote }}
      hide_version: "true"
    {{- end }}
    security:
      admin_user: {{ $settings.admin.userName }}
      {{- if not $settings.admin.passwordSecretRef.name }}
      admin_password: {{ $settings.admin.password | quote }}
      {{- end }}
    date_formats:
      full_date: {{ $settings.dateFormats.fullDate | quote }}
      interval_second: {{ $settings.dateFormats.intervals.intervalSecond | quote }}
      interval_minute: {{ $settings.dateFormats.intervals.intervalMinute | quote }}
      interval_hour: {{ $settings.dateFormats.intervals.intervalHour | quote }}
      interval_day: {{ $settings.dateFormats.intervals.intervalDay | quote }}
      interval_month: {{ $settings.dateFormats.intervals.intervalMonth | quote }}
      interval_year: {{ $settings.dateFormats.intervals.intervalYear | quote }}
      default_timezone: {{ $settings.dateFormats.defaultTimezone| quote }}
      default_week_start: {{ $settings.dateFormats.defaultWeekStart | quote }}
  deployment:
    spec:
      template:
        metadata:
          labels:
            {{- toYaml $values.labels| nindent 12 }}
        {{- if $settings.admin.passwordSecretRef.name }}
        spec:
          containers:
            - name: grafana
              env:
                - name: GF_SECURITY_ADMIN_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      key: {{ $settings.admin.passwordSecretRef.key }}
                      name: {{ $settings.admin.passwordSecretRef.name }}
          {{- end }}
  service:
    metadata:
      labels:
        {{- toYaml $values.labels| nindent 8 }}


{{- end }}

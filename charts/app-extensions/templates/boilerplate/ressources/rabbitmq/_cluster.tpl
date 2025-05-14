{{- define "app-extensions.rabbitmq-cluster" -}}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}
{{- $namespace := (coalesce .value.namespace "default") }}

apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: {{ $name }}
spec:
  replicas: {{ coalesce .value.replicaCount 1 }}
  {{- if .value.image }}
  image: {{ .value.image }}
  {{- end }}
  {{- if or .value.resources.limits .value.resources.requests }}
  resources:
    {{- if .value.resources.limits }}
    limits:
    {{- toYaml .value.resources.limits | nindent 6 }}
    {{- end }}
    {{- if .value.resources.requests }}
    requests:
    {{- toYaml .value.resources.requests | nindent 6 }}
    {{- end }}
  {{- end }}
  persistence:
    storage: {{ coalesce .value.storageSize "10Gi" }}
    {{ if .value.storageClassName }}
    storageClassName: {{ .value.storageClassName }}
    {{ end }}
  {{- if .value.affinity }}
  affinity: {{ toYaml .value.affinity | nindent 4 }}
  {{- end }}
  {{- if .value.tolerations }}
  tolerations: {{ toYaml .value.tolerations | nindent 4 }}
  {{- end }}
  {{- if .value.rabbitmq }}
  rabbitmq: {{ toYaml .value.rabbitmq | nindent 4 }}
  {{- else }}
  rabbitmq:
    additionalConfig: |
      log.console.level = error
      prometheus.return_per_object_metrics = true
  {{- end }}
  override:
    {{- if not .value.override }}
    statefulSet:
      metadata:
        labels: {{ toYaml .value.statefulSetLabels | nindent 10 }}
      spec:
        template:
          metadata:
            labels:
              logging.kube-core.io/flow-name: {{ coalesce .value.logFlow "app" }}
              {{- if .value.podLabels }}
              {{ toYaml .value.podLabels | indent 12 }}
              {{- end }}
          {{- if .value.nodeSelector }}
          spec:
            nodeSelector: {{ toYaml .value.nodeSelector | nindent 14 }}
          {{- end }}
    {{- else }}
    {{- toYaml .value.override | nindent 6 }}
    {{- end }}
  {{- with .value.extraSpec }}
    {{- toYaml . | nindent 4 }}
  {{- end }}

{{ end }}

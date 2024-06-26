{{ if eq .Values.flux.enabled true }}
{{ if eq .Values.flux.imageUpdateAutomation.enabled true }}
apiVersion: image.toolkit.fluxcd.io/v1beta1
kind: ImageUpdateAutomation
metadata:
  name: {{ .Values.name }}
  labels:
    {{- include "app.labels" . | nindent 4 }}
spec:
  interval: 1m0s
  sourceRef:
    kind: GitRepository
    name: {{ .Values.flux.imageUpdateAutomation.git.sourceRef }}
    {{ if .Values.flux.imageUpdateAutomation.git.sourceNamespace }}
    namespace: {{.Values.flux.imageUpdateAutomation.git.sourceNamespace}}
    {{ end }}
  git:
    checkout:
      ref: {{ toYaml .Values.flux.imageUpdateAutomation.git.ref | nindent 8 }}
    commit:
      author: {{ toYaml .Values.flux.imageUpdateAutomation.git.author | nindent 8 }}
      messageTemplate: {{ .Values.flux.imageUpdateAutomation.git.message | quote }}
    push: {{ toYaml .Values.flux.imageUpdateAutomation.git.pushRef | nindent 6 }}
  update: {{ toYaml .Values.flux.imageUpdateAutomation.update | nindent 4 }}

{{ end }}
{{ end }}

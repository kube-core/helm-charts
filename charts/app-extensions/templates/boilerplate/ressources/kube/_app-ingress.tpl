{{- define "app-extensions.app-ingress" }}
{{- $values := .value }}
{{- $common := .common }}
{{- $name := (coalesce $values.name .key) }}
{{- $resourceName := (coalesce $values.resourceName $values.name .key) }}
{{- $composition := .composition }}
{{- $components := $composition.components }}
{{- $namespace := (coalesce $composition.namespace $values.namespace "default") }}

{{- $service := index $components "kube-service" }}


{{- $maintenanceModeEnabled := $composition.config.maintenanceMode.enabled | default false }}
{{- $blueGreenModeEnabled := $composition.config.blueGreenMode.enabled | default false }}
{{- $isMain := eq $values.type "main" }}
{{- $svcPort := $service.port -}}
{{- $svcName := coalesce $values.svcName $name }}


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $resourceName }}
  namespace: {{ $namespace }}
  {{- include "app.ingress-metadata" . | nindent 2 }}
spec:
  ingressClassName: {{ $values.className }}
  {{- if $values.host }}
  rules:
  - host: {{ $values.host }}
    http:
      paths:
      - backend:
          service:
            name: {{ $svcName }}
            port:
              number: {{ $svcPort }}
        path: /
        pathType: ImplementationSpecific
  tls:
  - hosts:
    - {{ $values.host }}
    secretName: {{ (printf "%s-tls-cert" $values.host) | replace "." "-" }}
{{- end }}
{{- end }}

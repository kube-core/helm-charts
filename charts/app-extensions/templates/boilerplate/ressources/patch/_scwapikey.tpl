{{- define "app-extensions.patch-scwapikey" -}}
{{- $name := (coalesce .value.name .key) }}
{{- $resourceName := (coalesce .value.resourceName .value.name .key) }}

apiVersion: redhatcop.redhat.io/v1alpha1
kind: Patch
metadata:
  name: {{ $name }}
spec:
  serviceAccountRef:
    name: {{ .common.patch.serviceAccountName }}
  patches:
    path-scw-api-key-secret:
      targetObjectRef:
        apiVersion: v1
        kind: Secret
        name: {{ coalesce .value.appName $name }}
      patchTemplate: |
        stringData:
          access_key: {{ `{{ (index . 1).status.atProvider.accessKey }}` }}
          secret_key: {{ `{{ index (index . 0).data "attribute.secret_key" | b64dec }}` }}
          scw_access_key: {{ `{{ (index . 1).status.atProvider.accessKey }}` }}
          scw_secret_key: {{ `{{ index (index . 0).data "attribute.secret_key" | b64dec }}` }}
          registry_user: {{ .common.cloud.projectShortName }}-{{ .common.cluster.config.name }}
          registry_auth: {{ .common.cloud.projectShortName }}-{{ .common.cluster.config.name }}:{{ `{{ index (index . 0).data "attribute.secret_key" | b64dec }}` }}
          cloud: |
            [default]
            aws_access_key_id={{ `{{ (index . 1).status.atProvider.accessKey }}` }}
            aws_secret_access_key={{ `{{ index (index . 0).data "attribute.secret_key" | b64dec }}` }}
      patchType: application/merge-patch+json
      sourceObjectRefs:
      - apiVersion: iam.scaleway.upbound.io/v1alpha1
        kind: ApiKey
        name: {{ coalesce .value.appName $name }}
{{- end }}

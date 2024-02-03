{{- define "oauth2proxy.configmap" -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "oauth2proxy.fullname" . }}-proxy
  labels:
    {{- include "oauth2proxy.labels" . | nindent 4 }}
data:
  redirect-url: {{ .Values.oauth2proxy.redirectUrl | quote }}
  realm-url: {{ .Values.oauth2proxy.realmUrl | quote }}
  cookie-name: {{ .Values.oauth2proxy.cookieName | quote }}
  cookie-domain: {{ .Values.oauth2proxy.cookieDomain | quote }}
  allowed-groups: {{ .Values.oauth2proxy.allowedGroups | quote }}
{{- end }}

{{- define "oauth2proxy.secret" -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "oauth2proxy.fullname" . }}-proxy
  labels:
    {{- include "oauth2proxy.labels" . | nindent 4 }}
type: Opaque
data:
  client-id: {{ .Values.oauth2proxy.clientId | b64enc | quote }}
  client-secret: {{ .Values.oauth2proxy.clientSecret | b64enc | quote }}
  cookie-secret: {{ .Values.oauth2proxy.cookieSecret | b64enc | quote }}
{{- end }}

{{- define "oauth2proxy.service" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "oauth2proxy.fullname" . }}-proxy
  labels:
    {{- include "oauth2proxy.labels" . | nindent 4 }}
spec:
  type: {{ .Values.oauth2proxy.service.type }}
  ports:
    - port: {{ .Values.oauth2proxy.service.port }}
      targetPort: oauth2-http
      protocol: TCP
      name: http
  selector:
    {{- include "oauth2proxy.selectorLabels" . | nindent 4 }}
{{- end }}

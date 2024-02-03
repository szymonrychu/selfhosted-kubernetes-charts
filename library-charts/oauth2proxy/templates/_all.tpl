{{- define "oauth2proxy.all" }}
{{ include "oauth2proxy.configmap" . }}
{{ include "oauth2proxy.secret" . }}
{{ include "oauth2proxy.service" . }}
{{- end }}
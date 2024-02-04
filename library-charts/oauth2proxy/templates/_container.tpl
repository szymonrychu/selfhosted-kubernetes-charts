{{- define "oauth2proxy.container" -}}
name: proxy
securityContext:
  {{- toYaml .Values.oauth2proxy.securityContext | nindent 2 }}
image: "{{ .Values.oauth2proxy.image.repository }}:{{ .Values.oauth2proxy.image.tag }}"
imagePullPolicy: {{ .Values.oauth2proxy.image.pullPolicy }}
resources:
  {{- toYaml .Values.oauth2proxy.resources | nindent 2 }}
env:
  - name: OAUTH2_PROXY_PROVIDER
    value: keycloak-oidc
  - name: OAUTH2_PROXY_HTTP_ADDRESS
    value: 0.0.0.0:4180
  - name: OAUTH2_PROXY_REVERSE_PROXY
    value: "true"
  - name: OAUTH2_PROXY_SKIP_PROVIDER_BUTTON
    value: "true"
  - name: OAUTH2_PROXY_UPSTREAMS
    value: http://localhost:{{ .Values.oauth2proxy.upstreamPort}}
  - name: OAUTH2_PROXY_SESSION_COOKIE_MINIMAL
    value: "true"
  - name: OAUTH2_PROXY_EMAIL_DOMAINS
    value: "*"
  - name: OAUTH2_PROXY_ALLOWED_GROUPS
    valueFrom:
      configMapKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: allowed-groups
  - name: OAUTH2_PROXY_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: client-id
  - name: OAUTH2_PROXY_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: client-secret
  - name: OAUTH2_PROXY_REDIRECT_URL
    valueFrom:
      configMapKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: redirect-url
  - name: OAUTH2_PROXY_OIDC_ISSUER_URL
    valueFrom:
      configMapKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: realm-url
  - name: OAUTH2_PROXY_COOKIE_NAME
    valueFrom:
      configMapKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: cookie-name
  - name: OAUTH2_PROXY_COOKIE_DOMAIN
    valueFrom:
      configMapKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: cookie-domain
  - name: OAUTH2_PROXY_COOKIE_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ include "oauth2proxy.fullname" . }}-proxy
        key: cookie-secret
ports:
  - name: oauth2-http
    containerPort: 4180
    protocol: TCP
livenessProbe:
  tcpSocket:
    port: oauth2-http
readinessProbe:
  tcpSocket:
    port: oauth2-http
resources:
  {{- toYaml .Values.oauth2proxy.resources | nindent 2 }}
{{- end }}
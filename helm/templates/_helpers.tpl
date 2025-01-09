{{/*
Define ports for the pods
*/}}
{{- define "chart.container-port" -}}
{{-  default "8000" .Values.containerPort }}
{{- end }}

{{/*
Define service name
*/}}
{{- define "chart.service-name" -}}
{{-  if .Values.serviceName }}
{{-    .Values.serviceName | lower | trim }}
{{-  else }}
"{{ .Release.Name }}-service"
{{-  end }}
{{- end }}

{{/*
Define service port
*/}}
{{- define "chart.service-port" -}}
{{-  if .Values.servicePort }}
{{-    .Values.servicePort }}
{{-  else }}
{{-    include "chart.container-port" . }}
{{-  end }}
{{- end }}

{{/*
Define service port name
*/}}
{{- define "chart.service-port-name" -}}
"service-port"
{{- end }}

{{/*
Define container port name
*/}}
{{- define "chart.container-port-name" -}}
"container-port"
{{- end }}

{{/*
Define deployment strategy
*/}}
{{- define "chart.strategy" -}}
strategy:
  rollingUpdate:
    maxSurge: 100%
    maxUnavailable: 0
{{- end }}

{{/*
Define additional ports
*/}}
{{- define "chart.extraPorts" }}
{{-   with .Values.extraPorts }}
{{      toYaml . }}
{{-   end }}
{{- end }}


{{/*
Define liveness et readiness probes
*/}}
{{- define "chart.probes" -}}
{{-   if .Values.readinessProbe  }}
readinessProbe:
{{-     with .Values.readinessProbe }}
{{-       toYaml . | nindent 2 }}
{{-     end }}
{{-   end }}
{{-   if .Values.livenessProbe  }}
livenessProbe:
{{-     with .Values.livenessProbe }}
{{-       toYaml . | nindent 2 }}
{{-     end }}
{{-   end }}
{{- end }}

{{/*
Define resources
*/}}
{{- define "chart.resources" -}}
requests:
  memory: {{ required "Value 'resources.requests.memory' must be defined !" .Values.resources.requests.memory | quote }}
  cpu: {{ required "Value 'resources.requests.cpu' must be defined !" .Values.resources.requests.cpu | quote }}
  {{- if and (gt (int (index .Values.resources.requests "nvidia.com/gpu")) 0) (gt (int (index .Values.resources.limits "nvidia.com/gpu")) 0) }}
  nvidia.com/gpu: {{ required "Value 'resources.requests.nvidia.com/gpu' must be defined !" (index .Values.resources.requests "nvidia.com/gpu") | quote }}
  {{- end }}
limits:
  memory: {{ required "Value 'resources.limits.memory' must be defined !" .Values.resources.limits.memory | quote }}
  cpu: {{ required "Value 'resources.limits.cpu' must be defined !" .Values.resources.limits.cpu | quote }}
  {{- if and (gt (int (index .Values.resources.requests "nvidia.com/gpu")) 0) (gt (int (index .Values.resources.limits "nvidia.com/gpu")) 0) }}
  nvidia.com/gpu: {{ required "Value 'resources.limits.nvidia.com/gpu' must be defined !" (index .Values.resources.limits "nvidia.com/gpu") | quote }}
  {{- end }}
{{- end }}


{{/*
Define User used for the main container
*/}}
{{- define "chart.user" }}
{{-   if .Values.image.runAsUser  }}
runAsUser: 
{{-     with .Values.runAsUser }}
{{-       toYaml . | nindent 2 }}
{{-     end }}
{{-   end }}
{{- end }}

{{/*
  Define chart labels
*/}}
{{- define "chart.labels" -}}
{{-   with .Values.labels -}}
{{      toYaml . }}
{{-   end }}
{{- end }}


{{/*
  Define helper function to convert labels to a comma separated list
*/}}
{{- define "labels.toCommaSeparatedList" -}}
{{- $labels := . -}}
{{- $result := "" -}}
{{- range $key, $value := $labels -}}
  {{- if $result }},{{ end -}}
  {{ $key }}={{ $value }}
  {{- $result = "," -}}
{{- end -}}
{{- end -}}


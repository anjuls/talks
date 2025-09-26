#import "@preview/touying:0.6.1": *
#import themes.dewdrop: *
#import "@preview/gentle-clues:1.2.0": *
#import "@preview/tiaoma:0.3.0": *

#set text(font: "Helvetica")


#show: dewdrop-theme.with(
  aspect-ratio: "16-9",
  footer: [Kubernetes and Cloud Native],
  navigation: "none",
  config-info(
    title: [All about Kubernetes and Cloud Native],
    // subtitle: [Level 0],
    author: [Anjul Sahu],
    // institution: [CloudRaft],
    date: datetime.today(),
  ),
  config-colors(
  neutral-darkest: rgb("#000000"),
  neutral-dark: rgb("#202020"),
  neutral-light: rgb("#f3f3f3"),
  neutral-lightest: rgb("#ffffff"),
  primary: rgb("#4f2cc1"),
  secondary: rgb("#e35323"),
)
)

#show link: underline

#title-slide()

== Agenda
- About me
- Some history of Kubernetes
- Basics
- More than basics
- Q&A time

== About Me
- Anjul Sahu
- Founder and CEO, CloudRaft
- Started in December 2022
- Specializing in Kubernetes and Cloud Native technologies, AI Infrastructure, Databases and Observability
- 2008 - 2022: Worked at Accenture, InfraCloud, and Lummo

#focus-slide("Excited to learn about Kubernetes?")

== What is Kubernetes?
#v(1cm)
#set text(size: 20pt)

#quote[_Kubernetes is the orchestration system._]

#quote[_Kubernetes is becoming like Linux. It is everywhere but abstracted, invisible to you._]

#quote[_Kubernetes is the operating system of Cloud._]

== Why everyone love Kubernetes?
#pause
- Most popular and biggest open source project after Linux
- Autoscaling (horizontal, vertical, more complex strategies with keda, custom)
- scheduling is easy and managed
- operational automation is easy
- proven at scale and global standard, battle tested at Google (Borg)
- customization flexibility
- AI/ML ecosystem is growing, Kubernetes is go to orchestration layer

== Some basics
- #link("https://github.com/anjuls/talks/blob/main/Kubernetes%20for%20Beginners%20-%20Anjul%20Sahu.pdf")[2023 talk]

== Beyond Basics
- *Packaging and Deployment* - Helm Charts, Kustomize, ArgoCD (GitOps)
- *Monitoring and Observability* - Prometheus, Grafana, Loki (PLG) stack, or Elastic stack, OpenTelemetry
- *Service Mesh* - Istio, Linkerd, Envoy - for Reliability, Security, and Control
- *Security* - Network Policies (need support from CNI), Dynamic runtime security (tetragon, falco)
- *Storage* - CSI - both block storage and object storage is available
- *Extensibility* - Extend it via custom resource and Operator pattern

== Helm
#slide(
  [
    Templating engine that can render Kubernetes YAMLs. Control things using a `values.yaml`
    #set text(size: 12pt)
    ```bash
    .
    ├── Chart.yaml
    ├── templates
    │   ├── _helpers.tpl
    │   ├── configmap.yaml
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── NOTES.txt
    │   ├── service.yaml
    │   └── tests
    │       └── test-connection.yaml
    └── values.yaml
    ```

  ],
  [
    _Example template for Service_
    #set text(size: 14pt)
    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: {{ include "service.fullname" . }}
      labels:
        {{- include "service.labels" . | nindent 4 }}
    spec:
      type: {{ .Values.service.type }}
      ports:
        - port: {{ .Values.service.port }}
          targetPort: http
          protocol: TCP
          name: http
      selector:
        {{- include "service.selectorLabels" . | nindent 4 }}
    ```
  ],
)

== Kustomize

#slide(
  [
    - To solve the mess of YAMLs, Kustomize was created.
    - Learn more at #link("kustomize.io")
  ],
  [

    ```yaml
    apiVersion: kustomize.config.k8s.io/v1beta1
    kind: Kustomization
    namespace: ad-adapter

    helmGlobals:
        chartHome: ../../../helm-charts
    helmCharts:
      - name: fancy-service
        releaseName: ad-adapter
        version: 0.1.0
        valuesFile: values.yaml
    ```
  ],
)



== ArgoCD (GitOps)
- Save the configuration in git and sync it with a branch
- Any change in cluster is reverted, will sync it back with git
- Idea is to have all infra changes must go through a review process
- Decoupled architecture:
  - CI build the image and stores it in the repo
  - image updater (automatically pull the latest image or filtered image from the repo)
- Advanced rollout strategies: canary and blue-green
- ArgoCD vs FluxCD - Read more at https://www.cloudraft.io/blog/argocd-vs-fluxcd

== Monitoring and Observability
- Monitoring vs Observability
- *Observability* = Metrics + Logs + Traces + Profiling ; treat like a black box
- *Metrics*: Prometheus has been a standard timeseries database used to store metrics
- *Logs* - Elastic or Loki etc
- *Traces* - Tempo, Jaeger
- *Profiling* - pyroscope, parca
- *_OpenTelemetry_* is a _industry standard_
  - Manually instrument or auto-instrument, agent sends to backend
  - An OTel pipeline has receivers, processors, and exporters or sinks

There are many options in the industry, choose what is right for your use case.

Read more - https://www.cloudraft.io/blog/guide-to-observability

== Service Mesh and API Gateway
- Istio, Linkerd are go to options
- 3 main purposes of *Service Mesh*
  - *observability* - apm like features
  - *security* - mTLS, zero trust
  - *traffic control / reliability* - rate limiting, circuit breaker, timeouts, retries
- *API Gateway* - traefik, kong, envoy api gateway
Read more: https://www.cloudraft.io/blog/kubernetes-api-gateway-comparison


== Security
#slide(
  [
    === Role-based access
    - start with least and keep it granular and use service account
    === Network policy
    - multi-tenancy, isolation, need cni support
    === Runtime threat detection
    - falco or #link("https://www.cloudraft.io/blog/cloud-native-security-with-tetragon")[tetragon] based on eBPF
    - cryptomining
    - privilege escalation
    - unexpected network connection etc
  ],
  [
    === Policy-as-code - opa, #link("https://www.cloudraft.io/blog/secure-kubernetes-using-kyverno-policy-as-code")[kyverno]
    - disallow latest tag in images
    - enforce requests and limits
    - restrict external IPs

    === Supply chain security
    - signing, provenance and authorization
  ],
)



== Storage
- Various solutions: longhorn, openebs, rook-ceph, portworx
- storage class
  - different tiers/classes
  - encryption etc
- PV and PVC
- need csi driver
- Backup & recovery: Velero, Kasten K10

== Extensibility
- custom resources - extension of k8s API
- operators - control loop to manage CRs
  - kubebuilder is popular
  - operator framework
- *Example*: I want to run Postgres on Kubernetes, there is a CloudNativePG operator. That automates most of the day to day operations.

#focus-slide("Kubernetes and cloud native is an ocean. It is a journey and best time to start is NOW.")

== Questions

Feel free to ask any question around Kubernetes and cloud native.

#align(center)[Follow me on LinkedIn
  #qrcode("https://www.linkedin.com/in/anjul", options: (scale: 3.0))

  Keep yourself updated at #link("www.cloudraft.io/blog")
]


#align(bottom + center)[Thank you!]

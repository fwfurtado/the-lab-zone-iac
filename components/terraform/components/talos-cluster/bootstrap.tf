# bootstrap.tf
resource "time_sleep" "wait_for_kubeconfig" {
  depends_on      = [talos_cluster_kubeconfig.this]
  create_duration = "90s"
}


resource "helm_release" "prometheus_operator_crds" {
  depends_on = [time_sleep.wait_for_kubeconfig]

  name             = "prometheus-operator-crds"
  namespace        = "prometheus-operator-crds"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-operator-crds"
  version          = "27.0.0"
  create_namespace = true

  wait = true
}

resource "helm_release" "cilium" {
  depends_on = [helm_release.prometheus_operator_crds]

  name             = "cilium"
  namespace        = "kube-system"
  repository       = "https://helm.cilium.io"
  chart            = "cilium"
  version          = "1.19.0"
  create_namespace = false

  # Valores do Talos - sem o wrapper "cilium:" do umbrella chart
  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }
  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }
  set {
    name  = "k8sServiceHost"
    value = "localhost"
  }
  set {
    name  = "k8sServicePort"
    value = "7445"
  }
  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }
  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  # Hubble e métricas podem vir depois via ArgoCD
  set {
    name  = "hubble.relay.enabled"
    value = "false"
  }
  set {
    name  = "hubble.ui.enabled"
    value = "false"
  }



  # Security context required for Talos
  set {
    name  = "securityContext.capabilities.ciliumAgent[0]"
    value = "CHOWN"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[1]"
    value = "KILL"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[2]"
    value = "NET_ADMIN"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[3]"
    value = "NET_RAW"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[4]"
    value = "IPC_LOCK"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[5]"
    value = "SYS_ADMIN"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[6]"
    value = "SYS_RESOURCE"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[7]"
    value = "DAC_OVERRIDE"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[8]"
    value = "FOWNER"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[9]"
    value = "SETGID"
  }
  set {
    name  = "securityContext.capabilities.ciliumAgent[10]"
    value = "SETUID"
  }
  set {
    name  = "securityContext.capabilities.cleanCiliumState[0]"
    value = "NET_ADMIN"
  }
  set {
    name  = "securityContext.capabilities.cleanCiliumState[1]"
    value = "SYS_ADMIN"
  }
  set {
    name  = "securityContext.capabilities.cleanCiliumState[2]"
    value = "SYS_RESOURCE"
  }

  wait    = true
  timeout = 600
}

resource "helm_release" "argocd" {
  depends_on = [helm_release.cilium]

  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.4.0"
  create_namespace = true

  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  wait    = true
  timeout = 600
}

# Configura o cluster in-cluster com o nome e label para o ApplicationSet
resource "kubernetes_secret" "argocd_cluster" {
  depends_on = [helm_release.argocd]

  metadata {
    name      = "in-cluster"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
      "lab.the-lab.zone/managed"       = "true"
    }
  }

  data = {
    name   = var.cluster.name
    server = "https://kubernetes.default.svc"
  }
}

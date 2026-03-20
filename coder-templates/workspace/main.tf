terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "coder" {}

provider "kubernetes" {
  # Coder runs in-cluster, no kubeconfig needed
}

# ---------------------------------------------------------------------------
# Data sources
# ---------------------------------------------------------------------------

data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

# ---------------------------------------------------------------------------
# Parameters — workspace profile selection & resource sizing
# ---------------------------------------------------------------------------

data "coder_parameter" "profile" {
  name         = "profile"
  display_name = "Workspace Profile"
  description  = "Choose which credential set to use"
  default      = "personal"
  icon         = "/icon/git.svg"
  mutable      = false
  option {
    name  = "Personal"
    value = "personal"
  }
  option {
    name  = "Flutter Brasil"
    value = "flutter-brasil"
  }
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "CPU cores (limit)"
  default      = "4"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "2 Cores"
    value = "2"
  }
  option {
    name  = "4 Cores"
    value = "4"
  }
  option {
    name  = "8 Cores"
    value = "8"
  }
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "Memory in GB (limit)"
  default      = "8"
  icon         = "/icon/memory.svg"
  mutable      = true
  option {
    name  = "4 GB"
    value = "4"
  }
  option {
    name  = "8 GB"
    value = "8"
  }
  option {
    name  = "16 GB"
    value = "16"
  }
}

data "coder_parameter" "home_disk_size" {
  name         = "home_disk_size"
  display_name = "Home disk size"
  description  = "Size in GB"
  default      = "30"
  type         = "number"
  icon         = "/emojis/1f4be.png"
  mutable      = false
  validation {
    min = 10
    max = 100
  }
}

# ---------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------

locals {
  namespace = "coder-workspaces"

  profiles = {
    personal = {
      git_user_name  = "fwfurtado"
      git_user_email = "fwfurtado@gmail.com"
      claude_secret  = "coder-credentials-personal"
    }
    flutter-brasil = {
      git_user_name  = "fwfurtado"
      git_user_email = "fwfurtado@flutter-brasil.com"
      claude_secret  = "coder-credentials-flutter-brasil"
    }
  }

  profile = local.profiles[data.coder_parameter.profile.value]

  workspace_image = "zot.infra.the-lab.zone/coder/workspace:latest"
}

# ---------------------------------------------------------------------------
# Coder Agent
# ---------------------------------------------------------------------------

resource "coder_agent" "main" {
  os   = "linux"
  arch = "amd64"

  startup_script = <<-EOT
    set -e

    # Git identity (profile-specific)
    git config --global user.name  "${local.profile.git_user_name}"
    git config --global user.email "${local.profile.git_user_email}"

    # Start code-server (secondary editor)
    if command -v code-server &>/dev/null; then
      code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &
    fi
  EOT

  env = {
    DOCKER_HOST = "tcp://localhost:2376"
    DOCKER_TLS_VERIFY = "1"
    DOCKER_CERT_PATH  = "/certs/client"
  }

  metadata {
    display_name = "CPU Usage"
    key          = "0_cpu_usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "1_ram_usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Home Disk"
    key          = "2_home_disk"
    script       = "coder stat disk --path $${HOME}"
    interval     = 60
    timeout      = 1
  }
}

# ---------------------------------------------------------------------------
# Coder Apps
# ---------------------------------------------------------------------------

resource "coder_app" "code-server" {
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "code-server"
  icon         = "/icon/code.svg"
  url          = "http://localhost:13337?folder=/home/coder"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 10
  }
}

# ---------------------------------------------------------------------------
# Persistent Volume Claim — survives workspace stop/start
# ---------------------------------------------------------------------------

resource "kubernetes_persistent_volume_claim_v1" "home" {
  metadata {
    name      = "coder-${data.coder_workspace.me.id}-home"
    namespace = local.namespace
    labels = {
      "app.kubernetes.io/name"     = "coder-pvc"
      "app.kubernetes.io/instance" = "coder-pvc-${data.coder_workspace.me.id}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace_owner.me.id
      "com.coder.user.username"    = data.coder_workspace_owner.me.name
    }
  }
  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "${data.coder_parameter.home_disk_size.value}Gi"
      }
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

# ---------------------------------------------------------------------------
# Deployment — workspace pod + Docker-in-Docker sidecar
# ---------------------------------------------------------------------------

resource "kubernetes_deployment_v1" "main" {
  count            = data.coder_workspace.me.start_count
  wait_for_rollout = false

  depends_on = [kubernetes_persistent_volume_claim_v1.home]

  metadata {
    name      = "coder-${data.coder_workspace.me.id}"
    namespace = local.namespace
    labels = {
      "app.kubernetes.io/name"     = "coder-workspace"
      "app.kubernetes.io/instance" = "coder-workspace-${data.coder_workspace.me.id}"
      "app.kubernetes.io/part-of"  = "coder"
      "com.coder.resource"         = "true"
      "com.coder.workspace.id"     = data.coder_workspace.me.id
      "com.coder.workspace.name"   = data.coder_workspace.me.name
      "com.coder.user.id"          = data.coder_workspace_owner.me.id
      "com.coder.user.username"    = data.coder_workspace_owner.me.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "com.coder.workspace.id" = data.coder_workspace.me.id
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"     = "coder-workspace"
          "app.kubernetes.io/instance" = "coder-workspace-${data.coder_workspace.me.id}"
          "app.kubernetes.io/part-of"  = "coder"
          "com.coder.resource"         = "true"
          "com.coder.workspace.id"     = data.coder_workspace.me.id
          "com.coder.workspace.name"   = data.coder_workspace.me.name
          "com.coder.user.id"          = data.coder_workspace_owner.me.id
          "com.coder.user.username"    = data.coder_workspace_owner.me.name
        }
      }

      spec {
        security_context {
          run_as_user  = 1000
          fs_group     = 1000
        }

        # ── Main workspace container ──────────────────────────────────
        container {
          name              = "dev"
          image             = local.workspace_image
          image_pull_policy = "Always"
          command           = ["sh", "-c", coder_agent.main.init_script]

          security_context {
            run_as_user = 1000
          }

          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.main.token
          }

          # Claude credentials from profile-specific secret
          env {
            name = "ANTHROPIC_API_KEY"
            value_from {
              secret_key_ref {
                name = local.profile.claude_secret
                key  = "anthropic-api-key"
              }
            }
          }

          env {
            name = "OPENAI_API_KEY"
            value_from {
              secret_key_ref {
                name = local.profile.claude_secret
                key  = "openai-api-key"
                optional = true
              }
            }
          }

          resources {
            requests = {
              "cpu"    = "500m"
              "memory" = "1Gi"
            }
            limits = {
              "cpu"    = data.coder_parameter.cpu.value
              "memory" = "${data.coder_parameter.memory.value}Gi"
            }
          }

          volume_mount {
            name       = "home"
            mount_path = "/home/coder"
          }

          volume_mount {
            name       = "docker-certs"
            mount_path = "/certs/client"
            read_only  = true
          }
        }

        # ── Docker-in-Docker sidecar ──────────────────────────────────
        container {
          name              = "docker-dind"
          image             = "docker:dind"
          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }

          env {
            name  = "DOCKER_TLS_CERTDIR"
            value = "/certs"
          }

          volume_mount {
            name       = "docker-certs"
            mount_path = "/certs/client"
            sub_path   = "client"
          }

          volume_mount {
            name       = "dind-storage"
            mount_path = "/var/lib/docker"
          }
        }

        # ── Volumes ───────────────────────────────────────────────────
        volume {
          name = "home"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.home.metadata[0].name
          }
        }

        volume {
          name = "docker-certs"
          empty_dir {}
        }

        volume {
          name = "dind-storage"
          empty_dir {}
        }

        # Spread workspaces across nodes
        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1
              pod_affinity_term {
                topology_key = "kubernetes.io/hostname"
                label_selector {
                  match_expressions {
                    key      = "app.kubernetes.io/name"
                    operator = "In"
                    values   = ["coder-workspace"]
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

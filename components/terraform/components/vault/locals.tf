locals {
  config = {
    ui = true
    # Desabilitar mlock é obrigatório em LXC sem privilégios
    disable_mlock = true

    listener = {
      "tcp" : {
        address     = "0.0.0.0:8200"
        tls_disable = true
      }
    }

    telemetry = {
      prometheus_retention_time = "372h" # 15 days
      disable_hostname          = true
    }
  }
}

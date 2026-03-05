provider "garage" {
  host   = var.garage_host
  scheme = "http"
  token  = var.garage_admin_token
}

# ── Cluster layout ──

resource "garage_cluster_layout" "this" {
  count = length(var.nodes) > 0 ? 1 : 0

  dynamic "roles" {
    for_each = var.nodes
    content {
      id       = roles.value.id
      zone     = roles.value.zone
      capacity = roles.value.capacity
      tags     = length(roles.value.tags) > 0 ? roles.value.tags : ["storage"]
    }
  }
}

# ── Keys ──

resource "garage_key" "this" {
  for_each   = var.keys
  name       = each.key
  depends_on = [garage_cluster_layout.this]
}

# ── Buckets ──

resource "garage_bucket" "this" {
  for_each        = var.buckets
  global_alias    = each.key
  expiration_days = each.value.expiration_days > 0 ? each.value.expiration_days : null
  depends_on      = [garage_cluster_layout.this]
}

locals {
  bucket_key_pairs = merge([
    for key_name, key_config in var.keys : {
      for bucket_name in key_config.bucket_names :
      "${key_name}/${bucket_name}" => {
        key_name    = key_name
        bucket_name = bucket_name
      }
    }
  ]...)
}

resource "garage_bucket_key" "this" {
  for_each      = local.bucket_key_pairs
  bucket_id     = garage_bucket.this[each.value.bucket_name].id
  access_key_id = garage_key.this[each.value.key_name].access_key_id
  read          = true
  write         = true
  owner         = true
}

# ── Website access via Admin API (provider lacks native support) ──

resource "null_resource" "website_access" {
  for_each = { for name, config in var.buckets : name => config if config.website }

  triggers = {
    bucket_id = garage_bucket.this[each.key].id
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -sf -X PUT \
        -H "Authorization: Bearer ${var.garage_admin_token}" \
        "http://${var.garage_host}/v2/PutBucketWebsite" \
        -d '{"id": "${garage_bucket.this[each.key].id}"}'
    EOT
  }
}

provider "garage" {
  host   = var.garage_host
  scheme = "http"
  token  = var.garage_admin_token
}

resource "garage_key" "this" {
  name = var.key_name
}

resource "garage_bucket" "this" {
  for_each     = toset(var.bucket_names)
  global_alias = each.value
}

resource "garage_bucket_key" "this" {
  for_each      = garage_bucket.this
  bucket_id     = each.value.id
  access_key_id = garage_key.this.access_key_id
  read          = true
  write         = true
  owner         = true
}

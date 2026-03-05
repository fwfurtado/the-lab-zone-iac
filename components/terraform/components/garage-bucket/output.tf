output "keys" {
  value = {
    for name, key in garage_key.this : name => {
      access_key_id     = key.access_key_id
      secret_access_key = key.secret_access_key
    }
  }
  sensitive = true
}

output "buckets" {
  value = { for name, b in garage_bucket.this : name => b.id }
}

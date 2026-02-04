data "tfe_outputs" "consul" {
  organization = "the-lab-zone"
  workspace    = "platform"
}


data "consul_acl_token_secret_id" "this" {
  accessor_id = consul_acl_token.traefik.id
}

terraform {
  backend "consul" {
    lock = true
    path = "terraform/state/platform/cockroachdb"
  }
}

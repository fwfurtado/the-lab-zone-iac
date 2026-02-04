terraform {
  backend "consul" {
    lock = true
    path = "terraform/state/data/garage"
  }
}

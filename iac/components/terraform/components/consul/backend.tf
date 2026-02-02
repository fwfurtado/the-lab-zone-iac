terraform {
  cloud {

    organization = "the-lab-zone"

    workspaces {
      name = "platform"
    }
  }
}
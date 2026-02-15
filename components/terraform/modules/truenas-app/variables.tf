variable "name" {
  type        = string
  description = "The name of the app"
}

variable "compose" {
  type        = any
  description = "The compose configuration"
}

variable "datasets" {
    type = list(object({
        path = string
        parent = optional(string, "paradise/the-lab-zone/stateful-apps")
        uid = optional(number, 568)
        gid = optional(number, 568)
        mode = optional(string, "0755")
    }))
    description = "The datasets to use"
}



variable "files" {
  type = map(object({
    content = optional(string, null)
    mode    = optional(string, "0644")
  }))
  description = "The files to use"
}

terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
}

variable "name" {
  type = string
}

variable "acl" {
  type    = string
  default = "private"
}

variable "lifecycle_rules" {
  type = list(object({
    id = string

    transition = optional(object({
      days          = number
      storage_class = string
    }))
  }))

  default = []
}

variable "region" {
  description = "AWS Region"
  type = string
}
variable "roles" {
  description = "define roles"
  type = map(object({
    name = string
    description = string
    policy_arn = list(string)
    trust_relationship = any 
  }))
}
variable "tags" {
  description = "Tags for role"
  type = map(string)
  default = {}
}
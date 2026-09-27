variable "region" {
  description = "The region to use for the resources."
  type        = string
}

variable "zone1" {
  description = "The availability zone to use for the resources."
  type        = string
}
variable "zone2" {
  description = "The availability zone to use for the resources."
  type        = string
}
variable "instance_type" {
  description = "The instance type to use for the EC2 instances."
  type        = string
}
variable "key_name" {
  description = "The name of the key pair to use for the EC2 instances."
  type        = string
}

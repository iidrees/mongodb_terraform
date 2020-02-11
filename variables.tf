variable "instance_name" {
  description = "Instance name"
  type        = string
  default     = "Mongo DB Instance"
}


variable "key_name" {
  description = "Access Key name"
  type        = string
  default     = "cp-devops"
}

variable "security_groups" {
  description = "Security group name"
  type        = string
  default     = "mongodb-replica-access"
}


variable "hdd1_name" {
  description = "The first EBS volume name"
  type        = string
  default     = "/dev/sdf drive"

}

variable "hdd2_name" {
  description = "The second EBS volume name"
  type        = string
  default     = "/dev/sdg drive"
}




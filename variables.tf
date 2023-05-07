variable "key_name" {
  type = string
}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type = list(string)
}


variable "ami" {
  type = list(string)
}

variable "cidr_blocks" {
  type = list(string)
}

variable "cidr_block" {
  type = string
}

variable "az" {
  type = list(string)
}

variable "subnet_tags" {
  type = list(string)
}


variable "counts" {
  type = number
}

variable "public_ip_on_launch" {
  type = bool
}
variable access_key {
  description = "AWS Acc access key"
  type = string
  sensitive = true
}

variable secret_key {
  description = "AWS Acc secret  key"
  type = string
  sensitive = true
}

variable vpc_name {
  description = "Name tag of VPC"
  type = string
}

variable vpc_cidr {
  description = "CIDR Range of VPC CIDR"
  type = string
}

variable instance_tenancy {
  description = "The tenancy of the VPC"
  default = "default"
  type = string
}

variable enable_dns_support {
  description = "Enable/Diasble for DNS support"
  type = bool
  default = true
}

variable enable_dns_hostnames {
  description = "Enable/Diasble for DNS Hostnames"
  type = bool
  default = true
}

variable tags {
  type = map(string)
  default = {}
}

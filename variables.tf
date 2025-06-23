variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "ami_id" {
  default = "ami-0c94855ba95c71c99" # Amazon Linux 2 (verify in console)
}

variable "email" {
  description = "Your email to receive alarm alerts"
  default = "bhagatapoorva42@example.com"
}

variable "cpu_threshold" {
  default = 80
}

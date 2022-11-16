variable "aws_key_pair" {
  default = "~/aws/aws_keys/tf-user.pem"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}
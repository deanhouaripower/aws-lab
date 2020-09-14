variable "users" {
  default = ["am9obg==","YXJ1bg=="]
}

variable "region" {
  default = "us-east-1"
}

variable "az" {
  default = ["us-east-1b","us-east-1c","us-east-1d"]
}
variable "aws_launchcfg_name" {
  description = "aws launch config for ec2 ASG"
  default = "aws_launch"
  type = string
}

variable "aws_image" {
  description = "amazon linux image id for region Ohio"
  type = string
  default = "ami-07c8bc5c1ce9598c3"
}

variable "ec2cost"{
  default = "free_tier"
}

variable "instance_type" {
  description = "aws instance types"
  default = [
    "T2.MICRO",
    "T2.LARGE",
    "T2.MEDIUM"]
}

variable "aws_publicip" {
  description = "public ip assignement for ec2"
  default = true
  type = bool
}

variable "user_data" {
  description = "user data for apache script"
}

variable "vpc-block" {
  default = "172.20.0.0/16"
}


data "aws_ami" "amazonlinux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name = "architecture"
    values = ["x86*"]
  }
}
variable "linuxtype"{
  default = "ubuntu"

}
variable "ami" {
  default = ["ami-ubuntu","ami-centos","ami-amzlinux","ami-ubuntu","ami-centos"]
}

variable "gcp-machinetype" {
  default = ["n1-standard-1","n1-standard-1"]
}

variable "gcp-tier"{
  default = "free-tier"
}

variable "gcp-image"{
  default = ["debian-cloud/debian-9","centos-cloud/centos-8"]
}

variable "debian-script"{
  default = "sudo apt-get install -y apache2 && sudo service apache2 start && echo '<!doctype html><html><body><h1>CONGRATULATIONS!!..You are on your way to become a Terraform expert!</h1></body></html>' | sudo tee /var/www/html/index.html"

}

variable "centos-script"{
  default = "sudo yum -y update && sudo yum install -y httpd && sudo service httpd start && echo '<!doctype html><html><body><h1>CONGRATULATIONS!!..You are on your way to become a Terraform expert!</h1></body></html>' | sudo tee /var/www/html/index.html"
}


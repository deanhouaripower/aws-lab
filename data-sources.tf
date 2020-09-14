
data "aws_ec2_instance_type_offerings" "t2-type" {
  location_type = "region"

  filter {
    name = "instance-type"
    values = ["t2.*"]
  }
}

data "aws_availability_zones" "azs" {
  state = "available"

  filter {
    name = "zone-name"
    values = ["us-east-2*"]
  }
}

locals {
  datafilter = [{name="name",value="amzn2-ami-hvm-2.0*"},
    {name="architecture",value="x86*"},{name="virtualization-type",value="hvm"}]
}

data "aws_ami_ids" "ids" {
  owners = ["amazon"]

  dynamic "filter"{
    for_each = local.datafilter

    content {
      name = filter.value.name
      values = [filter.value.value]
    }
  }


 /*
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name = "architecture"
    values = ["x86*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  */
}

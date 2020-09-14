resource "aws_launch_configuration" "awslaunch" {
  name = var.aws_launchcfg_name
  image_id = data.aws_ami.amazonlinux.image_id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.awsfw.id]
  associate_public_ip_address = var.aws_publicip
  #user_data = var.user_data
}

resource "aws_security_group" "awsfw" {
  name = "aws-fw"
  vpc_id = aws_vpc.tfvpc.id

  dynamic "ingress" {
    for_each = local.ingress_config2

    content {
      description = ingress.value.description
      protocol = "tcp"
      to_port = ingress.value.port
      from_port = ingress.value.port
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "allow_all"
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh" {
  key_name = "awspublickey"
  public_key = file("~/testec2.pub")
  tags = {
    env = "prod"
  }
}

resource "aws_autoscaling_group" "tfasg" {
  name = "tf-asg"
  max_size = 4
  min_size = 2
  launch_configuration = aws_launch_configuration.awslaunch.name
  vpc_zone_identifier = [aws_subnet.web1.id,aws_subnet.web2.id]
  target_group_arns = [aws_lb_target_group.pool.arn]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "tf-ec2VM"
  }
}

//Network Loadbalancer configuration
resource "aws_lb" "nlb" {
  name = "tf-nlb"
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  subnets = [aws_subnet.web1.id,aws_subnet.web2.id]
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.nlb.arn
  port = 80
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.pool.arn
  }
}

resource "aws_lb_target_group" "pool" {
  name = "web"
  port = 80
  protocol = "TCP"
  vpc_id = aws_vpc.tfvpc.id
}

//network config
resource "aws_vpc" "tfvpc" {
  cidr_block = "172.20.0.0/16"

}

resource "aws_subnet" "web1" {
      cidr_block = "172.20.10.0/24"
  vpc_id = aws_vpc.tfvpc.id
  availability_zone = element(data.aws_availability_zones.azs.names,0)

  tags = {
    name = "web1"
  }

}

resource "aws_subnet" "web2" {
  cidr_block = "172.20.20.0/24"
  vpc_id = aws_vpc.tfvpc.id
  availability_zone = element(data.aws_availability_zones.azs.names,1)

  tags = {
    name = "web1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tfvpc.id

  tags = {
    name = "igw"
  }
}

resource "aws_route" "tfroute" {
  route_table_id = aws_vpc.tfvpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

/*
resource "aws_codebuild_project" "lab-cicd" {
  name = "lab-cicd-project"
  service_role = "codebuild-iam-service-role"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:1.0"
    type = "LINUX_CONTAINER"

    dynamic "environment_variable"{
      for_each = [{name="mykeys",value="keys.json"},
        {name="mycreds",value="creds.json"},
        {name="data",value="mydata.json"}]

      content{
        name = environment_variable.value.name
        value = environment_variable.value.value
      }

    }
  }


    environment_variable {
      name = "mykeys"
      value = "keys.json"
    }

    environment_variable {
      name = "mycreds"
      value = "creds.json"
    }

    environment_variable {
      name = "data"
      value = "mydata.json"
    }
  }

  source {
    type = "GITHUB"
    location = "https://github.com/dhouari"
  }
}
*/

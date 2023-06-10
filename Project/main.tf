#variable "region-name" {  
#  description = "This is the name of the region you would like to create the resources in"
#}

variable "environment" {
  description = "please select environment type!"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">0.13"
    }
  }

}
# provider configuration

provider "aws" {
  shared_credentials_files = ["/root/terraform-practice/.aws/credentials"]
  region                   = "us-east-2"
  #region                   = "${var.region-name}"

}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "VPC-Terraform"
  }
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}
/*resource "aws_security_group" "allow_http" {
  name        = "Allow HTTP traffic"
  vpc_id      = aws_vpc.my_vpc.id
  description = "Allow HTTP traffic"
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
*/
/*
resource "aws_security_group" "allow-ssh" {
	name = "allow-ssh"
	vpc_id = aws_vpc.my_vpc.id
	ingress  {
	 from_port = 22
	 to_port = 22
	 protocol = "tcp"
	 cidr_blocks = ["0.0.0.0/0"]

}

}
*/

/*resource "aws_instance" "mighty-trousers" {
  ami                    = "ami-00eeedc4036573771"
  subnet_id              = aws_subnet.public.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
  tags = {
    name = "Hello-From-Terraform"
  }
}
*/

module "mighty_trousers" {
  source = "./modules/application"
  vpc_id = aws_vpc.my_vpc.id
  subnet_id = aws_subnet.public.id
  name = "mighty_trousers"
  env = var.environment
#  extra_sgs = aws_security_group.allow-ssh.id
}
/*module "crazy_foods" {
  source = "./modules/application"
  vpc_id = aws_vpc.my_vpc.id
  subnet_id = aws_subnet.public.id
  name = "crazy_foods-${module.mighty_trousers.hostname}"
}
*/

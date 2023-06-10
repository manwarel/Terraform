variable "vpc_id" {}
variable "subnet_id" {}
variable "name" {}
variable "env" {}
variable "instance_type" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    test = "t2.medium"
    prod = "t2.large"
  }

}
variable "extra_sgs" {
 type = list(string)
 default = []
}

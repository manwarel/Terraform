/* In the case of module configuration ,you don't need to define the provider configuration again ,as these details are being passed to the child module by root module
*/
resource "aws_security_group" "allow_http" {
  vpc_id = var.vpc_id
  name   = "${var.name}-allow http"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
        name = "allow_ssh"
        vpc_id = var.vpc_id
        ingress  {
         from_port = 22
         to_port = 22
         protocol = "tcp"
         cidr_blocks = ["0.0.0.0/0"]

}
}
data "aws_ami" "recent_ami" {
	 most_recent = true 
         owners = ["self"] 
}
resource "aws_instance" "Test-Instance" {
  #ami                    = "ami-00eeedc4036573771"
  ami                    = "${data.aws_ami.recent_ami.id}"
  instance_type          = "${lookup(var.instance_type,var.env)}"
  subnet_id              = var.subnet_id
  #vpc_security_group_ids = ["${distinct(concat(var.extra_sgs,aws_security_group.allow_http.*.id))}"]
  #vpc_security_group_ids = ["${distinct(concat(var.extra_sgs, aws_security_group.allow_http.*.id))}"]
  vpc_security_group_ids = [aws_security_group.allow_http.id,aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  provisioner "local-exec" { 
    command = "echo ${self.public_ip} >> inventory" 
  } 
  tags = {
    name = var.name
  }
}
output "hostname" {
  value = aws_instance.Test-Instance.private_dns
}

provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
}

data "aws_ami" "ec2-ami" {
  filter {
    name   = "state"
    values = ["available"]
  }
  owners  = ["self"]
  filter {
    name   = "tag:Name"
    values = ["Packer-Ubuntu-Docker"]
  }
  most_recent = true
}

resource "aws_instance" "example" {
  ami           = "${data.aws_ami.ec2-ami.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = "${aws_key_pair.auth.id}"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "auth" {
  key_name   = "Terraform key"
  public_key = "${file("/Users/tom/.ssh/id_rsa.pub")}"
}

output "instance_ips" {
  value = ["${aws_instance.example.*.public_ip}"]
}

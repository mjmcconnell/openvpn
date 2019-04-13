provider "aws" {
  # https://www.terraform.io/docs/providers/aws/index.html
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
  version = "~> 2.4"
}

resource "aws_instance" "openvpn" {
  ami = "${lookup(var.aws_amis, "open_vpn")}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.openvpn_security_group.name}"]
  tags {
    Name = "openvpn"
  }
}

resource "aws_instance" "ubuntu_box" {
  ami = "${lookup(var.aws_amis, "ubuntu_box")}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.ubuntu_user.key_name}"
  security_groups = ["${aws_security_group.ubuntu_security_group.name}"]
  tags {
    Name = "ubuntu_box"
  }
}

resource "aws_key_pair" "ubuntu_user" {
  key_name = "ubuntu_user"
  public_key = "${file("ubuntu.pub")}"
}

resource "aws_security_group" "openvpn_security_group" {
  name = "openvpn_security_group"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ubuntu_security_group" {
  name = "ubuntu_security_group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

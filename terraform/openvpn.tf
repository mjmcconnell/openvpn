resource "aws_instance" "openvpn" {
  # https://www.terraform.io/docs/providers/aws/r/instance.html
  ami = "${lookup(var.aws_amis, "open_vpn")}"
  availability_zone = "eu-west-1a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.ubuntu_user.key_name}"
  get_password_data = false
  monitoring = false
  security_groups = ["${aws_security_group.openvpn_security_group.id}"]
  subnet_id = "${aws_subnet.public_subnet.id}"
  associate_public_ip_address = true
  tags {
    Name = "openvpn"
  }
}

resource "aws_security_group" "openvpn_security_group" {
  # https://www.terraform.io/docs/providers/aws/r/security_group.html
  name = "openvpn_security_group"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
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

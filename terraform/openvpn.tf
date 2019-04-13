resource "aws_instance" "openvpn" {
  ami = "${lookup(var.aws_amis, "open_vpn")}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.openvpn_security_group.name}"]
  tags {
    Name = "openvpn"
  }
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

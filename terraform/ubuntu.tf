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

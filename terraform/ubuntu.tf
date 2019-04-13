resource "aws_instance" "ubuntu_box" {
  # https://www.terraform.io/docs/providers/aws/r/instance.html
  ami = "${lookup(var.aws_amis, "ubuntu_box")}"
  availability_zone = "eu-west-1a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.ubuntu_user.key_name}"
  get_password_data = false
  monitoring = false
  security_groups = ["${aws_security_group.ubuntu_security_group.id}"]
  subnet_id = "${aws_subnet.private_subnet.id}"
  associate_public_ip_address = false
  tags {
    Name = "ubuntu_box"
  }

  depends_on = ["aws_security_group.ubuntu_security_group"]
}

resource "aws_key_pair" "ubuntu_user" {
  # https://www.terraform.io/docs/providers/aws/r/key_pair.html
  key_name = "ubuntu_user"
  public_key = "${file("ubuntu.pub")}"
}

resource "aws_security_group" "ubuntu_security_group" {
  # https://www.terraform.io/docs/providers/aws/r/security_group.html
  name = "ubuntu_security_group"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

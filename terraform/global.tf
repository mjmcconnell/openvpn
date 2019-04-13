provider "aws" {
  # https://www.terraform.io/docs/providers/aws/index.html
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
  version = "~> 2.4"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "auto-corp-api" {
  # RHEL 9 -- x86-64
  # ami = "ami-026ebd4cfe2c043b2"

  # Debian 12 -- x86-64
  ami = "ami-06db4d78cb1d3bbf9"

  # Ubuntu 22.04 -- x86-64
  # ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "docker-api"
  }
}

resource "aws_ec2_instance_state" "auto-corp-api" {
  instance_id = aws_instance.auto-corp-api.id
  state       = "running"
}

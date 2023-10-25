provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "auto-corp-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "auto-corp"
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "auto-corp-gateway" {
  vpc_id = aws_vpc.auto-corp-vpc.id

  tags = {
    Name = "auto-corp"
  }

}

# Create custom route table
resource "aws_route_table" "auto-corp-route-table" {
  vpc_id = aws_vpc.auto-corp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.auto-corp-gateway.id
  }

  tags = {
    Name = "auto-corp"
  }
}

# Create a subnet
resource "aws_subnet" "auto-corp-subnet" {
  vpc_id            = aws_vpc.auto-corp-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "auto-corp"
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "rta" {
  route_table_id = aws_route_table.auto-corp-route-table.id
  subnet_id      = aws_subnet.auto-corp-subnet.id
}

# Create security group for ports: 22, 80, 443
resource "aws_security_group" "auto-corp-sg" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.auto-corp-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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

  tags = {
    Name = "auto-corp"
  }
}

# Create network interface with IP in the subnet
resource "aws_network_interface" "auto-corp-nic" {
  subnet_id       = aws_subnet.auto-corp-subnet.id
  private_ips     = ["10.0.1.55"]
  security_groups = [aws_security_group.auto-corp-sg.id]

  tags = {
    Name = "auto-corp"
  }
}

# Assign Elastic IP to network interface
resource "aws_eip" "auto-corp-eip" {
  network_interface         = aws_network_interface.auto-corp-nic.id
  associate_with_private_ip = "10.0.1.55"

  # The gateway must exist before the nic
  depends_on = [aws_internet_gateway.auto-corp-gateway]

  tags = {
    Name = "auto-corp"
  }
}

# Create server instance
resource "aws_instance" "auto-corp-api" {
  # RHEL 9 -- x86-64
  # ami = "ami-026ebd4cfe2c043b2"

  # Debian 12 -- x86-64
  ami = "ami-06db4d78cb1d3bbf9"

  # Ubuntu 22.04 -- x86-64
  # ami = "ami-053b0d53c279acc90"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "LFS207"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.auto-corp-nic.id
  }

  tags = {
    Name = "auto-corp"
  }
}

resource "aws_ec2_instance_state" "auto-corp-api" {
  instance_id = aws_instance.auto-corp-api.id
  state       = "running"
}

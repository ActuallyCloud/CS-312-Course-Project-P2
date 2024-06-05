terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}

# Initialize the AWS provider using keys provided in the variables.tf file.
provider "aws" {
  region = "us-west-2"

  access_key = var.accesskey
  secret_key = var.secretkey
  token      = var.accesstoken
}

# This creates the main virtual private network.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MC_VPC"
  }
}

# This creates the actual connection to the internet through the VPC.
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MC_IGW"
  }
}

# This creates the main subnet. Note that map_public_ip_on_launch is enabled.
resource "aws_subnet" "main-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "MC_SUBNET"
  }
}

# This creates a new security group which contains some additional rules listed below.
resource "aws_security_group" "minecraft-sg" {
  name        = "minecraft-sg"
  description = "Allows Minecraft traffic"
  vpc_id      = aws_vpc.main.id

  # Allows Minecraft to access the server.
  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows web traffic to access the server.
  ingress {
    description = "web traffic"
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (mostly for development testing)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic going outbound from the instance.
  egress {
    description = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MC_SG"
  }
}

# Route table routes all outbound internet traffic through the gateway.
resource "aws_route_table" "main-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "MC_RTB"
  }
}

# Associate the route table with the created subnet.
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.main-rtb.id
}

# Creating the actual EC2 server! You'll notice by default it associates with our created subnet and security groups.
resource "aws_instance" "main-mc-server" {
  ami                         = "ami-0c29a2c5cf69b5a9c" # Ubuntu on ARM
  instance_type               = "t4g.small"             # 2 vCPUs, 2GB RAM
  vpc_security_group_ids      = [aws_security_group.minecraft-sg.id]
  subnet_id                   = aws_subnet.main-subnet.id
  associate_public_ip_address = true
  key_name                    = "MC"

  tags = {
    Name = "MinecraftServer"
  }

  # After server is created, connect to it using SSH.
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("MC.pem")
    host = self.public_ip
  }

  # Run these commands on the remote machine in this order.
  # The first command downloads the mcsetup.sh script from GitHub.
  # The second command runs the script with elevated privileges.
  provisioner "remote-exec" {
    inline = [
      "curl -sSL https://raw.githubusercontent.com/ActuallyCloud/CS-312-Course-Project-P2/main/mcsetup.sh -o mcsetup.sh",
      "sudo bash ./mcsetup.sh"
    ]
  }
}
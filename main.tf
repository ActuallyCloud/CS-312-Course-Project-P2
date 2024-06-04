terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = var.accesskey
  secret_key = var.secretkey
  token      = var.accesstoken
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MC_VPC"
  }
}

resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MC_IGW"
  }
}

resource "aws_subnet" "main-subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "MC_SUBNET"
  }
}

resource "aws_security_group" "minecraft-sg" {
  name        = "minecraft-sg"
  description = "Allows Minecraft traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Minecraft server traffic"
    from_port   = 25565
    to_port     = 25565
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
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MC_SG"
  }
}

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

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.main-rtb.id
}

resource "aws_instance" "app_server" {
  ami                         = "ami-0c29a2c5cf69b5a9c" # Ubuntu on ARM
  instance_type               = "t4g.small"             # 2 vCPUs, 2GB RAM
  vpc_security_group_ids      = [aws_security_group.minecraft-sg.id]
  subnet_id                   = aws_subnet.main-subnet.id
  associate_public_ip_address = true
  key_name                    = "RDP"

  tags = {
    Name = "MinecraftServer"
  }
}
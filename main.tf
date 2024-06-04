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
}

resource "aws_subnet" "main-subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
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

  egress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                         = "ami-0c29a2c5cf69b5a9c" # Ubuntu on ARM
  instance_type               = "t4g.small"             # 2 vCPUs, 2GB RAM
  vpc_security_group_ids      = [aws_security_group.minecraft-sg.id]
  subnet_id                   = aws_subnet.main-subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "MinecraftServer"
  }
}
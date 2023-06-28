# Provider configuration
provider "aws" {
  region = "us-east-1" # Update with your desired AWS region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnets
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b" 
}

# Create Ingress and Egress rules for the VPC
resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Relational Database (RDS)
resource "aws_db_instance" "my_rds" {
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  storage_type         = "gp2"
  identifier           = "my-rds-instance"
  engine_version       = "5.7"
  username             = "admin"
  password             = "mysecretpassword"
  vpc_security_group_ids = [aws_security_group.vpc_sg.id]
  multi_az             = false
}

# Create Kubernetes Cluster (EKS)
resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role" 
  


  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }
}

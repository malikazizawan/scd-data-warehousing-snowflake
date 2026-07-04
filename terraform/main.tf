# Key pair - EC2 se SSH connect karne ke liye (aapki .pem file se link hoga)
resource "aws_key_pair" "deployer" {
  key_name   = "scd-key"
  public_key = file("C:/Users/HASSAN COMPUTER/.ssh/scd-key.pub")
}

# Security Group - firewall rules EC2 ke liye
resource "aws_security_group" "scd_sg" {
  name        = "scd-sg"
  description = "SSH aur NiFi/Jupyter access control"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Sab kuch bahar allow"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "scd-security-group"
  }
}

# S3 bucket - jahan NiFi customer data files upload karega
resource "aws_s3_bucket" "scd_bucket" {
  bucket = "scd-data-warehousing-aziz-2026"

  tags = {
    Name = "scd-landing-bucket"
  }
}

# Latest Amazon Linux 2 AMI dhoondta hai automatically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 instance - jahan Docker chalega, aur usme NiFi + JupyterLab
resource "aws_instance" "scd_ec2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.large"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.scd_sg.id]

  root_block_device {
    volume_size = 16
    volume_type = "gp3"
  }

  tags = {
    Name = "scd-nifi-host"
  }
}
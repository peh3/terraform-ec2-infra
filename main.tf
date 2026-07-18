resource "aws_instance" "public" {
  ami                         = "ami-01edba92f9036f76e" # find the AMI ID of Amazon Linux 2023
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-07fe08d5909e677db"  #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  associate_public_ip_address = true
  key_name                    = "tk-ec2-key" #Change to your keyname, e.g. jazeel-key-pair
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    echo "<h1>Hello from TK</h1>" | sudo tee /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF
 
  tags = {
    Name = "tk-ec2"    #Prefix your own name, e.g. jazeel-ec2
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "tk-terraform-security-group" #Security group name, e.g. jazeel-terraform-security-group
  description = "Allow SSH inbound"
  vpc_id      = "vpc-071dc429d54e64259"  #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}



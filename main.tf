resource "aws_instance" "public" {
  ami                         = "ami-01edba92f9036f76e" # find the AMI ID of Amazon Linux 2023
  instance_type               = "t2.micro"
  #subnet_id                   = "subnet-07fe08d5909e677db"  #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  subnet_id                   = aws_subnet.public_1b.id
  associate_public_ip_address = true
  key_name                    = "tk-ec2-key" #Change to your keyname, e.g. jazeel-key-pair
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y
    echo "<h1>Hello from TK</h1>" | sudo tee /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF

  #user_data = file("${path.module}/userdata.sh")

  depends_on = [
    aws_route.public_internet,
    aws_nat_gateway.tk_tf_nat_gw
  ]

  tags = {
    Name = "tk-tf-ec2"    #Prefix your own name, e.g. jazeel-ec2
  }
}




output "public_ip" {
  description = "The public IP address of the main web server."
  value       = aws_instance.public.public_ip
}
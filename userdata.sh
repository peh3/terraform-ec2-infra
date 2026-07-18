#!/bin/bash
yum update -y
yum install httpd -y
echo "<h1>Hello from TK</h1>" | sudo tee /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
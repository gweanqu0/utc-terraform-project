#!/bin/bash
apt update -y
apt install -y apache2
systemctl start apache2.service
systemctl enable apache2.service
echo “Hello World from $(hostname -f)” > /var/www/html/index.html

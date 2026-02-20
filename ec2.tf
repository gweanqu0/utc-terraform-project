#bastion host ec2
resource "aws_instance" "bastion_host" {
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.utc_key.key_name
  associate_public_ip_address = true
#availability_zone = "us-east-1a"
  tags = {
    Name = "dev-bastion-host"
    env  = "dev"
    team = "config management"
  }
}

#EC2

resource "aws_instance" "app_server" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  key_name = aws_key_pair.utc_key.key_name
  availability_zone = "us-east-1a"

  tags = {
    Nmae = "appserver1a"
    env = "dev"
    team = "config management"
  }
}

resource "aws_instance" "app_server2" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  key_name = aws_key_pair.utc_key.key_name
  availability_zone = "us-east-1b"


  tags = {
    Nmae = "appserver1b"
    env = "dev"
    team = "config management"
  } 
}
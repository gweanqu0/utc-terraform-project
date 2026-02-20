# ALB sg
 resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-dev"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg-dev"
    env  = "dev"
    team = "config management"
  }
}
# Bastion sg
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-host-sg-dev"
  description = "Bastion Host Security Group"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.69.223.200/32"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-sg-dev"
    env  = "dev"
    team = "config management"
  }
}
resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg-dev"
  description = "App Server Security Group"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    description     = "Allow HTTP from ALB SG"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "Allow SSH from Bastion SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-server-sg-dev"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database-sg-dev"
  description = "Database Security Group"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    description     = "Allow MySQL from App Server SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_server_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg-dev"
    env  = "dev"
    team = "config management"
  }
}
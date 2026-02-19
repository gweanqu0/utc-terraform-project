resource "aws_vpc" "utc_vpc" {
  cidr_block = "10.10.0.0/16"
  region = "us-east-1"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet_private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet_private2"
  }
}
resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet_private3"
  }
}
resource "aws_subnet" "private4" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet_private4"
  }
}

resource "aws_subnet" "private5" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "subnet_private5"
  }
}
resource "aws_subnet" "private6" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "subnet_private6"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.7.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_public1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.8.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_public2"
  }
}
resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.9.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet_public3"
  }
}
#create EIP
resource "aws_eip" "utc-eip-1" {
}
resource "aws_eip" "utc-eip-2" {
}
resource "aws_eip" "utc-eip-3" {
}
#create NAT gateway
resource "aws_nat_gateway" "NAT1" {
  allocation_id = aws_eip.utc-eip-1.id
  subnet_id     = aws_subnet.public1.id
}
resource "aws_nat_gateway" "NAT2" {
  allocation_id = aws_eip.utc-eip-2.id
  subnet_id     = aws_subnet.public2.id
  
}
resource "aws_nat_gateway" "NAT3" {
  allocation_id = aws_eip.utc-eip-3.id
  subnet_id     = aws_subnet.public3.id
}
 #create iGW
resource "aws_internet_gateway" "utc-igw" {
  vpc_id = aws_vpc.utc_vpc.id
}

# Public Route Table - 1 needed for the Internet gateway Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.utc_vpc.id   
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.utc-igw.id
  }
}
# Private Route Tables - 2 needed for the NAT gateways
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT1.id
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT2.id
  }
}
resource "aws_route_table" "private_3" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT3.id
  }
}
# Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_1.id
}
resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_1.id
}
resource "aws_route_table_association" "private_3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private_2.id
}
resource "aws_route_table_association" "private_4" {
  subnet_id      = aws_subnet.private4.id
  route_table_id = aws_route_table.private_2.id
}
resource "aws_route_table_association" "private_5" {
  subnet_id      = aws_subnet.private5.id
  route_table_id = aws_route_table.private_3.id
}
resource "aws_route_table_association" "private_6" {
  subnet_id      = aws_subnet.private6.id
  route_table_id = aws_route_table.private_3.id
}
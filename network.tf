resource "aws_vpc" "utc_vpc" {
  cidr_block = "10.10.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "utc-app"
  }
}

# Create IGW Internet Gateway
resource "aws_internet_gateway" "utc_igw" {
  vpc_id = aws_vpc.utc_vpc.id
}

# Public Subnets (NAT lives here)
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-public1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-public2"
  }
}
resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1c"
    tags = {
    Name = "subnet-public3"
  }
}

# Private Subnets

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.5.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet-private2"
  }
}
resource "aws_subnet" "private3" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.6.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-private3"
  }
}
resource "aws_subnet" "private4" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.7.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "subnet-private4"
  }
}
resource "aws_subnet" "private5" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.8.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "subnet-private5"
  }
}
resource "aws_subnet" "private6" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.9.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "subnet-private6"
  }
}

# Create eip Elastics IP (One per NAT)
resource "aws_eip" "nat_eip1" { domain = "vpc"}
resource "aws_eip" "nat_eip2" { domain = "vpc"}
resource "aws_eip" "nat_eip3" { domain = "vpc"}

# create NAt gateway (One per AZ)
resource "aws_nat_gateway" "NAT1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.public1.id
  depends_on = [aws_internet_gateway.utc_igw]
}
resource "aws_nat_gateway" "NAT2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.private2.id
  depends_on = [aws_internet_gateway.utc_igw]
}
resource "aws_nat_gateway" "NAT3" {
  allocation_id = aws_eip.nat_eip3.id
  subnet_id     = aws_subnet.private3.id
  depends_on = [aws_internet_gateway.utc_igw]
}

# Public Route Table (only one)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.utc_igw.id
  }
}

# Private Route Table ( 1 per AZ)
resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT1.id
  }
}
resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT2.id
  }
}

resource "aws_route_table" "private_rt3" {
  vpc_id = aws_vpc.utc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT3.id
  }
}


# Route Table Associations

#public
resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_3" {
  subnet_id = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

# Private
resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt1.id
}
resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt1.id
}
resource "aws_route_table_association" "private_3" {
  subnet_id = aws_subnet.private3.id
  route_table_id = aws_route_table.private_rt1.id
}
resource "aws_route_table_association" "private_4" {
  subnet_id = aws_subnet.private4.id
  route_table_id = aws_route_table.private_rt2.id
}
resource "aws_route_table_association" "private_5" {
  subnet_id = aws_subnet.private5.id
  route_table_id = aws_route_table.private_rt3.id
}
resource "aws_route_table_association" "private_6" {
  subnet_id = aws_subnet.private6.id
  route_table_id = aws_route_table.private_rt3.id
}
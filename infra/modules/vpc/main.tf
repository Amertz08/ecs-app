resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name    = var.name
    managed = "Terraform"
  }
}

# Start public subnet stuff
resource "aws_subnet" "public" {
  count             = length(var.public_cidr_blocks)
  cidr_block        = var.public_cidr_blocks[count.index]
  vpc_id            = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name    = "${var.name}-public-subnet-${count.index}"
    managed = "Terraform"
  }
}

resource "aws_security_group" "public-sg" {
  name = "allow_ssh"

  tags = {
    Name    = "${var.name}-public-sg-ssh"
    managed = "Terraform"
  }
}

resource "aws_security_group_rule" "public-sg-ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.public-sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = var.public_cidr_blocks
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "${var.name}-public-gateway"
    managed = "Terraform"
  }
}

resource "aws_eip" "nat" {
  count = var.enable_nat ? length(aws_subnet.public) : 0
  vpc   = true
  tags = {
    Name    = "${var.name}-nat-eip-${count.index}"
    managed = "Terraform"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat ? length(aws_subnet.public) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name    = "${var.name}-nat-${count.index}"
    managed = "Terraform"
  }
}

resource "aws_route_table" "public" {
  count  = length(aws_subnet.public)
  vpc_id = aws_vpc.this.id
  tags = {
    Name    = "${var.name}-public-rt-${count.index}"
    managed = "Terraform"
  }
}

resource "aws_route" "public_ig_route" {
  count                  = length(aws_subnet.public)
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "public_nat_route" {
  count                  = var.enable_nat ? length(aws_subnet.public) : 0
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  route_table_id = aws_route_table.public[count.index].id
  subnet_id      = aws_subnet.public[count.index].id
}

# Start Private Subnet stuff
resource "aws_subnet" "private" {
  count             = length(var.private_cidr_blocks)
  cidr_block        = var.private_cidr_blocks[count.index]
  vpc_id            = aws_vpc.this.id
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name    = "${var.name}-private-subnet-${count.index}"
    managed = "Terraform"
  }
}

resource "aws_route_table" "private" {
  count  = length(aws_subnet.private)
  vpc_id = aws_vpc.this.id
  tags = {
    Name    = "${var.name}-private-rt-${count.index}"
    managed = "Terraform"
  }
}

resource "aws_route" "private_nat_route" {
  count                  = var.enable_nat ? length(aws_subnet.private) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

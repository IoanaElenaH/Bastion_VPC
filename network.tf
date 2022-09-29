resource "aws_internet_gateway" "ioana-gateway"{
	vpc_id           = aws_vpc.ioana-vpc.id
	tags             = {
		Name         = "${var.owner}-public-private-gateway"
	}
    depends_on       = [aws_vpc.ioana-vpc,
        aws_subnet.ioana-public-subnet-1,
        aws_subnet.ioana-public-subnet-2,
        aws_subnet.ioana-private-subnet-1,
        aws_subnet.ioana-private-subnet-2]
}

resource "aws_route_table" "ioana-routing-table"{
	vpc_id           = aws_vpc.ioana-vpc.id
	route{
		cidr_block   = var.cidr_block
		gateway_id   = aws_internet_gateway.ioana-gateway.id
	}
	tags             = {
		Name         = "${var.owner}-route-table-for-internet-gateway"
	}
    depends_on       = [aws_vpc.ioana-vpc,
        aws_internet_gateway.ioana-gateway]
}

resource "aws_route_table_association" "ioana-rt-public-subnet-1"{
	subnet_id        = aws_subnet.ioana-public-subnet-1.id
	route_table_id   = aws_route_table.ioana-routing-table.id
}

resource "aws_route_table_association" "ioana-rt-public-subnet-2" {
	subnet_id        = aws_subnet.ioana-public-subnet-2.id
	route_table_id   = aws_route_table.ioana-routing-table.id
}

resource "aws_route_table_association" "ioana-rt-private-subnet-1"{
	subnet_id        = aws_subnet.ioana-private-subnet-1.id
	route_table_id   = aws_route_table.ioana-routing-table.id
}

resource "aws_route_table_association" "ioana-rt-private-subnet-2"{
	subnet_id        = aws_subnet.ioana-private-subnet-2.id
	route_table_id   = aws_route_table.ioana-routing-table.id
}
resource "aws_vpc" "roboshop_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "${local.common_name}_vpc"
    }
}

resource "aws_internet_gateway" "roboshop_igw" {
    vpc_id = aws_vpc.roboshop_vpc.id
    tags = {
        Name = "${local.common_name}_igw"
    }

}
resource "aws_subnet" "public" {
    count = length(var.az)
    vpc_id = aws_vpc.roboshop_vpc.id
    availability_zone = var.az[count.index]
    cidr_block = var.public_subnet_cidr_block[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${local.common_name}_public_${var.az[count.index]}"
    }
}

resource "aws_subnet" "private" {
    count = length(var.az)
    vpc_id = aws_vpc.roboshop_vpc.id
    availability_zone = var.az[count.index]
    cidr_block = var.private_subnet_cidr_block[count.index]
    tags = {
        Name = "${local.common_name}_private_${var.az[count.index]}"
    }
}

resource "aws_subnet" "database" {
    count = length(var.az)
    vpc_id = aws_vpc.roboshop_vpc.id
    availability_zone = var.az[count.index]
    cidr_block = var.database_subnet_cidr_block[count.index]
    tags = {
        Name = "${local.common_name}_database_${var.az[count.index]}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.roboshop_vpc.id
    tags = {
        Name = "${local.common_name}_public_rt"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.roboshop_vpc.id
    tags = {
        Name = "${local.common_name}_private_rt"
    }
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.roboshop_vpc.id
    tags = {
        Name = "${local.common_name}_database_rt"
    }
}

resource "aws_eip" "roboshop_eip" {
    domain = "vpc"
    tags = {
        Name = "${local.common_name}_eip"
    }
}

resource "aws_nat_gateway" "roboshop_nat" {
    subnet_id = aws_subnet.public[0].id
    allocation_id = aws_eip.roboshop_eip.id
    depends_on = [ aws_internet_gateway.roboshop_igw ]
    tags = {
        Name = "${local.common_name}_nat"
    }
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.roboshop_igw.id
}

resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop_nat.id
}

resource "aws_route" "database" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.roboshop_nat.id
}

resource "aws_route_table_association" "public" {
    count = length(var.az)
    route_table_id = aws_route_table.public.id
    subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private" {
    count = length(var.az)
    route_table_id = aws_route_table.private.id
    subnet_id = aws_subnet.private[count.index].id
}

resource "aws_route_table_association" "database" {
    count = length(var.az)
    route_table_id = aws_route_table.database.id
    subnet_id = aws_subnet.database[count.index].id
}
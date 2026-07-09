resource "aws_ssm_parameter" "vpc_id" {
    name = "${local.common_name}_vpc_id"
    type = "String"
    value = aws_vpc.roboshop_vpc.id
}

resource "aws_ssm_parameter" "igw_id" {
    name = "${local.common_name}_igw_id"
    type = "String"
    value = aws_internet_gateway.roboshop_igw.id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
    name = "${local.common_name}_public_subnet_ids"
    type = "StringList"
    value = join(",", aws_subnet.public.id)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
    name = "${local.common_name}_private_subnet_ids"
    type = "StringList"
    value = join(",", aws_subnet.private.id)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
    name = "${local.common_name}_database_subnet_ids"
    type = "StringList"
    value = join(",", aws_subnet.database.id)
}

resource "aws_ssm_parameter" "public_route_table_id" {
    name = "${local.common_name}_public_route_table_id"
    type = "String"
    value = aws_route_table.public.id
}

resource "aws_ssm_parameter" "private_route_table_id" {
    name = "${local.common_name}_private_route_table_ids"
    type = "String"
    value = aws_route_table.private.id
}

resource "aws_ssm_parameter" "database_route_table_id" {
    name = "${local.common_name}_database_route_table_id"
    type = "String"
    value = aws_route_table.database.id
}

resource "aws_ssm_parameter" "nat_gateway_id" {
    name = "${local.common_name}_nat_gateway_id"
    type = "String"
    value = aws_nat_gateway.roboshop_nat.id
}
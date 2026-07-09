output "vpc_id" {
    value = aws_vpc.roboshop_vpc.id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.roboshop_igw.id
}

output "public_subnet_id" {
    value = aws_subnet.public.id
}

output "private_subnet_id" {
    value = aws_subnet.private.id
}

output "database_subnet_id" {
    value = aws_subnet.database.id
}

output "public_route_table_id" {
    value = aws_route_table.public.id
}

output "private_route_table_id" {
    value = aws_route_table.private.id
}

output "database_route_table_id" {
    value = aws_route_table.database.id
}

output "nat_gateway_id" {
    value = aws_nat_gateway.roboshop_nat.id
}
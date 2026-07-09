resource "aws_security_group" "roboshop_sg" {
    count = length(var.sg_names)
    name = "${local.common_name}_${var.sg_names[count.index]}_sg"
    description = "roboshop project security group"

    vpc_id = data.aws_ssm_parameter.vpc_id.value

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "${local.common_name}_${var.sg_names[count.index]}_sg"
    }
}
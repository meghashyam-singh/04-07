resource "aws_ssm_parameter" "roboshop_sg" {
    count = length(var.sg_names)
    name = "${local.common_name}_${var.sg_names[count.idex]}_sg_id"
    type = "String"
    value = aws.security_group.roboshop_sg[count.index].id
}
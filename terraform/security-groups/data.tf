data "aws_ssm_parameter" "vpc_id" {
    name = "${local.common_name}_vpc_id"
}
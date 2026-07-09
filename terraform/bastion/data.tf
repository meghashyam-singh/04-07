data "aws_ami" "ami_id" {
    owners = ["973714476881"]
    most_recent = true

    filter {
        name = "architechture"
        values = ["x86_64"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "root-device-name"
        values = ["/dev/sda1"]
    }
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "${local.common_name}_public_subnet_ids"
}

data "aws_ssm_parameter" "bastion_sg_id" {
    name = "${local.common_name}_bastion_sg_id"
}
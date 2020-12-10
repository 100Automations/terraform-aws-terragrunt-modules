locals {
  // selects a randoms public subnet to create the bastion in
  subnet_id = element(var.public_subnet_ids, 1)

    template_file_init = templatefile("${path.module}/user_data.sh", {
    ssh_user = var.ssh_user
    github_usernames = var.github_usernames
    keys_update_frequency      = var.keys_update_frequency
    enable_hourly_cron_updates = var.enable_hourly_cron_updates
  }
}

// data "template_file" "user_data" {
//   // template = file("${path.module}/user_data.sh")
//   template = file("${path.module}/user_data.sh")

//   vars = {
//     // s3_bucket_name              = var.s3_bucket_name
//     // s3_bucket_uri               = var.s3_bucket_uri
//     ssh_user                   = var.ssh_user
//     github_usernames           = var.github_usernames
//     keys_update_frequency      = var.keys_update_frequency
//     enable_hourly_cron_updates = var.enable_hourly_cron_updates
//     // additional_user_data_script = var.additional_user_data_script
//   }
// }

resource "aws_instance" "bastion" {
 ami                    = data.aws_ami.ami.id
 instance_type          = var.bastion_instance_type
 subnet_id              = local.subnet_id
 vpc_security_group_ids = [aws_security_group.bastion.id]
 user_data              = local.template_file_init

 tags = {
   Name = var.bastion_name
 }
}

data "aws_ami" "ami" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
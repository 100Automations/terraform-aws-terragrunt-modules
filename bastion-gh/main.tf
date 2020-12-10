locals {
  // selects a randoms public subnet to create the bastion in
  subnet_id = element(var.public_subnet_ids, 1)

  template_file_init = templatefile("${path.module}/user_data.sh", {
    ssh_user                    = var.ssh_user,
    github_repo_owner           = var.github_file.github_repo_owner,
    github_repo_name            = var.github_file.github_repo_name,
    github_branch               = var.github_file.github_branch,
    github_filepath             = var.github_file.github_filepath,
    keys_update_frequency       = var.cron_key_update_schedule,
    // cron_key_update_schedule    = var.cron_key_update_schedule,
    additional_user_data_script = var.additional_user_data_script
  })
}

resource "aws_instance" "bastion" {
 ami                    = data.aws_ami.ami.id
 instance_type          = var.bastion_instance_type
 subnet_id              = local.subnet_id
 vpc_security_group_ids = [aws_security_group.bastion.id]
 user_data              = local.template_file_init
 key_name               = var.key_name

 tags = merge(var.tags, { Name = var.bastion_name })
}

// Pull latest Ubuntu AMI
// TODO: Find publicly available hardened ubuntu AMI
data "aws_ami" "ami" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
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
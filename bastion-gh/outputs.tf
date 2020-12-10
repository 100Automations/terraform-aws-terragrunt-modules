output "security_group_id" {
  description = "the security group id of the bastion server. Add this id to other services that run within the vpc to which you want to access externally."
  value       = aws_security_group.bastion.id
}

output "bastion_public_ip" {
  description = "the public ip address of the Elastic IP fronting the bastion server"
  value       = aws_instance.bastion.public_ip
}
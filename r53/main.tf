data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "www" {
  for_each = toset(var.host_names)

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value
  type    = "CNAME"
  ttl     = "300"
  records = [var.alb_external_dns]
}

resource "aws_route53_record" "bastion" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.bastion_hostname
  type    = "A"
  ttl     = "300"
  records = [var.bastion_public_ip]
}

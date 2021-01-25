resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-database"
  description = "Ingress and egress for ${var.db_name} RDS"
  vpc_id      = var.vpc_id
  tags        = merge({ Name = var.db_name }, var.tags)

  ingress {
    description = "db ingress from vpp"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
  }

  egress {
    description = "global egress"
    from_port   = 22
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"
  // https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.20.0
  // version    = "~> 2.0"
  version    = "~> 2.20.0"
  identifier = "${var.project_name}-${var.environment}"

  allow_major_version_upgrade = var.db_allow_major_engine_version_upgrade
  engine                      = "postgres"
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  allocated_storage           = 100

  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  snapshot_identifier = var.db_snapshot_migration

  vpc_security_group_ids = [aws_security_group.db.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = var.tags

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = var.private_subnet_ids

  # DB parameter group
  family = "postgres${var.db_major_version}"

  # DB option group
  major_engine_version = var.db_major_version

  # Database Deletion Protection
  deletion_protection = false
}

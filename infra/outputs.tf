output "cluster_name" {
    description = "Name of EKS cluster in aws"
    value = module.eks.cluster_name
}

output "region" {
     description = "AWS region"
     value = var.region
}

output "ecr_app_url" {
    description = "ECR rep name for app"
    value = aws_ecr_repository.app.repository_url
}

output "ecr_proxy_url" {
    description = "ECR rep name proxy"
    value = aws_ecr_repository.proxy.repository_url
}

output "efs_csi_sa_role" {
    value = module.efs_csi_isra_role.iam_role_arn
}

output "efs_id" {
    value = aws_efs_file_system.data.id
}

output "db_instance_addres" {
    description = "The address od the RDS instance"
    value = module.db.db_instance_address
}
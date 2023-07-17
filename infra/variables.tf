variable "region" {
    description = "AWS region to deploy resources to"
    default = "us-east-1"
}

variable "prefix" {
    description = "prefix to be assigned to resources"
    default = "django-k8s"
}

variable "db_password" {
    description = "password for the RDS database instance"
    default = "samplepassword123"
  
}
# Le bloc "terraform" est utilisé pour configurer les paramètres de Terraform.
terraform {
    # "required_providers" permet de spécifier les providers nécessaires pour ce code Terraform. 
    # Ici, nous avons besoin du provider AWS de HashiCorp.
    required_providers {
        aws = {
            # "source" indique l'endroit où trouver le provider. Ici, il est fourni par HashiCorp.
            source  = "hashicorp/aws"
            # "version" permet de spécifier la version du provider à utiliser. 
            # L'utilisation de "~>" indique une "version compatible", 
            # ce qui signifie que Terraform utilisera la version spécifiée ou une version ultérieure compatible.
            version = "~> 4.67.0"
    }
  }
    # "required_version" spécifie la version de Terraform requise pour exécuter ce code.
    required_version = "1.5.3"
}

# Le bloc "provider" est utilisé pour configurer le provider AWS. 
# C'est ce qui permet à Terraform d'interagir avec l'API AWS.
provider "aws" {
    # "region" est un paramètre du provider AWS qui spécifie la région AWS où seront créées les ressources.
    region = var.region
}

# Le bloc "data" permet d'accéder à des données existantes qui n'ont pas été créées par ce code Terraform. 
# Ici, on récupère les informations sur les zones de disponibilité de la région spécifiée.
data "aws_availability_zones" "available" {}

# Projet DevOps Django sur AWS avec Terraform et Jenkins

Ce projet est une démonstration de l'application des principes DevOps pour déployer une application web Django sur AWS en utilisant Kubernetes (EKS), Terraform et Jenkins.

L'application web est une simple application Django qui est déployée dans un conteneur Docker. Le conteneur est déployé sur un cluster Kubernetes qui est hébergé sur AWS EKS. L'infrastructure AWS nécessaire pour le cluster Kubernetes est gérée par Terraform. Cela inclut la création du cluster EKS, des groupes de sécurité, des rôles IAM, etc.

Jenkins est utilisé pour le déploiement continu de l'application. Chaque fois qu'un changement est poussé sur le dépôt GitHub, Jenkins déclenche un pipeline qui construit une nouvelle image Docker de l'application, la pousse sur AWS ECR, et met à jour le déploiement sur le cluster Kubernetes.

## Comment utiliser ce projet

Pour utiliser ce projet, vous aurez besoin de :

- Un compte AWS
- Docker installé sur votre machine
- kubectl, l'outil en ligne de commande de Kubernetes
- Helm, un gestionnaire de paquets pour Kubernetes
- Terraform, un outil d'infrastructure en tant que code (IaC)
- aws-vault pour une gestion sécurisée des identifiants AWS
- Jenkins pour l'automatisation du déploiement

Une fois que vous avez ces outils installés et configurés, vous pouvez cloner ce dépôt et suivre les instructions du fichier README pour déployer l'application sur AWS.

## Fonctionnalités du projet

- Application Django conteneurisée avec Docker
- Déploiement automatisé avec Jenkins
- Utilisation de AWS EKS pour le déploiement de l'application sur un cluster Kubernetes
- Utilisation de AWS RDS pour la base de données PostgreSQL
- Utilisation de AWS EFS pour le stockage persistant
- Gestion sécurisée des identifiants AWS avec aws-vault

## Commandes utiles

Voici quelques commandes utiles utilisées.

### Terraform

Initialiser Terraform (nécessaire après l'ajout de nouveaux modules) :
```
terraform init
```
Planifier Terraform (voir quelles modifications seront apportées aux ressources) :
```
terraform plan
```
Appliquer Terraform (effectuer des modifications sur les ressources après confirmation) :
```
terraform apply
```
Détruire les ressources dans Terraform (supprime tout après confirmation) :
```
terraform destroy
```

### AWS CLI

Configurer le CLI EKS local pour utiliser le cluster déployé par Terraform :
```
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```
NOTE : Pour les utilisateurs de Windows, vous devrez peut-être ajuster la syntaxe $(). Vous pouvez simplement exécuter terraform output pour voir toutes les sorties et les inclure manuellement dans la commande.

Authentifier Docker avec ECR :
```
aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <ACCOUNT ID>.dkr.ecr.<REGION>.amazonaws.com
```

### Docker

Construire et compresser l'image en architecture de plateforme amd46 :
```
docker build -t <REPO NAME>:<REPO TAG> --platform linux/amd64 --compress .
docker push <REPO NAME>:<REPO TAG>
```

### Kubernetes CLI (kubectl)

Obtenir une liste des nœuds en cours d'exécution dans le cluster :
```
kubectl get nodes
```
Appliquer la configuration du tableau de bord recommandée :
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```
Créer une liaison de rôle de cluster :
```
kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
  --group=system:serviceaccounts
```
Créer un jeton d'authentification pour un utilisateur (nécessaire pour s'authentifier avec le tableau de bord Kubernetes) :
```
kubectl create token admin-user --duration 4h -n kubernetes-dashboard
```
Démarrer le proxy kubernetes (permet d'accéder au tableau de bord et à l'API de Kubernetes) :
```
kubectl proxy
```
NOTE : Le tableau de bord est accessible via cette URL une fois le proxy en cours d'exécution : http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Appliquer la configuration de Kubernetes (nécessite un fichier kustomization.yaml à la racine du répertoire cible) :
```
kubectl apply -k ./path/to/config
```
Exécuter une commande sur un pod en cours d'exécution (par exemple, pour obtenir un shell ou créer un compte superutilisateur avec Django) :
```
kubectl exec -it <POD NAME> sh
```

### Helm

Installer le pilote EFS CSI dans Kubernetes :
```
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/

helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.eu-west-2.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=true \
    --set controller.serviceAccount.name=efs-csi-controller-sa \
    --set "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"=<ROLE_ARN>
```
NOTE : Le <ROLE_ARN> provient de la ressource déployée dans Terraform et peut être consulté en exécutant terraform output efs_csi_sa_role. La valeur image.repository est différente pour chaque région et vous pouvez trouver la bonne dans la page de documentation des dépôts d'images de conteneurs Amazon.

## Ressources utiles

- [Modèle de fichier .gitignore pour Terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore)
- [Module AWS VPC pour Terraform](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [Module AWS RDS pour Terraform](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest)
- [Module de groupe de sécurité AWS pour Terraform](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest)
- [Module AWS EKS pour Terraform](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
- [Modules IAM AWS pour Terraform](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest)
- [Documentation Kubernetes pour le déploiement de l'interface utilisateur du tableau de bord](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/#deploying-the-dashboard-ui)
- [URL du proxy du tableau de bord local](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/)
- [Documentation pour l'installation du pilote Amazon EFS CSI](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)
- [Documentation sur l'authentification du registre privé ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registry_auth.html)

## Conclusion

Ce projet est un excellent exemple de la manière dont on peut utiliser divers outils et services pour déployer une application Django de manière robuste et évolutive sur AWS. Il démontre également comment Jenkins peut être utilisé pour automatiser le processus de déploiement, ce qui peut grandement simplifier le processus de mise en production d'une application.

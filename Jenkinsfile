pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('5ebc817f-e62b-42c3-ac9b-e264b72cf523')
        AWS_SECRET_ACCESS_KEY = credentials('5ebc817f-e62b-42c3-ac9b-e264b72cf523')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Login to AWS') {
            steps {
                sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
            }
        }
        stage('Remove existing Docker images and containers') {
            steps {
                sh 'docker system prune -f'
            }
        }
        stage('Build Docker images') {
            steps {
                sh 'docker build -t 956676001061.dkr.ecr.us-east-1.amazonaws.com/django-k8s-app:latest .'
                sh 'docker build -t 956676001061.dkr.ecr.us-east-1.amazonaws.com/django-k8s-proxy:latest proxy/'
            }
        }
        stage('Push Docker images to ECR') {
            steps {
                sh 'docker push 956676001061.dkr.ecr.us-east-1.amazonaws.com/django-k8s-app:latest'
                sh 'docker push 956676001061.dkr.ecr.us-east-1.amazonaws.com/django-k8s-proxy:latest'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -k deploy/'
            }
        }
    }
}


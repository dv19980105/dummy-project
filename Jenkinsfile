pipeline {
    agent any

    environment {
        REGISTRY = "k3d-registry.localhost:5000"   // or DockerHub username
        IMAGE_NAME = "dummy-webapp"
        DEPLOYMENT_NAME = "dummy-deployment"
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out code..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Push Image') {
            steps {
                echo "Pushing Docker image..."
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying to Kubernetes..."
                // Use kubeconfig stored as Jenkins secret file
                withCredentials([file(credentialsId: 'jenkins-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh "kubectl apply -f k8s/deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
}

pipeline {
    agent any

    environment {
        REGISTRY = "k3d-registry.localhost:5000"   // or DockerHub username
        IMAGE_NAME = "dummy-webapp"
        DEPLOYMENT_NAME = "dummy-deployment"
        KUBE_CONFIG = "/home/ubuntu/.kube/config"  // Direct kubeconfig path
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📦 Checking out code..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🚀 Pushing Docker image..."
                sh "docker push ${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "☸️ Deploying to Kubernetes..."
                sh """
                    echo "🔁 Updating deployment image if it exists..."
                    kubectl set image deployment/${DEPLOYMENT_NAME} ${IMAGE_NAME}=${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} --kubeconfig=${KUBE_CONFIG} || true
                    
                    echo "📂 Applying manifests from k8s/ directory..."
                    kubectl apply -f k8s/ --kubeconfig=${KUBE_CONFIG}
                    
                    echo "⏳ Waiting for rollout to complete..."
                    kubectl rollout status deployment/${DEPLOYMENT_NAME} --kubeconfig=${KUBE_CONFIG}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

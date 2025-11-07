pipeline {
    agent any
stages {
        stage('Example Stage') {
            steps {
                echo 'This is a placeholder stage.'
    environment {
        REGISTRY = "k3d-registry.localhost:5000"   // or DockerHub username
        IMAGE_NAME = "dummy-webapp"
        DEPLOYMENT_NAME = "dummy-deployment"
        KUBE_CONFIG = "$HOME/.kube/config"
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
                sh """
                kubectl set image deployment/${DEPLOYMENT_NAME} ${IMAGE_NAME}=${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER} --kubeconfig=${KUBE_CONFIG} || true
                kubectl apply -f k8s/ --kubeconfig=${KUBE_CONFIG}
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
            echo "❌ Deployment failed."
        }
    }
}

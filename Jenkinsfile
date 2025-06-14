pipeline {
    agent any

    environment {
        ACR_NAME = 'auctionapp'
        IMAGE_NAME = 'djangoapp'
        IMAGE_TAG = "v${BUILD_NUMBER}"
        REGISTRY = "${ACR_NAME}.azurecr.io"
        DEPLOYMENT_NAME = 'django-auction-deployment'
        CONTAINER_NAME = 'django-container'  // container name in deployment.yaml
        NAMESPACE = 'default'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SathishbabuMG/Auction-App.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "docker login ${REGISTRY} -u $USERNAME -p $PASSWORD"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    dockerImage.push()
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        kubectl set image deployment/${DEPLOYMENT_NAME} ${CONTAINER_NAME}=${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} --namespace=${NAMESPACE} --record
                    """
                }
            }
        }

        stage('Check Deployment Status') {
            steps {
                sh "kubectl rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE}"
            }
        }
    }

    post {
        success {
            echo "✅ Successfully deployed ${IMAGE_NAME}:${IMAGE_TAG} to Kubernetes"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}

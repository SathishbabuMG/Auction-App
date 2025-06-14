pipeline {
    agent any

    environment {
        ACR_NAME = 'auctionapp'
        IMAGE_NAME = 'djangoapp'
        IMAGE_TAG = 'v${BUILD_NUMBER}'
        REGISTRY = "${ACR_NAME}.azurecr.io"
        DEPLOYMENT_NAME = 'django-auction-deployment'
        NAMESPACE = 'default'
    }

    triggers {
        githubPush()  // Auto-trigger on push
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
                script {
                    sh """
                    kubectl set image deployment/${DEPLOYMENT_NAME} django-container=${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} --namespace=${NAMESPACE}
                    """
                }
            }
        }
    }
}

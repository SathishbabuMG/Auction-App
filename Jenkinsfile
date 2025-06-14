pipeline {
    agent any

    environment {
        ACR = 'djangopp.azurecr.io'
        IMAGE = 'django-app'
        TAG = 'v1'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git 'https://github.com/SathishbabuMG/Auction-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $ACR/$IMAGE:$TAG ."
                }
            }
        }

        stage('Login to ACR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'acr-creds', usernameVariable: 'ACR_USER', passwordVariable: 'ACR_PASS')]) {
                    sh 'echo $ACR_PASS | docker login $ACR -u $ACR_USER --password-stdin'
                }
            }
        }

        stage('Push to ACR') {
            steps {
                sh "docker push $ACR/$IMAGE:$TAG"
            }
        }
    }
}

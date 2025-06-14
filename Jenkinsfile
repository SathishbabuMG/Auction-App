pipeline {
    agent any

    environment {
        ACR = 'djangopp.azurecr.io'
        IMAGE = 'django-app'
        TAG = 'v1'
        KUBECONFIG = credentials('k8s-kubeconfig') // Use the correct credential ID here
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/SathishbabuMG/Auction-App.git'
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

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'k8s-kubeconfig', variable: 'KUBECONFIG')]) {
                    script {
                        // Debugging: Print KUBECONFIG path to verify
                        sh 'echo $KUBECONFIG'
                        sh(script: "kubectl --kubeconfig=${KUBECONFIG} apply -f k8s/deployment.yaml", returnStdout: true)
                        sh(script: "kubectl --kubeconfig=${KUBECONFIG} apply -f k8s/service.yaml", returnStdout: true)
                    }
                }
            }
        }
    }
}

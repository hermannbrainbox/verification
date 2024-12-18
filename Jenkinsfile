pipeline {
    agent any
    
    environment {
        // Variables d'environnement
        DOCKER_IMAGE = "mydockerhub/my-app-image"   // Remplacez par votre image Docker
        REGISTRY_CREDENTIALS = 'dockerhub-credentials' // Identifiants Jenkins pour DockerHub
        K8S_DEPLOYMENT = "k8s/deployment.yaml"  // Chemin vers le fichier deployment.yaml
        K8S_SERVICE = "k8s/service.yaml"        // Chemin vers le fichier service.yaml
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupérer les fichiers du dépôt Git
                git branch: 'master', url: 'https://github.com/votre-repository.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Construire l'image Docker
                    echo "Building Docker image..."
                    sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                // Se connecter à DockerHub (en utilisant les identifiants Jenkins)
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push de l'image Docker vers le registre DockerHub
                    echo "Pushing Docker image..."
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Appliquer les fichiers Kubernetes pour déployer l'application
                    echo "Deploying to Minikube..."
                    sh 'kubectl apply -f ${K8S_DEPLOYMENT}'
                    sh 'kubectl apply -f ${K8S_SERVICE}'
                }
            }
        }

        stage('Test Deployment') {
            steps {
                script {
                    // Vérifier si le déploiement fonctionne
                    echo "Checking deployment status..."
                    sh 'kubectl get pods' // Vérifier que les pods sont en cours d'exécution
                    sh 'kubectl get services' // Vérifier les services exposés
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    // Nettoyer les images Docker anciennes (facultatif)
                    echo "Cleaning up old Docker images..."
                    sh "docker rmi ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            // Cette section est exécutée après chaque exécution du pipeline, indépendamment du succès ou de l'échec
            echo "Pipeline execution finished."
        }
        success {
            // Si tout se passe bien, envoyer un message de succès
            echo "Deployment successful!"
        }
        failure {
            // Si quelque chose échoue, envoyer un message d'erreur
            echo "Deployment failed."
        }
    }
}


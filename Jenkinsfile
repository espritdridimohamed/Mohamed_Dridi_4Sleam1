pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
        DOCKER_IMAGE = 'mohameddridi/mohamed_dridi_4sleam1'
    }

    stages {
        stage('Récupération du code') {
            steps {
                git branch: 'main', url: 'https://github.com/espritdridimohamed/Mohamed_Dridi_4Sleam1.git'
            }
        }

        stage('Tests unitaires') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw clean test'
            }
        }

        stage('Analyse SonarQube') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh './mvnw sonar:sonar -Dsonar.projectKey=student-management'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Création du livrable') {
            steps {
                sh './mvnw package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CREDENTIALS}", 
                    usernameVariable: 'USER', 
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
            archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
        success {
            echo "✅ Build #${BUILD_NUMBER} successful!"
            echo "🐳 Docker image: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
            echo "📊 SonarQube: http://localhost:9000/dashboard?id=student-management"
        }
        failure {
            echo "❌ Build #${BUILD_NUMBER} failed!"
        }
    }
}

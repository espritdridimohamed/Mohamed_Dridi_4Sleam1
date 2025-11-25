pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'mohameddridi/mohamed_dridi_4sleam1'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/espritdridimohamed/Mohamed_Dridi_4Sleam1.git'
            }
        }

        stage('Build & Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'chmod +x mvnw'
                        sh './mvnw clean install'
                    } else {
                        bat 'mvnw.cmd clean install'
                    }
                }
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (isUnix()) {
                        sh "docker build -t ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} ."
                        sh "docker tag ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} ${DOCKER_HUB_REPO}:latest"
                    } else {
                        bat "docker build -t ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} ."
                        bat "docker tag ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG} ${DOCKER_HUB_REPO}:latest"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {   
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                                                       usernameVariable: 'DOCKER_USER', 
                                                       passwordVariable: 'DOCKER_PASS')]) {
                        if (isUnix()) {
                            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                            sh "docker push ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                            sh "docker push ${DOCKER_HUB_REPO}:latest"
                        } else {
                            bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                            bat "docker push ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                            bat "docker push ${DOCKER_HUB_REPO}:latest"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'
        }
        success {
            echo "Docker image pushed successfully: ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
        }
    }
}

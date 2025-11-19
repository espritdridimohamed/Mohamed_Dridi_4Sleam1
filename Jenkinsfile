pipeline {
    agent any

    stages {

        stage('Fetch code') {
            steps {
                // Use the pipeline's SCM (safer for multibranch / credentials configured in Jenkins)
                checkout scm
            }
        }

        stage('Set execute permission') {
            steps {
                script {
                    if (isUnix()) {
                        // Persist executable bit in the git index (so future checkouts keep it) and set permission in workspace
                        sh 'git update-index --chmod=+x mvnw || true'
                        sh 'chmod +x mvnw'
                    } else {
                        // On Windows agents mvnw.cmd is used instead
                        echo 'Windows agent detected, will use mvnw.cmd'
                    }
                }
            }
        }

        stage('Run tests') {
            steps {
                script {
                    if (isUnix()) {
                        sh './mvnw test -Dspring.profiles.active=jenkins'
                    } else {
                        bat 'mvnw.cmd test -Dspring.profiles.active=jenkins'
                    }
                }
            }
        }

        stage('Build JAR') {
            steps {
                script {
                    if (isUnix()) {
                        sh './mvnw clean package -DskipTests -Dspring.profiles.active=jenkins'
                    } else {
                        bat 'mvnw.cmd clean package -DskipTests -Dspring.profiles.active=jenkins'
                    }
                }
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

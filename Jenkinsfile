pipeline {
    agent any

    stages {

        stage('Fetch code') {
            steps {
                git branch: 'main', url: 'https://github.com/espritdridimohamed/Mohamed_Dridi_4Sleam1.git'
            }
        }

        stage('Set execute permission') {
            steps {
                // Fixes the "Permission denied" for mvnw on Linux
                sh 'chmod +x mvnw'
            }
        }

        stage('Run tests') {
            steps {
                // Use Jenkins profile with H2 database
                sh './mvnw test -Dspring.profiles.active=jenkins'
            }
        }

        stage('Build JAR') {
            steps {
                // Build deliverable without tests
                sh './mvnw clean package -DskipTests -Dspring.profiles.active=jenkins'
                // Archive the JAR as a Jenkins artifact
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

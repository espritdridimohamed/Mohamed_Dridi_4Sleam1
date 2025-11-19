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
                sh './mvnw test -Dspring.profiles.active=jenkins'
            }
        }

        stage('Build JAR') {
            steps {
                sh './mvnw clean package -DskipTests -Dspring.profiles.active=jenkins'
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

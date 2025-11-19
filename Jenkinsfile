pipeline {
    agent any

    stages {

        stage('Récupérer le code depuis Git') {
            steps {
                echo "Cloning repository..."
                git url: 'https://github.com/espritdridimohamed/Mohamed_Dridi_4Sleam1.git', branch: 'master'
            }
        }

        stage('Test') {
            steps {
                echo "Running Maven tests..."
                sh 'mvn test'
            }
        }

        stage('Livrable') {
            steps {
                echo "Building the deliverable (JAR)..."
                sh 'mvn clean package'
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}

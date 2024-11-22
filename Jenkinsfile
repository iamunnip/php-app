pipeline {
    agent {
        label 'jenkins-agent'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/iamunnip/php-app.git'
                sh 'ls -al'
            }
        }
    }
}
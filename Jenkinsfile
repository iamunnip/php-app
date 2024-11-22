pipeline {

    agent {
        label 'jenkins-agent'
    }

    options {
        skipDefaultCheckout()
    }

    triggers {
        pollSCM('H/1 * * * *')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/iamunnip/php-app.git'
                sh 'ls -al'
            }
        }

        stage('Build') {
            agent {
                docker {
                    image 'php:8.1-apache'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    docker image build -f Dockerfile -t php:v1 .
                '''
            }
        }
    }
}

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
                    image 'docker:27.3.1-dind'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    docker image build -f Dockerfile -t php:v1 .
                    docker image ls
                '''
            }
        }
    }
}

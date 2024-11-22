pipeline {

    agent {
        label 'jenkins-agent'
    }

    options {
        skipDefaultCheckout()
    }

    triggers {
        pollSCM('1 * * * *')
    }

    environment {
        DOCKER_HUB_USER = "iamunnip"
        DOCKER_HUB_TOKEN = credentials('docker-hub-token')
        DOCKER_IMAGE = "iamunnip/php-app"
        DOCKER_TAG = "${BUILD_NUMBER}"

    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/iamunnip/php-app.git'
                sh 'ls -al'
            }
        }

        stage('Build Docker Image') {
            agent {
                docker {
                    image 'docker:27.3.1-dind'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    docker image build -f Dockerfile -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker image ls
                '''
            }
        }

        stage('Login to DockerHub') {
            agent {
                docker {
                    image 'docker:27.3.1-dind'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    'docker login -u ${env.DOCKER_HUB_USER} -p ${env.DOCKER_HUB_TOKEN}'
                '''
            }            
        }

        stage('Push to DockerHub') {
            agent {
                docker {
                    image 'docker:27.3.1-dind'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    docker image push ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }
    }
}

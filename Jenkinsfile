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

        stage('Build Image') {
            agent {
                docker {
                    image 'docker:27.3.1-dind'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    docker image build -f Dockerfile -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                '''
            }
        }

        stage('Trivy Scan') {
            agent {
                docker {
                    image 'aquasec/trivy:0.57.1'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    trivy image --severity HIGH,CRITICAL ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }

        stage('Push to Registry') {
            agent {
                docker {
                    image 'docker:27.3.1-dind'
                    reuseNode true
                }
            }
            steps {
                sh'''
                    echo "$DOCKER_HUB_TOKEN" | docker login -u ${DOCKER_HUB_USER} --password-stdin
                    docker image push ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }
    }
}

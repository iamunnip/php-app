pipeline {

    agent {
        label 'jenkins-agent'
    }

    options {
        skipDefaultCheckout()
    }

    triggers {
        pollSCM('* * * * *')
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
                    docker image build --file Dockerfile --tag ${DOCKER_IMAGE}:${DOCKER_TAG} .
                '''
            }
        }

        stage('Trivy Scan') {
            agent {
                docker {
                    image 'aquasec/trivy:0.57.1'
                    args '--entrypoint='
                    reuseNode true
                }
            }
            steps {
                sh'''
                    trivy image --severity CRITICAL,HIGH --format template --template "@/contrib/html.tpl" --output trivy-scan-report.html ${DOCKER_IMAGE}:${DOCKER_TAG}
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
                    echo "$DOCKER_HUB_TOKEN" | docker login --username ${DOCKER_HUB_USER} --password-stdin
                    docker image push ${DOCKER_IMAGE}:${DOCKER_TAG}
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'trivy-scan-report.html', allowEmptyArchive: true
            publishHTML([allowMissing: false, alwaysLinkToLastBuild: true,
                keepAll: false, reportDir: '.', reportFiles: 'trivy-scan-report.html',
                reportName: 'Trivy Scan Report', reportTitles: '',
                useWrapperFileDirectly: true])
        }
    }
}

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

    tools {
        git 'Default'
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

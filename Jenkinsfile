pipeline {
    agent none

    stages {
        stage('Build and Test') {
            parallel {
                stage('Rocky 9.8') {
                    agent { label 'rocky9.8' }

                    steps {
                        checkout scm

                        sh '''
                            docker build -t rocky-net-tools-builder:9 ./rocky
                            docker run --rm rocky-net-tools-builder:9
                        '''
                    }
                }

                stage('Ubuntu 24.04') {
                    agent { label 'ubuntu24.04' }

                    steps {
                        checkout scm

                        sh '''
                            docker build -t ubuntu-net-tools-builder:24.04 ./ubuntu
                            docker run --rm ubuntu-net-tools-builder:24.04
                        '''
                    }
                }
            }
        }
    }
}

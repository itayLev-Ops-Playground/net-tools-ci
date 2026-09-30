pipeline {
    agent none

    stages {
        stage('Build and Test') {
            parallel {

                stage('Rocky 9.8') {
                    agent { label 'rocky9.8' }

                    stages {
                        stage('Checkout') {
                            steps {
                                checkout scm
                            }
                        }

                        stage('Environment') {
                            steps {
                                sh '''
                                    echo "=== Jenkins Environment ==="
                                    echo "NODE_NAME=$NODE_NAME"
                                    echo "NODE_LABELS=$NODE_LABELS"
                                    echo "WORKSPACE=$WORKSPACE"
                                    echo "BUILD_NUMBER=$BUILD_NUMBER"
                                    echo "JOB_NAME=$JOB_NAME"

                                    echo "=== Linux Environment ==="
                                    hostname
                                    whoami
                                    w
                                    pwd
                                    ls -l
                                '''
                            }
                        }

                        stage('Test') {
                            steps {
                                sh '''
                                    docker build -t rocky-net-tools-builder:9 ./rocky
                                    docker run --rm rocky-net-tools-builder:9
                                '''
                            }
                        }
                    }
                }

                stage('Ubuntu 24.04') {
                    agent { label 'ubuntu24.04' }

                    stages {
                        stage('Checkout') {
                            steps {
                                checkout scm
                            }
                        }

                        stage('Environment') {
                            steps {
                                sh '''
                                    echo "=== Jenkins Environment ==="
                                    echo "NODE_NAME=$NODE_NAME"
                                    echo "NODE_LABELS=$NODE_LABELS"
                                    echo "WORKSPACE=$WORKSPACE"
                                    echo "BUILD_NUMBER=$BUILD_NUMBER"
                                    echo "JOB_NAME=$JOB_NAME"

                                    echo "=== Linux Environment ==="
                                    hostname
                                    whoami
                                    w
                                    pwd
                                    ls -l
                                '''
                            }
                        }

                        stage('Test') {
                            steps {
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
    }
}
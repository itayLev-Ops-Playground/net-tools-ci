pipeline {
    agent none
        environment{
        R_IMG_NAME = "rocky-1"
        U_IMG_NAME = "ubuntu-1"
        IMG_TAG = "${BUILD_NUMBER}"
        R_IMAGE_FULL_NAME = "${R_IMG_NAME}:v0.${IMG_TAG}"
        U_IMAGE_FULL_NAME = "${U_IMG_NAME}:v0.${IMG_TAG}"
        // CONTAINER_NAME = "app-1-container"
        // TEST_PORT= "5050"
    }
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
                                    echo "=== Printing Jenkins Environment ==="
                                    echo "NODE_NAME=$NODE_NAME"
                                    echo "NODE_LABELS=$NODE_LABELS"
                                    echo "WORKSPACE=$WORKSPACE"
                                    echo "BUILD_NUMBER=$BUILD_NUMBER"
                                    echo "JOB_NAME=$JOB_NAME"

                                    echo "=== scm Files Varification ==="
                                    ls -l
                                '''
                            }
                        }

                        stage('Test') {
                            steps {
                                sh '''
                                    docker build -t rocky-net-tools-builder:9 ./rocky
                                    docker run --rm \
                                        -e BUILD_NUMBER="$BUILD_NUMBER" \
                                        -v /mnt/artifacts:/artifacts \
                                        rocky-net-tools-builder:9 
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
                                    echo "=== Printing Jenkins Environment ==="
                                    echo "NODE_NAME=$NODE_NAME"
                                    echo "NODE_LABELS=$NODE_LABELS"
                                    echo "WORKSPACE=$WORKSPACE"
                                    echo "BUILD_NUMBER=$BUILD_NUMBER"
                                    echo "JOB_NAME=$JOB_NAME"

                                    echo "=== scm Files Varification ==="
                                    ls -l
                                '''
                            }
                        }

                        stage('Test') {
                            steps {
                                sh '''
                                    docker build -t ubuntu-net-tools-builder:24.04 ./ubuntu
                                    docker run --rm \
                                        -e BUILD_NUMBER="$BUILD_NUMBER" \
                                        -v /mnt/artifacts:/artifacts \
                                        ubuntu-net-tools-builder:24.04
                                '''
                            }
                        }
                    }
                    post{
                        always{
                            sh "docker rmi -f ${U_IMAGE_FULL_NAME}"
                        }
                   }
                }
            }
        }
        
        stage('Archive Artifacts') {
            agent { label 'linux' }

            steps {
                sh '''
                    echo "=== Preparing Jenkins Artifacts ==="

                    mkdir -p artifacts

                    cp -v /mnt/artifacts/build_$BUILD_NUMBER/* artifacts/

                    echo "=== Artifacts to Archive ==="
                    ls -lh artifacts/
                '''
                archiveArtifacts artifacts: 'artifacts/*',
                                fingerprint: true
            }       
        }
    }

    post{
        success{
            echo "========= build completed successfully ========="
        }
        failure{
            echo "========= build failed ========="
        }
    }
}

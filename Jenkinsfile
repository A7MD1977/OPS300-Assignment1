
pipeline {
    agent {
        label 'ops300-ssh'
    }

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        REGISTRY = '192.168.128.203:5000'
        IMAGE = 'bind-secondary'
    }

    stages {
        stage('Checkout GitHub') {
            steps {
                checkout scm
            }
        }

        stage('Check Podman') {
            steps {
                sh 'podman --version'
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                    podman build \
                      -t ${REGISTRY}/${IMAGE}:${BUILD_NUMBER} \
                      -f Dockerfile .
                '''
            }
        }

        stage('Push to Private Registry') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'ops300-registry-login',
                        usernameVariable: 'REG_USER',
                        passwordVariable: 'REG_PASS'
                    )
                ]) {
                    sh '''
                        set +x
                        echo "$REG_PASS" | podman login \
                          --tls-verify=false \
                          -u "$REG_USER" \
                          --password-stdin "$REGISTRY"

                        podman push \
                          --tls-verify=false \
                          "${REGISTRY}/${IMAGE}:${BUILD_NUMBER}"

                        podman logout "$REGISTRY"
                    '''
                }
            }
        }
    }
}


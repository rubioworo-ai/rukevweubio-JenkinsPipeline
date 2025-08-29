pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rukevweubio/my-grandel-app"
        DOCKER_TAG   = "latest"
        SONAR_HOST   = "https://sonarcloud.io"
        SONAR_PROJECT_KEY = "JenkinsPipeline"
        SONAR_PROJECT_NAME = "JenkinsPipeline"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out source code"
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building application with Gradle"
                sh "./gradlew clean build"
            }
        }

        stage('Docker Build & Tag') {
            steps {
                echo "Building Docker image"
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Security Scans') {
            parallel {
                stage('Trivy Scan') {
                    steps {
                        echo "Scanning image for vulnerabilities"
                        sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
                stage('GitLeaks Scan') {
                    steps {
                        echo "Scanning for secrets in repo"
                        sh '''docker run --rm -v "$(pwd)":/repo zricethezav/gitleaks:latest detect \
                            --source=/repo \
                            --report-format=json \
                            --report-path=/repo/gitleaks-report.json'''
                    }
                }
            }
        }

        stage('Test SonarCloud Connectivity') {
            steps {
                echo "📡 Testing connection to SonarCloud at ${SONAR_HOST}"
                sh '''
                    set +x
                    curl -f --connect-timeout 10 "${SONAR_HOST}/api/system/status" \
                        && echo "SonarCloud is UP and reachable" \
                        || (echo "Failed to connect to SonarCloud"; exit 1)
                '''
            }
        }

        stage('SonarCloud Analysis') {
            steps {
                echo "Running SonarCloud code quality analysis (tests skipped)"
                withCredentials([string(credentialsId: 'sonarcube-credentail', variable: 'SONAR_TOKEN')]) {
                     sh '''
                        ./gradlew sonar \
                        -Dsonar.projectKey=rukevweubio_JenkinsPipeline \
                        -Dsonar.organization=rukevweubio-1 \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=${SONAR_TOKEN}
            '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub"
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Run Docker Image') {
            steps {
                echo "Running container on port 8082"
                sh "docker run -d -p 8082:8080 ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs for details."
        }
    }
}

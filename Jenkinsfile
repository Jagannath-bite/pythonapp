pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-python-app"
        DOCKER_REGISTRY = "docker.io/your-dockerhub-username"
    }

    stages {
        stage('Checkout') {
            steps {
                // Use GitHub credentials
                git branch: 'main',
                    url: 'https://github.com/Jagannath-bite/pythonapp.git',
                    credentialsId: 'github-creds'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''
                   python3 -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest --maxfail=1 --disable-warnings -q
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE:latest ."
                }
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker tag $DOCKER_IMAGE:latest $DOCKER_REGISTRY/$DOCKER_IMAGE:latest
                        docker push $DOCKER_REGISTRY/$DOCKER_IMAGE:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished!"
        }
        success {
            echo "Build succeeded ✅"
        }
        failure {
            echo "Build failed ❌"
        }
    }
}

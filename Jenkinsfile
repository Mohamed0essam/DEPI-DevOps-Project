pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '975050176026.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'my-ecr-repo'
        IMAGE_TAG = "${env.BUILD_ID}"
        TRIVY_IMAGE = 'aquasec/trivy:latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Mohamed0essam/DEPI-DevOps-Project.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('app') {
                        dockerImage = docker.build("${ECR_REPOSITORY}:${IMAGE_TAG}")
                    }
                }
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-ecr-credentials']]) {
                        // Ensure AWS CLI is installed in the Jenkins environment
                        sh '''
                        echo "Installing AWS CLI..."
                        apt-get update
                        apt-get install -y awscli
                        
                        echo "Logging in to ECR..."
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                        
                        echo "Tagging and pushing Docker image..."
                        docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} $ECR_REGISTRY/${ECR_REPOSITORY}:${IMAGE_TAG}
                        docker push $ECR_REGISTRY/${ECR_REPOSITORY}:${IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage('Security Scan') {
            steps {
                script {
                    sh '''
                    echo "Running security scan with Trivy..."
                    docker run --rm ${TRIVY_IMAGE} image --severity HIGH,CRITICAL $ECR_REGISTRY/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

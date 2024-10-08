pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // Change to your AWS region
        ECR_REGISTRY = 'http://975050176026.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo' // Your AWS ECR registry URL
        ECR_REPOSITORY = 'my-ecr-repo' // Your ECR repository name
        IMAGE_TAG = "${env.BUILD_ID}" // Image tag with Jenkins build ID

        AWS_CREDENTIALS = credentials('aws-ecr-credentials') // Jenkins credential ID for AWS

        TRIVY_IMAGE = 'aquasec/trivy:latest' // Docker image for Trivy security scanning
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig') // Jenkins credential ID for Kubernetes kubeconfig
        DEPLOYMENT_NAME = 'my-k8s-deployment' // Kubernetes deployment name
        NAMESPACE = 'default' // Kubernetes namespace (adjust as necessary)
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
                    dir('app') { // Navigate to app directory
                        // Build the Docker image
                        dockerImage = docker.build("${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}", ".")
                    }
                }
            }
        }

        stage('Tag & Push Image to ECR') {
            steps {
                script {
                    sh '''
                    # Log in to AWS ECR
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

                    # Tag and push Docker image to ECR
                    docker tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Security Scan') {
            steps {
                script {
                    sh '''
                    # Run Trivy scan on the Docker image
                    docker run --rm ${TRIVY_IMAGE} image --severity HIGH,CRITICAL ${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh '''
                        # Update Kubernetes deployment with the new Docker image
                        kubectl set image deployment/${DEPLOYMENT_NAME} ${DEPLOYMENT_NAME}=${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG} --namespace=${NAMESPACE}

                        # Apply changes to the cluster
                        kubectl rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE}
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean up workspace after the job finishes
        }
    }
}

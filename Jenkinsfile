pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '975050176026.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'my-ecr-repo'
        IMAGE_TAG = "${BUILD_ID}"
        TRIVY_IMAGE = 'aquasec/trivy:latest'
        TRIVY_CACHE = '/root/.cache'
        KUBE_NAMESPACE = 'your-namespace'  // Change this to your actual namespace
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
                        sh '''
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                        docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} $ECR_REGISTRY/${ECR_REPOSITORY}:${IMAGE_TAG}
                        docker push $ECR_REGISTRY/${ECR_REPOSITORY}:${IMAGE_TAG}
                        '''
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Define the latest image URI
                    def imageUri = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

                    // SSH into the Kubernetes EC2 instance and update the deployment
                    sshagent(['ssh_cred']) {
                        sh '''
                        ssh ubuntu@52.201.230.33 << EOF
                        kubectl set image deployment/my-deployment my-container=${imageUri} --record
                        kubectl rollout status deployment/my-deployment
                        EOF
                        '''
                    }
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

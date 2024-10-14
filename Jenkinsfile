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

 stage('Deploy Kubernetes') {
    steps {
        withCredentials([file(credentialsId: 'secret_key', variable: 'Secretfile')]) {
            sh '''
                mkdir -p ~/.ssh
                ssh-keyscan -H 52.201.230.33 >> ~/.ssh/known_hosts

                ssh -i "${Secretfile}" ubuntu@52.201.230.33 << EOF
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 975050176026.dkr.ecr.us-east-1.amazonaws.com
                    kubectl set image deployment/python-deployment python-container=975050176026.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:${IMAGE_TAG} -n your-namespace --record
                    kubectl rollout restart deployment/python-deployment -n your-namespace
                EOF
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

pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = '975050176026.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo'
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
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
                docker tag my-ecr-repo:${IMAGE_TAG} 975050176026.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:${IMAGE_TAG}
                docker push 975050176026.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:${IMAGE_TAG}
                '''
            }
        }
    }
}


        stage('Security Scan') {
            steps {
                script {
                    sh '''
                    docker run --rm ${TRIVY_IMAGE} image --severity HIGH,CRITICAL $ECR_REGISTRY/${ECR_REPOSITORY}:${IMAGE_TAG}
                    '''
                }
            }
        }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         script {
        //             // Define the latest image URI
        //             def imageUri = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

        // //             // SSH into the Kubernetes EC2 instance and update the deployment
        //             sshagent(['kub_ec2_ssh']) {
        //                 sh '''
        //                 ssh ssh ubuntu@3.91.16.154 << EOF
        //                 kubectl set image deployment/my-deployment my-container=${imageUri} --record
        //                 kubectl rollout status deployment/my-deployment
        //                 EOF
        //                 '''
        //             }
        //         }
        //     }
        // }
    }

    post {
        always {
            cleanWs()
        }
    }
}

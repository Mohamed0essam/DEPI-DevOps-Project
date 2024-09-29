# DEPI-DevOps-Project

## AWS Infrastructure Setup using Terraform
Assigned to: Mohamed Essam
Time Estimate: 2 days

### Description:

Use Terraform to provision the following AWS infrastructure:

- A VPC with one public subnet.
- An Internet Gateway, route tables, and EC2 instances (one for Kubernetes and another for Jenkins).
- Set up security groups and IAM roles.
- Provision an Elastic Container Registry (ECR) for storing Docker images.
- Install (k3s) on the first machine via ec2 USER DATA in Terraform.


### Deliverables:

- Terraform scripts (main.tf, variables.tf, etc.).
- AWS infrastructure successfully provisioned and confirmed via the AWS console.


## Ansible-Terraform Integration
Assigned to: Ahmed Khaled
Time Estimate: 2 days

### Description:

Getting knowledge about how to combine ansible and terraform in effictive usecases:

- Use Ansible to install Jenkins and Docker on the second machine.
- Install nginx through Helm on the Kubernetes cluster.
- Integrate Prometheus and Grafana for monitoring your Kubernetes cluster metrics.

### Deliverables:

- Ansible Playbook To configure Jenkins and Docker on the EC2 instance.


##  CI/CD Pipeline with Jenkins
Assigned to: Mohamed Gaber
Time Estimate: 3.5 days

### Description:

Configure Jenkins to interact with GitHub repository for pipeline automation, by installing the necessary plugins and setting up credentials, service hooks, etc.

- Create a Jenkinsfile in your GitHub repository to define the pipeline.
- Set up Jenkins to trigger builds upon new commits to the GitHub repository.
- The Jenkins pipeline should:
   1. Build a Docker image of the Python application.
   2. Tag the image and push it to AWS Elastic Container Registry (ECR).
   3. Use the latest image tag from ECR to update the Kubernetes deployment.
   4. Deploy the new version using kubectl apply within the pipeline.
- Use AWS IAM roles with least privilege for access to ECR and other AWS services.
- Integrate security scanning (e.g., using tools like Trivy) into your Jenkins pipeline.

### Deliverables:

- Jenkinsfile CI/CD pipeline definition for building, tagging, and deploying the Python app Docker image


## Application Code
Assigned to: Ahmed Ibrahim
Time Estimate: 2 days

### Description:

Developing a simple application that will be run on the kubernates cluster :

- Develop a simple Python app that:
1. continuously resolves the internal DNS name of the nginx service in the Kubernetes cluster.
2. Uses the DNS format: <nginx-service>.<nginx-namespace>.svc.cluster.local
- Dockerize the Python application and push the image to AWS ECR.


### Deliverables:

- Python application code.
- Dockerfile for building the image.
- Pushed Docker image in AWS ECR.


## Kubernetes Cluster Setup (k3s) on EC2 Instance
Assigned to: Mohamed Gamal
Time Estimate: 2 days

### Description:

Ensuring that the cluster is ready for deploying the application and other interactions :

- Install nginx via Helm and verify the Kubernetes cluster's functionality.
- Implement Kubernetes Horizontal Pod Autoscaler (HPA) to scale the Python application based on CPU or memory usage


### Deliverables:

- Kubernates cluster running on ec2 instance
- Helm installed, and nginx deployed.
- Kubernetes Manifests: Helm charts for deploying nginx on the Kubernetes cluster.
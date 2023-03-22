# CTFd Deployment on Google Kubernetes Engine (GKE)
This project automates the deployment of a CTFd instance on Google Kubernetes Engine (GKE) using Terraform. CTFd is a popular Capture The Flag platform that allows users to create and host security-focused competitions. The deployment includes a LoadBalancer service and SSL/TLS configuration using Kubernetes Ingress.

## Prerequisites:
* A Google Cloud Platform (GCP) account with billing enabled
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [Kubernetes command-line tool kubectl](https://kubernetes.io/docs/tasks/toolsQ/install-kubectl/)
* DNS name that will point to a static **global** IP address in GCP
* SSL/TLS private key and certificate files (e.g., privkey.pem and fullchain.pem)

## Setup
Authenticate your GCP account and set the project:
```
gcloud auth login
gcloud config set project <YOUR_PROJECT_ID>
```

To enable the Service Networking API, Kubernetes Engine API, and Compute Engine API via the gcloud command-line tool, you'll need to run the following commands:
```
gcloud services enable servicenetworking.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
```

Create a GKE cluster and get its credentials:
```
gcloud container clusters create <CLUSTER_NAME> --zone <YOUR_ZONE>
gcloud container clusters get-credentials <CLUSTER_NAME> --zone <YOUR_ZONE>
```

Create a static external IP address in Google Cloud Platform. In this specific command:
```
gcloud compute addresses create ctfd --global
gcloud compute addresses create ssh --region europe-west1
```

gcloud compute addresses describe ssh --global

ssh_password = "<ROOT_PASSWORD>"
ssh_ip = "<EXERCISES_IP>"

Create a Kubernetes secret to store the SSL private key and certificate:
```
kubectl create secret tls ctfd-tls --key privkey.pem --cert fullchain.pem
```

Initialize Terraform and apply the configuration:
```
terraform init
terraform apply
```

## Components
Terraform project consists of several configuration files, each containing resources and settings related to a specific aspect of the infrastructure provisioning:
* `ctfd.tf`: This file usually contains the main Terraform configuration, including the provider settings and any shared or high-level resources.
* `database.tf`: This file contains the Terraform resources related to your database setup. In this case.
* `ingress.tf`: This file contains the Terraform resources related to the Kubernetes Ingress setup.
* `redis.tf`: This file contains the Terraform resources related to setting up a Redis instance.

## Accessing CTFd
After deploying the CTFd instance on GKE, you can access it using the reserved static IP address:
```
gcloud compute addresses describe ctfd --global
```
You can also configure DNS name with this IP address.

## Cleaning Up

To destroy the resources created by Terraform, run:

```
terraform destroy
```

To delete the GKE cluster, run:
```
gcloud container clusters delete <CLUSTER_NAME> --zone <YOUR_ZONE>
```

To delete the reserved static IP address, run:
```
gcloud compute addresses delete ctfd --global
```
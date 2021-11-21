# Introduction
This document outlines the steps you need to take to deploy Metagram to a Kubernetes cluster on AWS EKS.

## Required software
Make sure you have following installed:
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html): Run `aws --version` in a terminal to see if you already have the CLI installed.
- [kubectl](https://kubernetes.io/docs/tasks/tools/): This is the command-line tool for Kubernetes. Run `kubectl version` in a terminal to see if you already have the CLI installed.

## Required configurations
This app uses configmaps and env secrets to store the info the pods in the cluster need e.g database links, cookie secrets etc. However, you have to provide the values for your own cluster by renaming and filling the following files:
- SAMPLE-env-configmap.yaml ==> env-configmap.yaml
- SAMPLE-env-secret.yaml ==> env-secret.yaml
- SAMPLE-aws-secret.yaml ==> aws-secret.yaml
**Pro tip**: In order to encode values as Base64 strings, run `echo -n "SOME_VALUE" | base64` in a terminal, meaning:
- `echo -n`: echo the specified value without appending a newline.
- `base64`: A utility for encoding and decoding Base64 strings. If you don't have it, you can [use Homebrew](https://formulae.brew.sh/formula/base64#default) to install it on a Mac or [search for installation instructions](https://www.google.com/search?client=firefox-b-d&q=install+base64+utitlity) for your machine.

## Deployment steps
- NB: these steps assume that you're deploying to [AWS EKS](https://console.aws.amazon.com/eks/home).
- These steps also assume that you have the [AWS CLI](https://aws.amazon.com/cli/) installed.
- Make sure that your current AWS profile has permissions for the cluster you want to work on. A simple way to do this is to make sure that the same user that created the EKS cluster is the one whose details are configured as the AWS profile in use by the AWS CLI.
- Get your cluster's name from EKS and use it to give `kubectl` the correct cluster context using:
```bash
aws eks --region us-east-1 update-kubeconfig --name <EKS_CLUSTER_NAME>
```
- Create all the K8s services for the reverse proxy, frontend app etc. As a convention in this project, such services can be found in the `service-<APP_NAME>.yaml` files that are in the directories for Metagram's parts e.g `service-reverse-proxy.yaml`. Right now, the command below is sufficent. However if you add more services, don't forget to apply them to the cluster as well.
```bash
kubectl apply -f feed-service/service-feed-service.yaml && \
  kubectl apply -f user-service/service-user-service.yaml && \
  kubectl apply -f reverse-proxy/service-reverse-proxy.yaml && \
  kubectl apply -f frontend-app/service-frontend-app.yaml
```
- Create all the load balancers that will expose certain services to the internet. These load balancers are a special type of K8s service and this project uses a convention of giving them names like `expose-<APP_NAME>.yaml` e.g `expose-reverse-proxy.yaml`. Only `reverse-proxy` and `frontend-app` are exposed to the internet right now, so you can use:
```bash
kubectl apply -f reverse-proxy/expose-reverse-proxy.yaml && \
  kubectl apply -f frontend-app/expose-frontend-app.yaml
```
- We need to use the addresses of the load balancers created above. So do the following:
    - List the K8s services in the app using `kubectl get svc`.
    - Copy the external IP for the `expose-reverse-proxy` service and specify it as the value for `API_DOMAIN` in `env-secret.yaml` using the format `http://<REVERSE_PROXY_EXTERNAL_IP>`.
    - Also, copy the external IP for the `expose-frontend-app` service and specify it as the value for `FRONTEND_APP_URL` in `env-secret.yaml` using the format `http://<FRONTEND_APP_EXTERNAL_IP>`.
    - Finally, open Travis CI in a browser and modify the `metagram-frontend-app` build pipeline by setting its `API_DOMAIN` environment variable to `http://<REVERSE_PROXY_EXTERNAL_IP>`.
- Apply all the config maps and secrets (e.g `aws-secret.yaml, env-configmap.yaml` etc) located in the root of the project using:
```bash
kubectl apply -f env-configmap.yaml && \
  kubectl apply -f env-secret.yaml && \
  kubectl apply -f aws-secret.yaml
```
- Finally, deploy the pods that contain all parts of Metagram i.e frontend, microservices, reverse proxy etc. This project uses a convention of using a format of `deployment-<APP_NAME>` to name all files that contain K8s Deployments. So, use the following to deploy our pods:
```bash
kubectl apply -f feed-service/deployment-feed-service.yaml && \
  kubectl apply -f user-service/deployment-user-service.yaml && \
  kubectl apply -f reverse-proxy/deployment-reverse-proxy.yaml && \
  kubectl apply -f frontend-app/deployment-frontend-app.yaml

```
- Visit the external IP of `expose-frontend-app` and you should be able to see the app working.

## ClusterIPs
Various services have been given specific cluster IPs so that no matter when those services are created, they will always have the same intra-cluster IP address.
- 10.100.10.1: The frontend app's load balancer that is used to expose it to the internet.
- 10.100.20.1: The service for pods that contain the frontend app.
- 10.100.30.1: The load balancer used to expose the reverse proxy service
- 10.100.40.1: The reverse proxy's k8s service.
- 10.100.50.1: The user service.
- 10.100.60.1: The feed service.

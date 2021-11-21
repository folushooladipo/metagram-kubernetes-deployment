# Introduction
This project is used to deploy all the parts of Metagram to a Kubernetes (K8s) cluster on AWS EKS using a microservices architecture. This is also my submission for the capstone project in the Cloud Developer nanodegree on Udacity.

## Table of Contents
1. [Introduction](#introduction)
1. [Table of Contents](#table-of-contents)
1. [Metagram's Architecture](#metagrams-architecture)
1. [Using Continuous Integration and Deployment (CI/CD)](#using-continuous-integration-and-deployment-ci-cd)
1. [Required Software](#required-software)
1. [Running this Project](#running-this-project)
1. [Locally Building and Running Images](#locally-building-and-running-images)
1. [How to Deploy](#how-to-deploy)

## Metagram's Architecture
Metagram was built using a microservices architecture. Here are links to the GitHub repositories for each of this project's microservices:
1. [The user service](https://github.com/folushooladipo/metagram-user-service)
1. [The feed service](https://github.com/folushooladipo/metagram-feed-service)
1. [The reverse proxy service](https://github.com/folushooladipo/metagram-reverse-proxy)
1. [The frontend app](https://github.com/folushooladipo/metagram-frontend-app)

## Using Continuous Integration and Deployment (CI/CD)
Every microservice in this project uses:
- [GitHub Actions](https://github.com/features/actions) for CI.
- [Docker Hub](https://hub.docker.com/) for CD.

## Required Software
In order to run this application, you need to have the following software installed:
1. Docker and docker-compose: You can get these by installing [Docker Desktop](https://www.docker.com/products/docker-desktop).
1. [Git](https://git-scm.com/downloads)

If you want to use the instructions in the [local-build-and-run section](#locally-building-and-running-images) to build the app locally and then run it, you also need to install:
1. [Node.js 14+](https://nodejs.org/en/download/): if you use a Mac, I suggest using [NVM](https://github.com/nvm-sh/nvm) to manage your current Node.js installation. npm will be installed along with Node.js. (NB: "Node.js 14+" means versions 14, 15, 16, 17 etc are all fine.)
1. [Yarn](https://yarnpkg.com/): Most services in Metagram use Yarn as their package manager with the exception of `frontend-app`.

## Running this Project
It is very easy to run this project on your machine. Just do the following:
- Create a copy of `SAMPLE-set_env_vars.sh`, save it as `set_env_vars.sh` and fill in the values it requires.
- Run the below to set the correct enviroment variables that each container will need:
```bash
./set_env_vars.sh
```
- Make sure Docker Desktop is running.
- Use the below to pull the Docker images for each microservice (if necessary) and run them all in containers:
```bash
docker-compose up
```
- Open a web browser and visit [http://localhost:4200](http://localhost:4200).

## Locally Building and Running Images
- Open a terminal/command prompt and navigate to the root directory for this repository.
- Run the below to clone the repositories for each microservice and place them in the parent directory for the current one i.e as siblings of this directory:
```bash
git clone https://github.com/folushooladipo/metagram-frontend-app ../metagram-frontend-app && \
  git clone https://github.com/folushooladipo/metagram-reverse-proxy ../metagram-reverse-proxy && \
  git clone https://github.com/folushooladipo/metagram-user-service ../metagram-user-service && \
  git clone https://github.com/folushooladipo/metagram-feed-service ../metagram-feed-service
```
- You need to modify the config for reverse-proxy so that it works for a local environment as opposed to a Kubernetes cluster. To do this, edit the `nginx.conf` in `../metagram-reverse-proxy` by:
    - Commenting out all lines that start with `server 10.100*`.
    - Uncommenting all lines that start with `server host.docker.internal:*`.
- Create a copy of `SAMPLE-set_env_vars.sh`, save it as `set_env_vars.sh` and fill in the values it requires.
- Run the below to set the correct enviroment variables that each container will need:
```bash
./set_env_vars.sh
```
- Make sure Docker Desktop is running.
- Run this to build the images for each service:
```bash
docker-compose -f build-images.yaml build
```
- Run this to start all the containers that contain Metagram's microservices:
```bash
docker-compose -f docker-compose-local.yaml up
```
- Open a web browser and visit [http://localhost:4200](http://localhost:4200).

## How to Deploy
For info on how to deploy this app to your own cluster, checkout the instructions in [deployment.md](./deployment.md)

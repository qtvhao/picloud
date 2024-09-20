# picloud
This project provides a collection of scripts for managing your Kubernetes home server environment. It offers a one-click solution for various tasks, including:
- Logging & Monitoring: Monitor your Kubernetes deployments for performance and health.
- Bare Metal Provisioning: Provision bare metal servers using PXE.
- GitLab Management: Install and manage your own GitLab instance with a single click.
- Terraform Integration: Deep integration with Terraform, including Terraform State Management support.
- Embedded Registry: Utilize Spegel, a stateless distributed OCI registry mirror, for peer-to-peer container image sharing within your Kubernetes cluster.
- Secure Harbor: Deploy a secure Harbor instance for private container image registry.
- One-Click Kubernetes: Easily deploy and manage a Kubernetes cluster.
- Remote Management: Manage your server remotely.
- Service Exposure: Expose your Kubernetes services securely over Cloudflare Tunnel with a single click.
- Secure by Default: Automatically leverage your public key from your GitHub profile for secure access.

#### Features
- Simple and Automated: Scripts automate various tasks, simplifying your home server management.
- Integrated Workflow: Scripts work seamlessly together, ensuring a smooth user experience.
- Secure by Design: Secure practices are built in, including leveraging your existing GitHub public key.
- Flexibility: The project caters to various use cases, from basic deployments to complex setups.

# Basic usage

```bash
#!/bin/bash
IDENTITY_FILE="$HOME/id_rsa"
set -xeo pipefail
(cd ./picloud && \
    ./pic discover-nodes $IDENTITY_FILE && \
    ./pic recommended $IDENTITY_FILE)
kubectl get nodes
echo "Nodes are ready to use"
```

# Installation
```bash
curl https://raw.githubusercontent.com/qtvhao/picloud/main/pic -o pic && chmod +x pic
```
Or run with Docker (limited functions):
```bash
docker build -t pic https://github.com/qtvhao/picloud.git
docker run -it -v ~/.ssh/:/root/.ssh/ pic bash
```

```bash
docker run -it -v ~/.ssh/:/root/.ssh/ pic ./pic list-nodename $IDENTITY_FILE
```

## Build then burn your ISO with FAI (Fully Automated Installation)


[![asciicast2](https://asciinema.org/a/616150.svg)](https://asciinema.org/a/616150)


```bash
your_github_username="qtvhao" # this helps to get public key from your Github account, you can ssh to created machine without password
./pic fai "your_picloud" "$your_github_username"
./pic dd "$host_name" "/dev/sdc" # "disk dump" your ISO to USB device, or use PXE boot to install your machine (see below)
```

## Automated bare metal installation with PXE boot

[![asciicast](https://asciinema.org/a/616107.svg)](https://asciinema.org/a/616107)

```bash
./pic pxe "8c:dc:d4:34:0c:f0" ./id_rsa "192.168.1.226"
# 
./pic auto-pxe $IDENTITY_FILE # this will automatically discover all machines in the same network and install them with created ISO above
```

## Discover machines

PiCloud will automatically discover all machines which can be authenticated with given identity file. This is useful for managing a large number of machines.

[![asciicast3](https://asciinema.org/a/630467.svg)](https://asciinema.org/a/630467)

```bash
./pic list-nodename ./id_rsa
```

List all machines in the same network and their IP addresses, includes product name and installed date.

## Install/Reinstall Kubernetes cluster with k3s

The script will automatically install k3s-agent on the listed machines.

```bash
./pic reinstall-k3s "$IDENTITY_FILE"
```


## Install recommended packages

Firstly, PiCloud will discover all machines with given identity file.
Then, it will install k3s on all machines and setup a Kubernetes cluster.
Finally, it will install all recommended packages on the master node.
It also expose all services to the internet securely with Cloudflare Tunnel.

```bash
./pic recommended "$IDENTITY_FILE"
# This following steps will be executed/installed:
# - Install K3s
# - Redis
# - Gitlab
# - Grafana, Promtail and Loki
# - Longhorn storage
```

## Setup Registry as a pull through cache (useful for air-gapped environment)

```bash
./pic Registry-as-a-pull-through-cache "$IDENTIFY_FILE" "$NODE_IP"
```

# Usage
```text
Usage: ./pic [command]
Commands:
  update
  install
  remove
  start
  stop
  restart
  status
  help
```

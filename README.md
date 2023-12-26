# picloud
- [x] Automated image creation with [FAI](https://fai-project.org/)
- [x] Automated bare metal installation with PXE boot or USB boot
- [x] Automated Kubernetes installation and management with [k3s](https://k3s.io/)
- [x] Expose services to the internet securely with [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/)
- [x] GitLab installation and many utilities
- [x] Distributed block storage system with [Longhorn](https://longhorn.io/)
- [x] Kubernetes cluster logging with [Loki](https://grafana.com/oss/loki/)
- [x] Registry as a pull through cache with [Docker Registry](https://docs.docker.com/registry/)
- [x] Terraform HTTP backend and manage your environment on GitLab (see [Terraform HTTP backend](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html))
- [x] Harbor installation for private Docker registry
- [x] Virtual machine management with [VirtualBox](https://www.virtualbox.org/)

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
github_username="qtvhao" # set your own github username, this helps to download your public key from github
./pic fai "hp-z440" "$github_username"
./pic dd $host_name "/dev/sdc" # you can burn your ISO to USB device, or you can use pxe boot to install your machine (see below)
```

## Automated bare metal installation with PXE boot

[![asciicast](https://asciinema.org/a/616107.svg)](https://asciinema.org/a/616107)

```bash
./pic pxe "8c:dc:d4:34:0c:f0" ./id_rsa "192.168.1.226"
# 
./pic auto-pxe $IDENTITY_FILE # this will automatically discover all machines in the same network and install them with created ISO above
```

## Install/Reinstall Kubernetes cluster with k3s

The script will automatically install k3s-agent on the listed machines.
```bash
./pic reinstall-k3s $IDENTITY_FILE
```


## Install recommended packages

```bash
./pic recommended $IDENTITY_FILE
# This following steps will be executed/installed:
# - Install K3s
# - Redis
# - Gitlab
# - Grafana, Promtail and Loki
# - Longhorn storage
```

# Setup Registry as a pull through cache (useful for air-gapped environment)

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

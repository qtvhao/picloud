# picloud
- [x] Automated image creation with [FAI](https://fai-project.org/)
- [x] Automated bare metal installation with PXE boot
- [x] Automated Kubernetes installation and management with [k3s](https://k3s.io/)
- [x] Expose services to the internet securely with [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/)
- [x] GitLab CI/CD integration
- [x] Minio S3 compatible object storage
- [x] S3FS for mounting Minio as a filesystem use CSI driver
- [x] Kubernetes cluster logging with [Loki](https://grafana.com/oss/loki/)
- [ ] Registry as a pull through cache with [Docker Registry](https://docs.docker.com/registry/)
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
docker run -it -v ~/.ssh/:/root/.ssh/ pic ./pic list-nodename
```

## FAI (Fully Automated Installation)
```bash
host_name="z440" # set your own hostname
usb_device="/dev/sdc" # set your own USB device
github_username="qtvhao" # set your own github username
./pic fai $host_name $github_username
./pic dd $host_name $usb_device
# Boot from USB and wait for installation to complete
```
## Automated bare metal installation with PXE boot
Ensure Boot from Network when Wake on LAN is enabled in BIOS.
Ensure Boot mode is set to Legacy BIOS.
Ensure Boot order is not set to Network to avoid loop booting.

## Install/Reinstall Kubernetes cluster with k3s

The script will automatically install k3s-agent on listed machines.
```bash
./pic reinstall-k3s [NODE_IP_1] [NODE_IP_2] [NODE_IP_3] ...
```

The script also automatically find machines which installed with FAI in LAN and install k3s-agent on them.
```bash
./pic reinstall-k3s $(hostname -I | cut -d' ' -f1)
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

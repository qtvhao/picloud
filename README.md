# picloud
- [x] Automated bare metal installation with [FAI](https://fai-project.org/)
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

## FAI (Fully Automated Installation)
```bash
host_name="z440"
usb_device="/dev/sdc"
./pic fai $host_name
./pic dd $host_name $usb_device
# Boot from USB and wait for installation to complete
```

## Install/Reinstall Kubernetes cluster with k3s
```bash
./pic reinstall-k3s [NODE_IP_1] [NODE_IP_2] [NODE_IP_3] ...
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
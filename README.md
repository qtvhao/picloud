# picloud
- [ ] Automated bare metal provisioning with PXE boot
- [x] Automated Kubernetes installation and management with [k3s](https://k3s.io/)
- [x] Expose services to the internet securely with [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/)
- [x] GitLab CI/CD integration
- [ ] Minio S3 compatible object storage
- [ ] S3FS for mounting Minio as a filesystem use CSI driver
- [ ] Kubernetes cluster logging with [Loki](https://grafana.com/oss/loki/)
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
  help```
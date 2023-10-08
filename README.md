# picloud
- [ ] Automated bare metal provisioning with PXE boot
- [ ] Automated Kubernetes installation and management with [k3s](https://k3s.io/)
- [x] Expose services to the internet securely with [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/)
- [ ] GitLab CI/CD integration
- [ ] Kubernetes cluster logging with [Loki](https://grafana.com/oss/loki/)

# Installation
```bash
curl https://raw.githubusercontent.com/qtvhao/picloud/main/pic -o pic && chmod +x pic
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
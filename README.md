# Tailscale-Connected Network for PLC Communication, Monitoring and Support 
Design to use Tailscale to connect an automation PLC running on Linux to application servers residing in a remote data center data center

## Overview
This project demonstrates how to securely connect an industrial automation PLC running on Linux to remote application servers using [Tailscale](https://tailscale.com/), a mesh VPN built on WireGuard. The goal is to enable seamless, encrypted communication between edge devices and centralized infrastructure—ideal for reote access (support), remote monitoring, and automation control systems via APIs.

<img width="2007" height="897" alt="image" src="https://github.com/user-attachments/assets/7254cad8-fdb8-4270-8193-af14b1fd7526" />

## Why Tailscale?
- Zero-config VPN with automatic key rotation
- Works across NATs and firewalls without port forwarding
- Ideal for edge-to-cloud architectures in industrial environments

## Architecture
- **Edge Node**: Linux-based PLC
- **Application Server**: Linux based remote moitoring
- **API Server**: Linux based controls via APIs
- **Remote Access**: Windows Laptop for remote access
- **VPN Layer**: Tailscale mesh network
- **Communication Protocols**: HTTP/HTTPS, Modbus/TCP, REST APIs, SSH

## Use Cases
- Remote diagnostics and firmware updates
- Secure telemetry streaming from PLC to cloud
- Real-time control commands from centralized dashboards

## Assumptions
1) You already have a Tailscale account with "Admin" access
2) The application server has KVM configured
3) Port forwarding is previously configured for VM connectivity
4) Host networks provide at minimum the following access:
   - inside devices any --> TCP 443 (SSL)
   - inside devices UDP 41641 (wireguard tunnel)--> Any
   - inside devices UDP 3478 (STUN) --> Any
   - inside devices TCP 80 (HTTP) --> Any

## Deployment Steps (Suggested order)
1) Install and Configure Tailscale on the KVM server - See file "KVM-Server" 
2) Install and Configure Tailscale on the Linux PLC - See file "Linux-PLC" 
3) Configure the KVM server for Subnet Routing and advertise routed for VMs - See file "KVM-Server-Subnet-Routing" 
4) Install and Configure Tailscale on Windows PV for remote access - See file "Windows-PC"

## Deploy using bash scipts or ansible (in progress)
## There are several "base scripts" that can be modified based on you deployment variables.
## Here's what each sample script does
Deploy to multiple Tailscale clients Linux PLC servers 
Bash acripts:
1) matt-tailnet-multiple-server-deploy.sh - uses bash scripts to deploy Tailscale clients to a list of servers by IP Address
2) matt-tailnet.sh - Install and Deploy Tailscale/Prometheus/Grafana on Linux w/cockpit for advanced monitoring
Ansible:
1) matt-tailnet-multiple-server-deploy.yaml - uses ansible to deploy Tailscale clients to a list of servers by .ini file
2) inventory.ini - sample .ini file
3) matt-tailnet-ansible - uses ansible to Install and Deploy Tailscale/Prometheus/Grafana on Linux w/cockpit for advanced monitoring
 
## Future Enhancements
- Develop detailed ansible scripts to simplify deployment for thousands of PLC servers
- Develop Ta=erraform scripts to deploy monitoring servers in AWS
- Improve integration with Grafana for telemetry visualization (base ansible and bash scripts)
- Role-based access control via Tailscale ACLs
- Optional integration with identity providers (Google, Microsoft, Okta)

## License
MIT

## Author
Matt — Data scientist, edge AI architect, and alpine cryptid enthusiast 🏔️👣

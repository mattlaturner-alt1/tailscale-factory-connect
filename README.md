# tailscale-factory-connect
Design to use Tailscale to connect an automation PLC running on Linux to application servers residing in a remote data center data center
# Tailscale-Connected PLC Automation

## Overview
This project demonstrates how to securely connect an industrial automation PLC running on Linux to remote application servers using [Tailscale](https://tailscale.com/), a mesh VPN built on WireGuard. The goal is to enable seamless, encrypted communication between edge devices and centralized infrastructure—ideal for reote access (support), remote monitoring, and automation control systems via APIs.

## Why Tailscale?
- 🔐 Zero-config VPN with automatic key rotation
- 🌍 Works across NATs and firewalls without port forwarding
- 🧠 Ideal for edge-to-cloud architectures in industrial environments

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

## Getting Started
1. Install Tailscale on your PLC and remote server
2. Authenticate both nodes into the same tailnet
3. Configure firewall rules and ACLs as needed
4. Deploy your automation scripts or services

## Security Considerations
- Encrypted peer-to-peer communication
- Role-based access control via Tailscale ACLs
- Optional integration with identity providers (Google, Microsoft, Okta)

## Future Enhancements
- Integration with Grafana for telemetry visualization
- Support for multiple PLCs and failover routing
- Dockerized deployment for edge portability

## License
MIT

## Author
Matt — Data scientist, edge AI architect, and alpine cryptid enthusiast 🏔️👣

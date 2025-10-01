#!/bin/bash

set -e

# === CONFIGURATION ===
TAILSCALE_AUTH_KEY="tskey-xxxxxxxxxxxxxxxx"  # Replace with your actual key
ADVERTISE_SUBNET="192.168.1.0/24"            # Replace with your local subnet
PROM_NODE_EXPORTER_VERSION="1.7.0"
GRAFANA_PORT=3000
DASHBOARD_ID="1860"  # Node Exporter Full
GRAFANA_ADMIN="admin"
GRAFANA_PASS="admin"

echo "Starting Matt-Tailnet installation..."

# === Cockpit ===
echo "Installing Cockpit..."
sudo apt update
sudo apt install -y cockpit cockpit-networkmanager
sudo systemctl enable --now cockpit.socket
sudo ufw allow 9090

# === Tailscale ===
echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --authkey=${TAILSCALE_AUTH_KEY} --advertise-routes=${ADVERTISE_SUBNET}

# === Prometheus Node Exporter ===
echo "Installing Prometheus Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v${PROM_NODE_EXPORTER_VERSION}/node_exporter-${PROM_NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xvfz node_exporter-${PROM_NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${PROM_NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo useradd -rs /bin/false node_exporter

cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus Node Exporter
[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reexec
sudo systemctl enable --now node_exporter
sudo ufw allow 9100

# === Grafana ===
echo "Installing Grafana..."
sudo apt install -y software-properties-common apt-transport-https
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
sudo systemctl enable --now grafana-server
sudo ufw allow ${GRAFANA_PORT}

# === Wait for Grafana to start ===
sleep 10

# === Add Prometheus Data Source ===
echo "Configuring Grafana data source..."
curl -s -X POST http://localhost:${GRAFANA_PORT}/api/datasources \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_ADMIN}:${GRAFANA_PASS} \
  -d '{
    "name":"Prometheus",
    "type":"prometheus",
    "url":"http://localhost:9100",
    "access":"proxy",
    "basicAuth":false
  }'

# === Import Dashboard ===
echo "Importing Grafana dashboard..."
curl -s -X POST http://localhost:${GRAFANA_PORT}/api/dashboards/import \
  -H "Content-Type: application/json" \
  -u ${GRAFANA_ADMIN}:${GRAFANA_PASS} \
  -d "{
    \"dashboard\": {
      \"id\": ${DASHBOARD_ID},
      \"uid\": null,
      \"title\": \"Node Exporter Full\",
      \"tags\": [],
      \"timezone\": \"browser\",
      \"schemaVersion\": 16,
      \"version\": 0
    },
    \"overwrite\": true,
    \"inputs\": []
  }"

# === Final Output ===
IP=$(hostname -I | awk '{print $1}')
echo ""
echo "Matt-Tailnet is live!"
echo "Cockpit: https://${IP}:9090"
echo "Grafana: http://${IP}:${GRAFANA_PORT} (admin/admin)"
echo "Node Exporter: http://${IP}:9100"
echo "Tailscale status:"

tailscale status

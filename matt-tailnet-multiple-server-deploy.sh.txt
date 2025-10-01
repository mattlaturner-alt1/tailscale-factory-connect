#!/bin/bash

# === CONFIGURATION ===
TAILSCALE_AUTH_KEY="tskey-xxxxxxxxxxxxxxxx"  # Replace with your actual key
ADVERTISE_SUBNET="192.168.1.0/24"            # Optional: leave empty to skip
SSH_USER="ubuntu"                            # Change if needed
SSH_KEY="~/.ssh/id_rsa"                      # Path to your private key

# === SERVER LIST === add/remove server IP addresses
SERVERS=(
  "192.168.1.101"
  "192.168.1.102"
  "192.168.1.103"
)

# === INSTALL SCRIPT ===
INSTALL_COMMANDS=$(cat <<EOF
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --authkey=${TAILSCALE_AUTH_KEY} ${ADVERTISE_SUBNET:+--advertise-routes=${ADVERTISE_SUBNET}}
EOF
)

# === DEPLOY LOOP ===
for HOST in "${SERVERS[@]}"; do
  echo "🚀 Deploying Tailscale to $HOST..."
  ssh -i ${SSH_KEY} ${SSH_USER}@${HOST} "${INSTALL_COMMANDS}"
  echo "✅ $HOST complete."
done

echo "🎉 All servers deployed to Matt-Tailnet."
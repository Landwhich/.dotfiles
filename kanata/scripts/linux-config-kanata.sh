#! bin/bash

sudo groupdel uinput 2>/dev/null
sudo groupadd --system uinput

sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

sudo modprobe uinput

sudo tee /etc/udev/rules.d/99-input.rules > /dev/null <<EOF
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF

sudo udevadm control --reload-rules && sudo udevadm trigger

mkdir -p ~/.config/systemd/user

echo "----"
echo "Kanata Config for Linux Successful"
echo "----"

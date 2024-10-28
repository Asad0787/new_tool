#!/data/data/com.termux/files/usr/bin/bash

# Dependencies install karen
pkg update -y
pkg install -y proot qemu-user-static tar wget

# Root filesystem ke liye directory banayein
mkdir -p ~/ubuntu-64bit
cd ~/ubuntu-64bit

# 64-bit Ubuntu root filesystem download karen
echo "64-bit Ubuntu root filesystem download ho raha hai..."
wget -O ubuntu-rootfs.tar.gz https://partner-images.canonical.com/core/focal/current/ubuntu-focal-core-cloudimg-arm64-root.tar.gz

# Root filesystem extract karen
echo "Root filesystem extract ho raha hai..."
tar -xzf ubuntu-rootfs.tar.gz

# Tar file delete karen
rm ubuntu-rootfs.tar.gz

# Ek start script banayein jo 64-bit environment ko enter kare
cat << 'EOF' > start-64bit.sh
#!/data/data/com.termux/files/usr/bin/bash
cd ~/ubuntu-64bit
proot -0 -q qemu-aarch64-static -r ~/ubuntu-64bit -b /dev/ -b /proc/ -b /sys/ /bin/bash
EOF

# Start script executable banayein
chmod +x start-64bit.sh

# Environment me enter karke Python install karen
echo "Python install karne ke liye 64-bit environment me enter ho raha hai..."
proot -0 -q qemu-aarch64-static -r ~/ubuntu-64bit -b /dev/ -b /proc/ -b /sys/ /bin/bash << 'EOF'
apt update
apt install -y python3
EOF

echo "Setup complete ho gaya. 'bash start-64bit.sh' run karke 64-bit environment me jaayein jahan Python available hai."

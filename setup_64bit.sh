#!/bin/bash

# Install proot-distro if not already installed
if ! command -v proot-distro &> /dev/null
then
    echo "Installing proot-distro..."
    pkg install proot-distro -y
fi

# Install 64-bit Ubuntu environment using proot-distro
echo "Installing 64-bit Ubuntu environment..."
proot-distro install ubuntu-20.04

# Create enter_64bit.sh to enter 64-bit environment and run Python code
cat << 'EOF' > enter_64bit.sh
#!/bin/bash
# Enter the Ubuntu 64-bit environment
proot-distro login ubuntu-20.04 -- bash -c "
    apt update && apt install -y python3 python3-pip

    # Check if 64-bit .so file is present
    if [ ! -f /home/64bit_file.so ]; then
        echo '64-bit .so file not found at /home/64bit_file.so'
        echo 'Please place your 64-bit .so file in this location and try again.'
        exit 1
    fi

    # Set PYTHONPATH, import the module, and run main()
    export PYTHONPATH=/home
    python3 -c 'import chandu_pro; chandu_pro.x23x()'
"
EOF

# Make enter_64bit.sh executable
chmod +x enter_64bit.sh

echo "Setup complete."
echo "Place your 'chandu_pro.cpython-312.so' file at '/home/64bit_file.so' and run './enter_64bit.sh' to execute your code."

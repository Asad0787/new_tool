#!/bin/bash

# Check if proot-distro is installed
if ! command -v proot-distro &> /dev/null
then
    echo "Installing proot-distro..."
    pkg install proot-distro -y
fi

# Install Ubuntu 20.04 (64-bit)
echo "Installing 64-bit Ubuntu environment using proot-distro..."
proot-distro install ubuntu-20.04

# Create a script to enter the 64-bit Ubuntu environment and run the Python code
cat << 'EOF' > enter_64bit.sh
#!/bin/bash
# Enter the Ubuntu 64-bit environment
proot-distro login ubuntu-20.04 -- bash -c "
    apt update && apt install -y python3 python3-pip

    # Check if required .so file is present
    if [ ! -f /home/64bit_file.so ]; then
        echo '64-bit .so file not found in /home/64bit_file.so'
        echo 'Please place your 64-bit .so file in this location and try again.'
        exit 1
    fi

    # Set PYTHONPATH and run Python script
    export PYTHONPATH=/home
    python3 -c 'import chandu_pro'  # Example: Replace with your actual usage
"
EOF

# Make enter_64bit.sh executable
chmod +x enter_64bit.sh

echo "Setup complete."
echo "To use the 64-bit environment and run your .so file, place it in the /home/64bit_file.so location."
echo "Then, run './enter_64bit.sh' to start the environment and execute your Python code."

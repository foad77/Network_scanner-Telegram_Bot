#!/bin/bash
clear

# Load configuration from YAML
CONFIG_FILE="config.yaml"

# Function to determine the OS and fetch IP information
get_network_info() {
    OS=$(uname -s)
    if [ "$OS" = "Darwin" ]; then
        INTERFACES=$(yq '.network_interfaces.mac[]' $CONFIG_FILE)
    elif [ "$OS" = "Linux" ]; then
        INTERFACES=$(yq '.network_interfaces.linux[]' $CONFIG_FILE)
    else
        echo "Unsupported OS"
        exit 1
    fi

    for INTERFACE in $INTERFACES; do
        if [ "$OS" = "Darwin" ]; then
            IP_INFO=$(ifconfig $INTERFACE | awk '/inet /{print $2}')
            if [ -n "$IP_INFO" ]; then
                NETMASK=$(ifconfig $INTERFACE | awk '/netmask /{printf("%x\n",$4)}' | sed 's/..../&./g')
                break
            fi
        elif [ "$OS" = "Linux" ]; then
            IP_INFO=$(ip -4 addr show $INTERFACE | grep -oP 'inet \K[\d.]+')
            if [ -n "$IP_INFO" ]; then
                NETMASK=$(ip -4 addr show $INTERFACE | grep -oP 'inet.*\K/\d+')
                break
            fi
        fi
    done

    if [ -z "$IP_INFO" ]; then
        echo "No active network interface found."
        exit 1
    fi

    # Assuming CIDR /24 for simplicity, adjust as needed based on NETMASK if required
    NETWORK="${IP_INFO}/24"
}

# Get network configuration
get_network_info

# Display scan options
echo "Which type of scan do you want the nmap to have?"
echo "0- ARP Scan: Quickly list all active IPs on your local network."
echo "1- Ping Scan (-sn): Quick check if hosts are online."
echo "2- List Scan (-sL): Resolves IP addresses to hostnames."
echo "3- Quick Scan (-T4 with limited ports): Scans top 100 ports quickly."
echo "4- Port Scan (-p): Scans specific ports or full range."
echo "5- Service Version Detection (-sV): Detects services running on open ports."
echo "6- OS Detection (-O): Attempts to determine the operating system."
echo "7- Aggressive Scan (-A): Comprehensive scan including OS, version detection, and script scanning."
echo "8- Full Scan with All Advanced Features (-p1-65535 -T4 -A --version-all -sC): Most detailed scan of every port and feature."

read -p "Enter the scan type number (0-8): " SCAN_CHOICE

case $SCAN_CHOICE in
    0)
        echo "Performing ARP scan..."
        sudo arp-scan --localnet | less
        exit 0
        ;;
    1) FLAGS="-sn"
       SCAN_FLAG="sn"
       ;;
    2) FLAGS="-sL"
       SCAN_FLAG="sL"
       ;;
    3) FLAGS="-T4 -F"
       SCAN_FLAG="T4F"
       ;;
    4) 
        read -p "Enter the port or range (e.g., 80, 1-65535): " PORT_RANGE
        FLAGS="-p$PORT_RANGE"
        SCAN_FLAG="p$PORT_RANGE"
        ;;
    5) FLAGS="-sV"
       SCAN_FLAG="sV"
       ;;
    6) FLAGS="-O"
       SCAN_FLAG="O"
       ;;
    7) FLAGS="-A"
       SCAN_FLAG="A"
       ;;
    8) FLAGS="-p1-65535 -T4 -A --version-all -sC"
       SCAN_FLAG="full"
       ;;
    *) echo "Invalid choice, exiting."
       exit 1
       ;;
esac

# Run nmap scan with selected options
nmap $FLAGS $NETWORK -oX LANscanResult.xml

# Call Python script to process the results
if command -v python &>/dev/null; then
    python parse_nmap_to_csv.py $SCAN_FLAG
elif command -v python3 &>/dev/null; then
    python3 parse_nmap_to_csv.py $SCAN_FLAG
else
    echo "Python is not installed."
    exit 1
fi

# Cleanup XML file
rm LANscanResult.xml

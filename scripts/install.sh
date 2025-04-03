#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Installation directory
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="mcli"
SCRIPT_SRC="src/minio_cli_manager.sh"

# Function to print status
print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

# Check if we have root permissions
check_permissions() {
    if [ ! -w "$INSTALL_DIR" ]; then
        print_error "Write permissions needed for $INSTALL_DIR"
        echo "Please run 'sudo ./install.sh' instead"
        exit 1
    fi
}

# Main installation
install_mcli() {
    print_status "Installing MinIO CLI Manager..."
    
    # Check if source file exists
    if [ ! -f "$SCRIPT_SRC" ]; then
        print_error "Source file not found: $SCRIPT_SRC"
        exit 1
    }
    
    # Copy the script
    cp "$SCRIPT_SRC" "$INSTALL_DIR/$SCRIPT_NAME"
    
    # Make the script executable
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    # Verify installation
    if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
        print_status "Installation complete! You can now use '$SCRIPT_NAME' from anywhere."
        print_status "Try it by typing: $SCRIPT_NAME"
    else
        print_error "Installation failed."
        exit 1
    fi
}

# Uninstall function
uninstall_mcli() {
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        rm "$INSTALL_DIR/$SCRIPT_NAME"
        print_status "MinIO CLI Manager has been uninstalled."
    else
        print_error "Installation not found."
    fi
}

# Handle command line arguments
case "$1" in
    "uninstall")
        check_permissions
        uninstall_mcli
        ;;
    *)
        check_permissions
        install_mcli
        ;;
esac 
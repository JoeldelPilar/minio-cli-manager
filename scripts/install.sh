#!/bin/bash

# Colors for output
GREEN='\\033[0;32m'
RED='\\033[0;31m'
NC='\\033[0m'

# Installation directory
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="mcli"
# Determine script directory and source file path robustly
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_SRC="$SCRIPT_DIR/../src/minio_cli_manager.sh"

# Function to print status
print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

# Check if script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root."
        # Suggest how to run it, adapting to how the script was likely invoked
        local script_path="${BASH_SOURCE[0]}"
        echo "Please run 'sudo $script_path' or 'sudo $script_path uninstall'"
        exit 1
    fi
}

# Main installation
install_mcli() {
    print_status "Installing MinIO CLI Manager..."

    # Check if source file exists
    if [ ! -f "$SCRIPT_SRC" ]; then
        print_error "Source file not found: $SCRIPT_SRC"
        print_error "Ensure 'src/minio_cli_manager.sh' exists relative to the project root."
        exit 1
    fi

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
        print_error "Check if $INSTALL_DIR is in your PATH."
        exit 1
    fi
}

# Uninstall function
uninstall_mcli() {
    print_status "Uninstalling MinIO CLI Manager..."
    if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
        rm "$INSTALL_DIR/$SCRIPT_NAME"
        # Verify uninstallation
        if command -v "$SCRIPT_NAME" >/dev/null 2>&1; then
             print_error "Uninstallation failed to remove the command from PATH immediately."
             print_status "Please open a new terminal or run 'hash -r' (bash/zsh)."
        else
             print_status "MinIO CLI Manager has been uninstalled."
        fi
    else
        print_error "Installation not found at $INSTALL_DIR/$SCRIPT_NAME."
    fi
}

# Handle command line arguments
case "$1" in
    "uninstall")
        check_root # Use check_root instead of check_permissions
        uninstall_mcli
        ;;
    *)
        check_root # Use check_root instead of check_permissions
        install_mcli
        ;;
esac

exit 0 # Explicitly exit with success 
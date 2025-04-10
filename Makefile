# Variables
SCRIPT_NAME = mcli
INSTALL_DIR = /usr/local/bin
SRC_DIR = src
SCRIPT_SRC = $(SRC_DIR)/minio_cli_manager.sh
SCRIPTS_DIR = scripts

# Colors for output
GREEN = \033[0;32m
NC = \033[0m

# Default command when just typing 'make'
.PHONY: all
all: help

# Show help
.PHONY: help
help:
	@echo "MinIO CLI Manager - Available commands:"
	@echo ""
	@echo "  make install    - Install mcli globally"
	@echo "  make uninstall - Uninstall mcli"
	@echo "  make test      - Run tests"
	@echo "  make clean     - Clean up temporary files"
	@echo "  make help      - Show this help"
	@echo ""
	@echo "Example:"
	@echo "  make install"

# Install the script
.PHONY: install
install:
	@echo "${GREEN}==>${NC} Installing MinIO CLI Manager..."
	@chmod +x $(SCRIPTS_DIR)/install.sh
	@sudo ./$(SCRIPTS_DIR)/install.sh

# Uninstall the script
.PHONY: uninstall
uninstall:
	@echo "${GREEN}==>${NC} Uninstalling MinIO CLI Manager..."
	@chmod +x $(SCRIPTS_DIR)/install.sh
	@sudo ./$(SCRIPTS_DIR)/install.sh uninstall

# Run tests
.PHONY: test
test:
	@echo "${GREEN}==>${NC} Running tests..."
	@chmod +x tests/test_minio_handler.sh
	@./tests/test_minio_handler.sh

# Clean up
.PHONY: clean
clean:
	@echo "${GREEN}==>${NC} Cleaning up..."
	@find . -type f -name "*.tmp" -delete
	@find . -type f -name "*.log" -delete
	@find . -type f -name ".DS_Store" -delete
	@echo "${GREEN}==>${NC} Done!"

# Check installation
.PHONY: check
check:
	@echo "${GREEN}==>${NC} Checking installation..."
	@if command -v $(SCRIPT_NAME) >/dev/null 2>&1; then \
		echo "$(SCRIPT_NAME) is installed and available."; \
		echo "Location: $$(which $(SCRIPT_NAME))"; \
	else \
		echo "$(SCRIPT_NAME) is not installed."; \
	fi 
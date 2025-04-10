# <span style="color: #61AFEF">MinIO File Management System</span>

An interactive terminal-based tool for managing files in MinIO storage. The script provides a user-friendly interface with color coding and clear navigation.

## 🚀 Features

- 📤 Upload files to MinIO
- 📥 Download files from MinIO
- 📋 List files and directories
- 🔄 Easy directory navigation
- 🎨 Color-coded interface
- 🔐 Support for multiple MinIO aliases

## ⚙️ Installation

1.  **Prerequisites:**
    *   Ensure you have `git` and `make` installed on your system.
    *   Make sure you have the MinIO Client (`mc`) installed and configured with your desired aliases. You can set up aliases using:
        ```bash
        mc alias set <your-alias-name> <minio-url> <access-key> <secret-key>
        ```

2.  **Clone the Repository:**
    ```bash
    git clone https://github.com/joeldelpilar/minio-cli-manager.git
    cd minio-cli-manager
    ```

3.  **Install the `mcli` command:**
    This command will copy the script to `/usr/local/bin` and make it executable. It requires administrator privileges.
    ```bash
    sudo make install
    ```
    The script will confirm successful installation.

## 🔧 Configuration

You can configure your MinIO aliases through environment variables:
```bash
export MINIO_ALIAS_ONE="your-alias-1"
export MINIO_ALIAS_TWO="your-alias-2"
export MINIO_ALIAS_THREE="your-alias-3"
export MINIO_ALIAS_FOUR="your-alias-4"
export MINIO_ALIAS_FIVE="your-alias-5"
```

## 🎮 Usage

Once installed, you can run the MinIO CLI Manager from anywhere in your terminal by simply typing:

```bash
mcli
```

The script will launch, presenting you with the main menu:

1.  Upload a file
2.  Download a file
3.  List files
0.  Exit script

Follow the on-screen prompts to interact with your MinIO storage.

### Main menu offers the following options:
1. Upload a file
2. Download a file
3. List files
0. Exit script

## ⬆️ Updating

To update `mcli` to the latest version from the repository:

1.  Navigate to your cloned repository directory:
    ```bash
    cd path/to/minio-cli-manager # The directory where you originally ran 'git clone'
    ```
2.  Pull the latest changes from the repository:
    ```bash
    git pull origin main
    ```
3.  Re-install the script to copy the updated version:
    ```bash
    sudo make install
    ```

## 🗑️ Uninstallation

To remove the `mcli` command from your system:

1.  Navigate to your cloned repository directory:
    ```bash
    cd path/to/minio-cli-manager
    ```
2.  Run the uninstallation command using the Makefile:
    ```bash
    sudo make uninstall
    ```

## 🎨 Color Scheme

- 🎀 Sakura Pink: User input
- ⚪ Fuji White: Normal text
- 🔵 Dragon Blue: Headers and important information

## ⚠️ Requirements

- MinIO Client (mc)
- Bash shell
- Terminal with ANSI color support

## 🤝 Contributing

Feel like improving the script? Feel free to contribute by:
1. Forking the repository
2. Creating a feature branch
3. Committing your changes
4. Pushing to the branch
5. Creating a Pull Request

## 📝 License

This project is open source and available under the MIT license. 
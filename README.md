# <span style="color: #61AFEF">MinIO File Management System</span>

An interactive terminal-based tool for managing files in MinIO storage. The script provides a user-friendly interface with color coding and clear navigation.

## 🚀 Features

- 📤 Upload files to MinIO
- 📥 Download files from MinIO
- 📋 List files and directories
- 🔄 Easy directory navigation
- 🎨 Beautiful color-coded interface
- 🔐 Support for multiple MinIO aliases

## ⚙️ Installation

1. Make sure you have MinIO Client (mc) installed
2. Configure your MinIO aliases with:
   ```bash
   mc alias set <alias-name> <minio-url> <access-key> <secret-key>
   ```
3. Make the script executable:
   ```bash
   chmod +x minio_terminal_handler.sh
   ```

## 🔧 Configuration

You can configure your MinIO aliases through environment variables:
```bash
export MINIO_ALIAS_ONE="your-alias-1"
export MINIO_ALIAS_TWO="your-alias-2"
export MINIO_ALIAS_THREE="your-alias-3"
export MINIO_ALIAS_FOUR="your-alias-4"
export MINIO_ALIAS_FIVE="your-alias-5"
```

If no environment variables are set, the default aliases "mlgn" and "mlgn-hallonpi" will be used.

## 🎮 Usage

Run the script with:
```bash
./minio_terminal_handler.sh
```

### Main menu offers the following options:
1. Upload a file
2. Download a file
3. List files
0. Exit script

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
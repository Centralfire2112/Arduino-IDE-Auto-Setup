# Arduino IDE Auto Setup 🚀

A simple, automated batch script for installing Arduino IDE on Windows systems. Perfect for schools, labs, or anyone who needs to quickly set up Arduino IDE on multiple machines.

![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Arduino](https://img.shields.io/badge/Arduino-00979D?style=for-the-badge&logo=Arduino&logoColor=white)
![Batch](https://img.shields.io/badge/Batch-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)

## ✨ Features

- **🔍 Smart Detection**: Automatically checks if Arduino IDE is already installed
- **⬇️ Auto Download**: Downloads the latest Arduino IDE (v2.3.3) from official sources
- **📦 Easy Installation**: Extracts and installs to `C:\arduino-ide`
- **🔗 Desktop Shortcut**: Creates a desktop shortcut automatically
- **🌐 Universal Support**: Works with OneDrive Desktop, standard Desktop, and custom locations
- **🧹 Auto Cleanup**: Removes temporary files after installation
- **💬 Clear Feedback**: Provides detailed status messages throughout the process

## 📋 Requirements

- Windows 7 or later
- Administrator privileges (recommended)
- Internet connection for downloading Arduino IDE
- ~500MB free disk space

## 🚀 Quick Start

### Method 1: Download and Run

1. Download `setup_arduino.bat` from the [releases page](https://github.com/yourusername/arduino-ide-setup/releases)
2. Double-click the file to run it
3. Wait for the installation to complete
4. Find the Arduino IDE shortcut on your desktop

### Method 2: Clone Repository

```bash
git clone https://github.com/yourusername/arduino-ide-setup.git
cd arduino-ide-setup
```

Double-click `setup_arduino.bat` to run it

### Method 3: Host Locally

Host the download page on your local network:

```bash
# Make sure Node.js is installed
node server.js
```

Or simply double-click `START_SERVER.bat` on Windows.

Then visit `http://localhost:6565` in your browser.

## 📖 How It Works

1. **Detection Phase**
   - Checks if Arduino IDE exists at `C:\arduino-ide`
   - Verifies the executable file is present

2. **Download Phase** (if needed)
   - Downloads Arduino IDE v2.3.3 from official Arduino website
   - Saves to temporary location
   - Validates download completion

3. **Installation Phase**
   - Extracts files to temporary folder
   - Moves to final location `C:\arduino-ide`
   - Removes old installation if present

4. **Shortcut Creation**
   - Detects actual Desktop location (handles OneDrive)
   - Creates shortcut using PowerShell
   - Verifies shortcut creation

5. **Cleanup**
   - Removes temporary files
   - Removes temporary folders
   - Displays completion message

## 🛠️ Configuration

You can customize the script by editing these variables at the top of `setup_arduino.bat`:

```batch
set "ARDUINO_DIR=C:\arduino-ide"
set "DOWNLOAD_URL=https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.3_Windows_64bit.zip"
set "SHORTCUT_NAME=Arduino IDE.lnk"
```

### Change Installation Directory

```batch
set "ARDUINO_DIR=D:\Programs\arduino-ide"
```

### Use Different Arduino IDE Version

Update the `DOWNLOAD_URL` to point to your desired version:

```batch
set "DOWNLOAD_URL=https://downloads.arduino.cc/arduino-ide/arduino-ide_X.X.X_Windows_64bit.zip"
```

## 🔧 Troubleshooting

### Script closes immediately with error

**Solution**: Run as Administrator. Right-click the file and select "Run as administrator"

### Download fails

**Solution**: 
- Check your internet connection
- Verify the download URL is still valid
- Try running the script again

### Shortcut not created

**Solution**: 
- The script will show the Arduino IDE location
- Manually create a shortcut to the displayed path
- Check if your antivirus is blocking the script

### "Access Denied" errors

**Solution**: 
- Run the script as Administrator
- Check if `C:\` drive has write permissions
- Try installing to a different directory

## 📁 File Structure

```
arduino-ide-setup/
├── setup_arduino.bat    # Main installation script
├── index.html          # Download website
├── server.js           # Node.js web server (port 6565)
├── package.json        # Node.js package configuration
├── START_SERVER.bat    # Quick start server script
├── README.md           # This file
├── LICENSE             # MIT License
└── .gitignore          # Git ignore rules
```

## 🎓 Use Cases

- **Schools & Universities**: Quick setup for computer labs
- **Workshops**: Fast deployment for Arduino workshops
- **IT Departments**: Automated installation for multiple machines
- **Personal Use**: Easy Arduino IDE installation

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This script downloads Arduino IDE from the official Arduino website. The Arduino IDE itself is licensed under the GNU General Public License. This script is not affiliated with or endorsed by Arduino.

## 🙏 Acknowledgments

- [Arduino](https://www.arduino.cc/) for the amazing IDE
- The open-source community for inspiration

## 📞 Support

If you encounter any issues or have questions:

- Open an [issue](https://github.com/yourusername/arduino-ide-setup/issues)
- Check existing issues for solutions
- Read the troubleshooting section above

## 🔄 Updates

### Version 1.0.0 (Current)
- Initial release
- Auto-download and installation
- Desktop shortcut creation
- OneDrive Desktop support
- Universal Desktop location detection

---

**Made with ❤️ for the Arduino community**

⭐ Star this repository if you find it helpful!

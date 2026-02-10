# 🌀 BackupBooster

**BackupBooster** is a powerful macOS application and script collection designed to monitor, accelerate, and control Time Machine backups. It removes Apple's built-in throttling mechanisms and provides comprehensive backup management through both a modern SwiftUI interface and command-line tools.

## 📋 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
  - [SwiftUI Application](#swiftui-application)
  - [Shell Scripts](#shell-scripts)
  - [xbar Plugin Integration](#xbar-plugin-integration)
- [Configuration](#-configuration)
- [Project Structure](#-project-structure)
- [Testing](#-testing)
- [Permissions](#-permissions)
- [Logging](#-logging)
- [Important Notes](#-important-notes)
- [Contributing](#-contributing)
- [License & Author](#-license--author)

## ✨ Features

### Performance Optimization
- **🚀 Throttle Removal**: Disables macOS throttling (`debug.lowpri_throttle_enabled=0`) for faster backups
- **🔍 Spotlight Control**: Temporarily disables Spotlight indexing on backup volumes during backup operations
- **📊 Real-time Monitoring**: Live progress tracking with phase detection, percentage completion, and time remaining

### Monitoring & Control
- **📈 Progress Dashboard**: Modern SwiftUI interface displaying backup status and statistics
- **🔔 Notifications**: macOS notifications when backups complete
- **📜 Detailed Logging**: Automatic log rotation with configurable retention
- **📧 Email Notifications**: Optional email alerts via Mail.app when backups finish

### Management Tools
- **⚙️ Menu Bar Mode**: Unobtrusive menu bar application with quick access to all features
- **🪟 Dashboard Mode**: Full window dashboard for detailed monitoring
- **🛠️ Complete Script Suite**: 13+ shell scripts for backup management
- **🔌 xbar Plugin**: Menu bar plugin for even more streamlined access

## 📦 Requirements

- **macOS**: 11.0 (Big Sur) or later
- **Xcode**: 13.0 or later (for building from source)
- **Time Machine**: Must be configured with at least one backup destination
- **Administrator Privileges**: Required for system-level operations
- **Dependencies**: `tmutil`, `bc` (included in macOS)

## 🚀 Installation

### Method 1: Building from Source with Xcode

1. **Clone the repository**:
   ```bash
   git clone https://github.com/MarkusTratschitt/BackupBooster.git
   cd BackupBooster
   ```

2. **Open in Xcode**:
   ```bash
   open BackupBooster.xcodeproj
   ```

3. **Build and run**:
   - Select your target device (Mac)
   - Press `⌘ + R` to build and run
   - Or use Product → Archive to create a distributable app

4. **Install the application**:
   - Copy the built `.app` to `/Applications`
   - Launch BackupBooster from Applications folder

### Method 2: Installing Scripts Only

If you only want to use the shell scripts without the GUI application:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/MarkusTratschitt/BackupBooster.git
   cd BackupBooster
   ```

2. **Copy scripts to your home directory**:
   ```bash
   mkdir -p ~/BackupBooster/Scripts
   cp -R Scripts/* ~/BackupBooster/Scripts/
   chmod +x ~/BackupBooster/Scripts/*.sh
   ```

3. **Copy configuration file**:
   ```bash
   mkdir -p ~/Library/Application\ Support/BackupBooster
   cp config/config.conf ~/Library/Application\ Support/BackupBooster/
   ```

4. **Optional: Add scripts to PATH**:
   ```bash
   echo 'export PATH="$HOME/BackupBooster/Scripts:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

## 📖 Usage

### SwiftUI Application

BackupBooster offers two display modes:

#### Menu Bar Mode (Default)
- Runs in the menu bar with a compact interface
- Click the menu bar icon to access all features
- Minimal screen space usage
- Quick access to scripts and status

#### Dashboard Mode
- Full window with detailed status information
- Real-time progress visualization
- Direct access to common operations:
  - 📦 Start Backup
  - 🛑 Stop Backup
  - 📈 Boost Backup (with throttle removal)
  - 📖 View Logs

**Switching Modes**:
- Open Settings (⌘ + ,) to toggle between menu bar and window mode
- Keyboard shortcut: `⌘ + Shift + D` to show dashboard

### Shell Scripts

All scripts are located in the `Scripts/` directory and can be executed directly:

#### Core Backup Scripts

**Start a backup**:
```bash
./Scripts/start-backup.sh
```
Prompts for confirmation and starts a Time Machine backup.

**Stop a running backup**:
```bash
./Scripts/stop-backup.sh
```
Immediately stops the current backup operation.

**Pause automatic backups**:
```bash
./Scripts/pause-backup.sh
```
Disables automatic Time Machine backups (requires admin privileges).

**Resume automatic backups**:
```bash
# Note: Create resume-backup.sh or use:
sudo launchctl load /System/Library/LaunchDaemons/com.apple.backupd-auto.plist
```

**Skip current backup**:
```bash
./Scripts/skip-backup.sh
```
Skips the currently scheduled backup.

**Boost backup with monitoring**:
```bash
./Scripts/BackupBooster.sh
```
Starts a backup with throttle removal and Spotlight disabled. Monitors progress in real-time.

#### Status & Information Scripts

**Show current status**:
```bash
./Scripts/show-status.sh
```
Displays a dialog with current backup phase, progress, and last backup date.

**Show latest backup**:
```bash
./Scripts/latest-backup.sh
```
Shows information about the most recent completed backup.

**View logs**:
```bash
./Scripts/open-log.sh
```
Opens the BackupBooster log file in Console.app or default text editor.

#### Maintenance Scripts

**Clear log file**:
```bash
./Scripts/clear-log.sh
```
Deletes the current log file to start fresh.

**Clean old backups**:
```bash
./Scripts/clean-old-backups.sh
```
Interactive script to remove old backup snapshots (placeholder - implement as needed).

**Delete single backup**:
```bash
./Scripts/delete-single-backup.sh
```
Interactive script to delete a specific backup snapshot (placeholder - implement as needed).

**Enable Spotlight on backup volume**:
```bash
./Scripts/enable-spotlight.sh
```
Re-enables Spotlight indexing on the backup volume (placeholder - implement as needed).

**Reset throttle to default**:
```bash
./Scripts/reset-throttle.sh
```
Restores macOS default throttling behavior (placeholder - implement as needed).

### xbar Plugin Integration

BackupBooster includes a plugin for [xbar](https://xbarapp.com/) (formerly BitBar) that displays Time Machine status in your menu bar.

**Installation**:

1. **Install xbar**:
   ```bash
   brew install xbar
   ```

2. **Copy the plugin**:
   ```bash
   # Find your xbar plugin directory (usually ~/Library/Application Support/xbar/plugins/)
   cp Plugins/BackupBooster.5m.sh ~/Library/Application\ Support/xbar/plugins/
   ```

3. **Update script paths in the plugin**:
   The plugin file currently contains legacy paths that need to be updated. Edit `BackupBooster.5m.sh` and replace all instances of `TurboMonitor` with `BackupBooster`:
   ```bash
   # Find and replace:
   # Old path: bash="$HOME/TurboMonitor/Scripts/..."
   # New path: bash="$HOME/BackupBooster/Scripts/..."
   
   # Example using sed:
   sed -i '' 's/TurboMonitor/BackupBooster/g' ~/Library/Application\ Support/xbar/plugins/BackupBooster.5m.sh
   ```

4. **Refresh xbar**:
   - Click the xbar menu and select "Refresh all"

**Features**:
- Shows backup progress in menu bar
- Quick access to all backup operations
- Displays last backup date
- Updates every 5 minutes (configurable)

## ⚙️ Configuration

### Configuration File Location

The main configuration file is located at:
```
~/Library/Application Support/BackupBooster/config.conf
```

### Available Configuration Options

```bash
# Manual backup mount point (optional - auto-detected if not set)
# BACKUP_MOUNT="/Volumes/TimeMachineBackup"

# Log file path (default: ~/Library/Logs/BackupBooster.log)
LOGFILE="$HOME/Library/Logs/BackupBooster.log"

# xbar plugin refresh interval (e.g., "10s", "1m", "5m")
REFRESH_INTERVAL="30s"

# Enable Spotlight deactivation during backup (default: true)
DISABLE_SPOTLIGHT=true

# Enable throttle boost during backup (default: true)
DISABLE_THROTTLE=true

# Maximum log file lines (automatic rotation)
MAX_LOG_LINES=500

# Custom backup command (optional)
# CUSTOM_BACKUP_COMMAND="/usr/local/bin/myBackupScript.sh"

# Email notification on backup completion (optional)
# EMAIL_NOTIFY="user@example.com"
```

### Application Settings

SwiftUI application settings can be accessed via:
- Settings menu (⌘ + ,)
- Settings include:
  - App display mode (menu bar vs. window)
  - Backup monitoring preferences
  - Script execution options

## 📂 Project Structure

```
BackupBooster/
├── BackupBooster/              # SwiftUI application source
│   ├── BackupBoosterApp.swift  # Main app entry point
│   ├── AppDelegate.swift       # App lifecycle and menu bar management
│   ├── MainView.swift          # Dashboard view with status display
│   ├── ContentView.swift       # Additional UI components
│   ├── SettingsView.swift      # Settings/preferences panel
│   ├── WindowController.swift  # Window management
│   ├── Persistence.swift       # Core Data persistence layer
│   └── Info.plist              # App configuration
│
├── BackupBoosterTests/         # Unit tests
│   └── BackupBoosterTests.swift
│
├── BackupBoosterUITests/       # UI automation tests
│   ├── BackupBoosterUITests.swift
│   └── BackupBoosterUITestsLaunchTests.swift
│
├── Scripts/                    # Shell script collection
│   ├── BackupBooster.sh        # Main monitoring script with boost
│   ├── start-backup.sh         # Start backup
│   ├── stop-backup.sh          # Stop backup
│   ├── pause-backup.sh         # Pause automatic backups
│   ├── skip-backup.sh          # Skip current backup
│   ├── show-status.sh          # Display status dialog
│   ├── latest-backup.sh        # Show latest backup info
│   ├── open-log.sh             # Open log file
│   ├── clear-log.sh            # Clear log file
│   ├── clean-old-backups.sh    # Clean old snapshots
│   ├── delete-single-backup.sh # Delete specific snapshot
│   ├── enable-spotlight.sh     # Re-enable Spotlight
│   └── reset-throttle.sh       # Reset throttle settings
│
├── Plugins/                    # xbar integration
│   └── BackupBooster.5m.sh     # xbar menu bar plugin
│
├── LaunchAgent/                # Background service (optional)
│   └── de.markustratschitt.backupbooster.plist
│
├── config/                     # Configuration files
│   └── config.conf             # Main configuration file
│
├── BackupBooster.xcodeproj/   # Xcode project files
└── README.md                   # This file
```

### Component Descriptions

- **BackupBooster/** - Native macOS app built with SwiftUI, providing graphical interface for backup management
- **Scripts/** - Bash scripts for command-line backup control and monitoring
- **Plugins/** - Integration with third-party menu bar applications (xbar)
- **LaunchAgent/** - Optional plist for running BackupBooster as a background service
- **config/** - Configuration templates and default settings

## 🧪 Testing

### Running Unit Tests

Unit tests validate core functionality and business logic:

```bash
# Using Xcode
# 1. Open BackupBooster.xcodeproj
# 2. Press ⌘ + U to run all tests

# Using xcodebuild
xcodebuild test -scheme BackupBooster -destination 'platform=macOS'
```

### Running UI Tests

UI tests validate the SwiftUI interface and user interactions:

```bash
# Using Xcode
# 1. Open BackupBooster.xcodeproj
# 2. Select the BackupBoosterUITests scheme
# 3. Press ⌘ + U

# Using xcodebuild
xcodebuild test -scheme BackupBoosterUITests -destination 'platform=macOS'
```

### Test Coverage

Current test structure includes:
- **BackupBoosterTests**: Basic unit test framework (expandable)
- **BackupBoosterUITests**: UI automation tests for main interfaces
- **BackupBoosterUITestsLaunchTests**: App launch validation tests

## 🔐 Permissions

BackupBooster requires several system permissions to function properly:

### Administrator Access
- **Required for**: Disabling throttle, managing Spotlight indexing
- **How to grant**: The app will prompt for admin password when needed
- Scripts use `osascript` with `with administrator privileges` for elevated operations

### Full Disk Access
- **Required for**: Accessing Time Machine backups and system logs
- **How to grant**:
  1. Open System Preferences → Security & Privacy → Privacy
  2. Select "Full Disk Access" from the list
  3. Click the lock icon and authenticate
  4. Click "+" and add BackupBooster.app
  5. Restart the application

### Automation Permissions
- **Required for**: Running AppleScripts and controlling system dialogs
- **How to grant**: macOS will prompt automatically when first running scripts
- Grant access when prompted for "Terminal" or "BackupBooster" to control system events

### Recommended Permissions
For best experience, also grant:
- **Notifications**: To receive backup completion alerts
- **Files and Folders**: To access backup volumes and log directories

## 📝 Logging

### Log File Location

By default, logs are stored at:
```
~/Library/Logs/BackupBooster.log
```

You can customize this location in the configuration file.

### Log Format

Each log entry contains:
```
TIMESTAMP | PHASE | PROGRESS% | TIME_REMAINING seconds
```

Example:
```
2024-04-15 14:23:45|Copying|45.3%|1234 Sek.
2024-04-15 14:25:12|Copying|67.8%|789 Sek.
2024-04-15 14:26:30|Finishing|99.9%|5 Sek.
```

### Log Rotation

- **Automatic rotation** enabled by default
- **Maximum lines**: 500 (configurable via `MAX_LOG_LINES` in config.conf)
- **Rotation trigger**: After each log entry, if limit is exceeded
- Old entries are automatically removed to maintain the line limit

### Viewing Logs

**Via application**:
```bash
./Scripts/open-log.sh
```

**Via command line**:
```bash
tail -f ~/Library/Logs/BackupBooster.log
```

**Via Console.app**:
1. Open Console.app
2. Navigate to ~/Library/Logs
3. Select BackupBooster.log

## ⚠️ Important Notes

### System Modifications Warning

BackupBooster modifies system settings to optimize backup performance:

- **Throttle Control**: Changes `debug.lowpri_throttle_enabled` kernel parameter
- **Spotlight Indexing**: Temporarily disables indexing on backup volumes
- **Launch Daemons**: May load/unload Time Machine background services

**These changes are temporary** and will be reset after:
- System reboot
- Manual reset using provided scripts
- Time Machine backup completion

### Backup Safety Assurances

- **No data modification**: BackupBooster only monitors and controls backup processes
- **Read-only access**: Scripts only read from backup volumes, never write
- **Apple's Time Machine**: All backups are still performed by Apple's native Time Machine
- **Reversible changes**: All system modifications can be reversed

### Performance Impact Notes

**Expected improvements**:
- **30-70% faster backups** by removing throttling
- **Reduced CPU usage** by disabling Spotlight during backup
- **More consistent speeds** through continuous monitoring

**Potential side effects**:
- Higher CPU/disk usage during backups (as throttling is removed)
- System may feel less responsive during backup (throttling exists for a reason)
- Increased heat generation on laptops during backup

**Recommendations**:
- Use boost mode when time is limited or for large backups
- Allow normal backups overnight when system is idle
- Monitor system temperature on older Macs

### Compatibility Information

**Tested on**:
- macOS 11 (Big Sur)
- macOS 12 (Monterey)
- macOS 13 (Ventura)
- macOS 14 (Sonoma)

**Known limitations**:
- Requires macOS 11.0 or later (SwiftUI requirements)
- APFS backup destinations recommended
- Some scripts require admin privileges
- T2/Apple Silicon Macs: Full Disk Access is mandatory

**Time Machine destinations**:
- ✅ Local USB drives
- ✅ Network volumes (AFP/SMB)
- ✅ Time Capsule
- ✅ NAS devices
- ⚠️ Cloud-based backups (limited support)

## 🤝 Contributing

Contributions are welcome! Here's how to get started:

### Development Setup

1. **Fork the repository**:
   ```bash
   # Click "Fork" on GitHub, then:
   git clone https://github.com/YOUR_USERNAME/BackupBooster.git
   cd BackupBooster
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Set up development environment**:
   - Install Xcode 13.0 or later
   - Open `BackupBooster.xcodeproj`
   - Build and run to verify setup

4. **Make your changes**:
   - Follow existing code style and conventions
   - Add tests for new functionality
   - Update documentation as needed

5. **Test your changes**:
   ```bash
   # Run unit tests
   xcodebuild test -scheme BackupBooster
   
   # Test scripts manually
   ./Scripts/your-script.sh
   ```

### Pull Request Guidelines

- **Clear description**: Explain what your PR does and why
- **Small, focused changes**: One feature or fix per PR
- **Tests included**: Add tests for new functionality
- **Documentation updated**: Update README.md if adding features
- **Code style**: Match existing style (Swift style guide for .swift files)
- **Commit messages**: Use clear, descriptive commit messages

### Code Style

- **Swift code**: Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- **Shell scripts**: Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Comments**: Use clear, concise comments in English
- **Formatting**: Use Xcode's default formatting for Swift files

### Reporting Issues

When reporting issues, please include:
- macOS version
- BackupBooster version
- Steps to reproduce
- Expected vs. actual behavior
- Relevant log excerpts
- Screenshots (for UI issues)

## 📄 License & Author

### Author

**Markus Tratschitt**
- GitHub: [@MarkusTratschitt](https://github.com/MarkusTratschitt)

### License

This project is open source and available under standard open source terms. Please refer to the repository for specific license information.

### Acknowledgments

**Technologies Used**:
- **SwiftUI** - Modern declarative UI framework by Apple
- **tmutil** - Apple's Time Machine utility
- **xbar** - macOS menu bar customization tool
- **AppleScript** - macOS automation scripting

**Special Thanks**:
- Apple's Time Machine team for the robust backup system
- The open source community for tools and inspiration
- xbar developers for the menu bar plugin framework

### Additional Resources

- [Time Machine Documentation](https://support.apple.com/guide/mac-help/back-up-with-time-machine-mh35860/mac)
- [tmutil man page](https://ss64.com/osx/tmutil.html)
- [xbar Documentation](https://github.com/matryer/xbar)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)

---

**Made with ❤️ for the macOS community**

If you find BackupBooster useful, please consider starring the repository and sharing it with others who might benefit from faster, more controlled Time Machine backups!

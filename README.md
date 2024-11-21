# Devops-assignment

#Jenikins installation

# Jenkins Installation Script

This repository contains a shell script for installing Jenkins in an OS-independent manner. The script supports various operating systems and allows users to specify the desired Jenkins version for installation.

## Features

- **OS Independence**: Automatically detects and adapts to Linux (Debian/Ubuntu, Red Hat/CentOS) and macOS environments.
- **Version Control**: Allows users to specify the Jenkins version to install.
- **Dependency Management**: Installs required dependencies, such as Java, if they are not already present.
- **Automation**: Simplifies the installation process by automating configurations.

## Requirements

Before running the script, ensure the following prerequisites:

1. **Supported Operating Systems**:
   - Linux (Debian-based like Ubuntu, Red Hat-based like CentOS)
   - macOS

2. **Dependencies**:
   - `curl` or `wget` must be installed for downloading files.
   - `sudo` privileges for installation.

3. **Java**:
   - Jenkins requires JDK 11 or higher. If not installed, the script will handle the installation.

## Usage

### Clone the Repository

Clone this repository to your local machine:

```bash
git clone <repository-url>
cd <repository-folder>


Make the Script Executable
Make the script executable by running the following command:

bash
chmod +x install_jenkins.sh

Run the Script
Run the script to install Jenkins. You can specify the Jenkins version as an optional argument. If no version is specified, the script will install the latest available version.

bash
Copy code
./install_jenkins.sh <version>
For example, to install Jenkins version 2.414.3:

bash
Copy code
./install_jenkins.sh 2.414.3
Access Jenkins
Once the installation is complete:

Open your browser and visit http://<your-server-ip>:8080.
Follow the on-screen instructions to complete the setup.
Logs and Outputs
The script logs the installation process for debugging purposes. Check the console output for any errors or warnings.

Script Details
OS Detection
The script automatically detects the operating system and adapts accordingly:

Debian/Ubuntu: Uses apt for installation.
Red Hat/CentOS: Uses yum for installation.
macOS: Uses brew for installation.
Java Installation
If Java is not installed or the required version is missing, the script installs OpenJDK.

Jenkins Version
Users can specify the version of Jenkins during execution. If no version is provided, the script installs the latest stable version.

Troubleshooting
Ensure that your system has a stable internet connection.
Run the script with sudo privileges.
If Java installation fails, manually install JDK 11 or higher and rerun the script.
Contributing
Contributions are welcome! If you encounter issues or want to add features:

Fork the repository.
Create a new branch (git checkout -b feature-branch).
Commit your changes (git commit -m "Add feature").
Push to the branch (git push origin feature-branch).
Submit a pull request.

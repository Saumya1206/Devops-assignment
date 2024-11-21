#!/bin/bash

# Function to detect operating system
detect_os() {
    echo "Detecting operating system..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            "ubuntu"|"debian") os="debian";;
            "rhel"|"centos") os="rhel";;
            "fedora") os="fedora";;
            "amzn") os="amazon-linux";;
            *)
                echo "Unsupported operating system: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect operating system"
        exit 1
    fi
    echo "Detected OS: $os"
}

# Function to get Java version
get_java_version() {
    while true; do
        echo "Available Java versions:"
        echo "1. Java 17 LTS"
        echo "2. Java 21 LTS"
        read -p "Select Java version (1 or 2): " choice
        case $choice in
            1) java_version="17"
               return;;
            2) java_version="21"
               return;;
            *) echo "Invalid choice. Please select 1 or 2";;
        esac
    done
}

# Function to install Java
install_java() {
    local version=$1
    echo "Installing Java $version..."
    
    if [[ "$os" == "debian" ]]; then
        apt update
        apt install -y openjdk-${version}-jdk
    elif [[ "$os" == "rhel" || "$os" == "fedora" ]]; then
        yum install -y java-${version}-openjdk
    elif [[ "$os" == "amazon-linux" ]]; then
        amazon-linux-extras install java-openjdk${version} -y
    fi
    
    java -version
    echo "Java installation completed"
}

# Function to get Jenkins version
get_jenkins_version() {
    while true; do
        read -p "Enter Jenkins version to install (e.g., 2.401.1): " version
        if [[ $version =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
            echo $version
            return
        else
            echo "Invalid version format. Please use format like 2.401.1"
        fi
    done
}

# Function to install Jenkins
install_jenkins() {
    local version=$1
    echo "Installing Jenkins version $version..."

    if [[ "$os" == "debian" ]]; then
        curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
        echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
        apt update
        apt install -y jenkins=$version
    elif [[ "$os" == "rhel" || "$os" == "fedora" || "$os" == "amazon-linux" ]]; then
        wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
        yum install -y jenkins-$version
    fi

    # Start Jenkins service
    systemctl start jenkins
    systemctl enable jenkins
}

# Function to show access instructions
show_instructions() {
    local java_ver=$1
    local jenkins_ver=$2
    echo -e "\nInstallation Complete!"
    echo -e "Installed versions:"
    echo -e "Java: $java_ver"
    echo -e "Jenkins: $jenkins_ver"
    echo -e "\nAccess Jenkins at: http://localhost:8080"
    echo -e "\nTo view the initial admin password:"
    echo -e "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}

# Main function
main() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root or with sudo"
        exit 1
    fi

    detect_os
    get_java_version
    install_java $java_version
    # jenkins_version=$(get_jenkins_version)
    # install_jenkins "$jenkins_version"
    show_instructions $java_version $jenkins_version
}

# Run main function
main
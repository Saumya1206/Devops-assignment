# Jenkins Pipeline Documentation: Disk Usage Monitoring System

## Table of Contents
1. [Introduction](#introduction)
2. [Pipeline Structure](#pipeline-structure)
3. [Code Breakdown](#code-breakdown)
4. [Configuration Details](#configuration-details)
5. [Script Analysis](#script-analysis)
6. [Email Notification System](#email-notification-system)
7. [Error Handling](#error-handling)

## Introduction

This document provides a detailed explanation of a Jenkins pipeline designed for monitoring disk usage across system partitions. The pipeline includes automated checks, threshold monitoring, and email notifications.

## Pipeline Structure

```groovy
pipeline {
    agent { label 'Sam-node' }
    options { ... }
    environment { ... }
    stages { ... }
    post { ... }
}
```

The pipeline is structured into five main sections:
1. Agent specification
2. Build options
3. Environment variables
4. Execution stages
5. Post-build actions

## Code Breakdown

### 1. Agent Configuration
```groovy
agent {
    label 'Sam-node'
}
```
- Specifies execution on nodes labeled 'Sam-node'
- Ensures consistent execution environment
- Allows for targeted deployment

### 2. Build Options
```groovy
options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 5, unit: 'MINUTES')
}
```
**Purpose:**
- Manages build history by keeping last 10 builds
- Prevents endless execution with 5-minute timeout
- Optimizes Jenkins storage usage

### 3. Environment Variables
```groovy
environment {
    THRESHOLD = '80'
    EMAIL_TO = 'saumyak874@gmail.com'
}
```
**Variables explained:**
- THRESHOLD: Defines critical disk usage percentage (80%)
- EMAIL_TO: Specifies notification recipient

## Configuration Details

### Build Retention
- Number of builds to keep: 10
- Implementation: `buildDiscarder` with `logRotator`
- Purpose: Prevents excessive disk usage on Jenkins server

### Timeout Settings
- Duration: 5 minutes
- Type: Pipeline-level timeout
- Action: Aborts build if exceeded

## Script Analysis

### Disk Usage Check Script
```bash
#!/bin/bash
echo "Checking disk usage on $(hostname)..."
df -H | grep -vE '^Filesystem|tmpfs|cdrom|devtmpfs' > disk_usage.txt
```

**Script Components:**
1. **Initial Check:**
   - Gets hostname for identification
   - Uses df -H for human-readable output

2. **Filtering:**
   - Removes system partitions
   - Focuses on relevant storage areas

3. **Processing:**
   ```bash
   while read -r line; do
       usage=$(echo "$line" | awk '{print $5}' | cut -d'%' -f1)
       partition=$(echo "$line" | awk '{print $1}')
       mountpoint=$(echo "$line" | awk '{print $6}')
   ```
   - Extracts usage percentage
   - Identifies partition details
   - Records mount points

4. **Alert Logic:**
   ```bash
   if [ "$usage" -ge "${THRESHOLD}" ]; then
       echo "WARNING: $partition ($mountpoint) is at $usage%"
       alert=1
   fi
   ```
   - Compares against threshold
   - Sets alert flag if exceeded
   - Records warning messages

### File Generation
The script generates three key files:
1. **disk_usage.txt:**
   - Contains filtered disk usage data
   - Format: Filesystem, Size, Used, Avail, Use%, Mounted on

2. **full_report.txt:**
   - Complete disk usage report
   - Includes all partitions and details

3. **alert_status:**
   - Binary indicator (0 or 1)
   - Triggers email notifications

## Email Notification System

### Configuration
```groovy
emailext (
    subject: "Jenkins Build ${env.JOB_NAME} - ${currentBuild.result ?: 'SUCCESS'}",
    body: emailBody,
    to: env.EMAIL_TO,
    attachLog: true,
    mimeType: 'text/plain',
    compressLog: true
)
```

### Email Components
1. **Subject Line:**
   - Includes job name
   - Shows build status
   - Unique identifier

2. **Email Body:**
   ```groovy
   def emailBody = """
       Job: ${env.JOB_NAME}
       Build Number: ${env.BUILD_NUMBER}
       Status: ${currentBuild.result ?: 'SUCCESS'}
       
       Disk Usage Report:
       ${readFile('full_report.txt')}
       
      
# Linux System Backup Automation

## Project Overview
A Bash Shell Scripting project designed to automate
Linux system backups, maintain logs, generate reports,
and remove old backup archives automatically.

## Features
- Multiple source directory backup
- Directory validation
- Compressed backup using tar.gz
- Logging and error handling
- Backup report generation
- Automatic cleanup of backups older than 7 days
- Cron job scheduling

## Technologies Used
- Red Hat Enterprise Linux (RHEL)
- Bash Shell Scripting
- Linux Commands
- tar
- cron

## Project Structure

linux-system-backup-automation/
├── backup.sh
├── README.md
├── .gitignore
├── backup/
├── logs/
├── reports/
└── config/

## How to Run

1. Clone the repository.
2. Navigate to the project directory.
3. Run the backup script:

   bash backup.sh /home/harry/backup-test

## Backup Format

Backup files are stored in compressed .tar.gz format.

## Automation

Cron is used to schedule automatic backups.

## Author
Abhinav Pandey

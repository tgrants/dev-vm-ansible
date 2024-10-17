#!/usr/bin/env bash
# This script installs and prepares github
# Last updated: 2024-10-16
# File created: {{ ansible_date_time.date }}

apt install gh

read -p "Authenticate Github now? (y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || return

gh auth login

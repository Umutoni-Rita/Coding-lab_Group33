#!/bin/bash 

timestamp=$(date +"%Y%m%d_%H%M")

echo "Starting log archival process..."

mkdir -p archived_logs active_logs

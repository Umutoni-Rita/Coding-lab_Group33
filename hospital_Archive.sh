#!/bin/bash 

timestamp=$(date +"%Y%m%d_%H%M")

echo "Starting log archival process..."

mkdir -p archived_logs active_logs

if [ -f "active_logs/heart_rate.log" ]; then
    mv active_logs/heart_rate.log archived_logs/heart_rate_${timestamp}.log
fi

if [ -f "active_logs/temperature.log" ]; then
    mv active_logs/temperature.log archived_logs/temperature_${timestamp}.log
fi

if [ -f "active_logs/water_usage.log" ]; then
    mv active_logs/water_usage.log archived_logs/water_usage_${timestamp}.log
fi

echo "Logs successfully moved to archived_logs."

#!/bin/bash

heart_log="active_logs/heart_rate_log.log"
temp_log="active_logs/temperature_log.log"
water_log="active_logs/water_usage_log.log"
alerts_file="reports/critical_alerts.txt"

process_vitals() {
    if [ ! -f "$heart_log" ] || [ ! -f "$temp_log" ]; then
        echo "Heart rate or temperature log is missing. Start the engine first."
        return 1
    fi

    mkdir -p reports

    echo "Scanning vitals for CRITICAL readings..."

    echo "KNH Critical Alerts - generated on $(date)" > "$alerts_file"
    echo "Timestamp | Device_ID | Value" >> "$alerts_file"

    grep -h "CRITICAL" "$heart_log" "$temp_log" | awk -F' [|] ' -v OFS=' | ' '{ print $1, $2, $3 }' >> "$alerts_file"

    chmod 600 "$alerts_file"

    heart_alerts=$(grep -c "_HR_" "$alerts_file")
    temp_alerts=$(grep -c "_TEMP_" "$alerts_file")

    echo "Heart rate alerts:  $heart_alerts"
    echo "Temperature alerts: $temp_alerts"
    echo "Report saved to $alerts_file"
    echo
}

water_audit() {
    if [ ! -f "$water_log" ]; then
        echo "Water usage log is missing. Start the engine first."
        return 1
    fi

    stats=$(awk -F' [|] ' '
        $2 == "ICU_WATER_RESERVE" {
            total += $3
            count++
        }
        END {
            if (count > 0)
                printf "%d %.2f", count, total / count
        }' "$water_log")

    if [ -z "$stats" ]; then
        echo "No readings for ICU_WATER_RESERVE yet."
        return 1
    fi

    read -r readings average <<< "$stats"

    echo "ICU_WATER_RESERVE average usage: $average L/min ($readings readings)"
}

process_vitals
water_audit

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
            if (count == 1 || $3 < lowest) lowest = $3
            if ($3 > highest) highest = $3
            if ($4 == "HIGH_USAGE") high_usage++
        }
        END {
            if (count > 0)
                printf "%d %.2f %d %d %d", count, total / count, lowest, highest, high_usage
        }' "$water_log")

    if [ -z "$stats" ]; then
        echo "No readings for ICU_WATER_RESERVE yet."
        return 1
    fi

    read -r readings average lowest highest high_usage <<< "$stats"

    printf "\n%s\n" "----------- ICU WATER RESERVE AUDIT -----------"
    printf "%-20s %s\n" "Audit time:" "$(date '+%Y-%m-%d %H:%M')"
    printf "%-20s %s\n" "Readings analysed:" "$readings"
    printf "%-20s %s L/min\n" "Average usage:" "$average"
    printf "%-20s %s L/min\n" "Lowest reading:" "$lowest"
    printf "%-20s %s L/min\n" "Highest reading:" "$highest"
    printf "%-20s %s\n" "High usage alerts:" "$high_usage"
    printf "%s\n\n" "-----------------------------------------------"
}

echo "=========================================="
echo "    KNH Live Data Analysis Dashboard"
echo "=========================================="

PS3="Choose an option (1-4): "

select option in "Critical vitals report" "ICU water audit" "Run full analysis" "Exit"; do
    case $REPLY in
        1) process_vitals ;;
        2) water_audit ;;
        3) process_vitals; water_audit ;;
        4) echo "Closing the dashboard. Goodbye!"; break ;;
        *) echo "Invalid choice. Please pick a number from 1 to 4." ;;
    esac
done

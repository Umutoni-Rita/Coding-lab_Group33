# Coding-lab_Group33

## Project Overview

This project implements a hospital sensor monitoring system for Kenyatta National Hospital (KNH) using Python and Bash scripting.

## Group Members

| Member | Assigned Role |
|---|---|
| Umutoni Rita | Member 1 — The Architect |
| Mico Pacifique | Member 2 — The Security Lead |
| Umuvandimwe Queen Carine | Member 3 — The Orchestrator |
| Ibereho Olga Maxime | Member 4 — The Archivist |
| Ishema Mudahinyuka Hugues | Members 5 & 6 — Clinical Analyst & Facility Auditor |

> **Note:** Our group consists of five members. Therefore, the responsibilities of Members 5 and 6 were combined and assigned to one group member.

## Project Files

- `hospital_system.py` — Generates simulated hospital sensor data.
- `hospital_admin.sh` — Creates the required directories and secures the active logs.
- `hospital_analysis.sh` — Analyzes live sensor data, reports critical readings, and calculates ICU water usage statistics.
- `hospital_archive.sh` — Moves completed logs to the archive and recreates fresh active log files.
- `.gitignore` — Prevents generated logs, reports, and other sensitive data from being uploaded to GitHub.
- `README.md` — Contains the project overview, group roles, and instructions.

## Running the Project

### 1. Initialize the Environment

Run the administration script:

```bash
./hospital_admin.sh
```

This creates the required directories and applies the required permissions.

### 2. Start the Hospital Data Engine

```bash
python3 hospital_system.py start
```

The engine begins generating live Heart Rate, Temperature, and Water Usage sensor data.

### 3. Analyze Live Data

```bash
./hospital_analysis.sh
```

The analysis script can:

- Find critical Heart Rate and Temperature readings.
- Save critical alerts to `reports/critical_alerts.txt`.
- Calculate the average water usage for `ICU_WATER_RESERVE`.

The analysis should be performed before archiving the current logs.

### 4. Archive the Logs

```bash
./hospital_archive.sh
```

This moves the current logs from `active_logs/` to `archived_logs/` and renames them using a timestamp.

### 5. Stop the Hospital Data Engine

```bash
python3 hospital_system.py stop
```
## Technologies Used

- Bash / Shell Scripting
- Python
- Linux
- Git
- GitHub

## Git Collaboration

Each group member works on their own Git branch and contributes commits related to their assigned role. Completed work is merged into the `main` branch after review and testing.
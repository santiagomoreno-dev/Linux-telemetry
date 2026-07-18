#!/bin/bash

# =====================================================================
# Nginx Log Analyser
# Description: A Bash script to parse, clean, and extract telemetry
#              metrics from standard Nginx access log files.
# =====================================================================

# ---------------------------------------------------------------------
# INITIAL CONFIGURATION & VALIDATIONS
# ---------------------------------------------------------------------

# Verify that a log file path was provided as the first argument
if [ -z "$1" ]; then
    echo "Error: No log file provided."
    echo "Usage: $0 <path_to_log_file>"
    exit 1
fi

LOG_FILE=$1

# Validate the existence of the specified target file
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Target file '$LOG_FILE' does not exist."
    exit 1
fi

# ---------------------------------------------------------------------
# REPORT GENERATION PIPELINES
# ---------------------------------------------------------------------

echo "=================================================="
echo "          NGINX LOG ANALYSIS REPORT               "
echo "=================================================="
echo ""

# Metric 1: Top 5 Remote IP Addresses
# Isolates the first space-separated column ($1) containing client IPs
echo "--- [1] TOP 5 REMOTE IP ADDRESSES ---"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5
echo ""

# Metric 2: Top 5 Requested URLs
# Isolates the seventh space-separated column ($7) corresponding to request paths
echo "--- [2] TOP 5 MOST REQUESTED ENDPOINTS (URLs) ---"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5
echo ""

# Metric 3: Top 5 HTTP Response Status Codes
# Isolates the ninth space-separated column ($9) indicating HTTP status codes
echo "--- [3] TOP 5 HTTP RESPONSE CODES ---"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5
echo ""

# Metric 4: Top 5 User Agents
# Modifies the field separator to double quotes (-F'"') to capture complex
# User Agent strings located within the sixth quoted block ($6)
echo "--- [4] TOP 5 USER AGENTS ---"
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 5
echo ""

echo "=================================================="
echo "             END OF GENERATED REPORT              "
echo "=================================================="

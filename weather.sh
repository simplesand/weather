#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P ) 

cd ${parent_path}

# Check if Python3 is installed
if command -v python3 &>/dev/null; then
    echo "Python3 is already installed."
else
    echo "Python3 is not installed. Installing Python3..."
    # Install Python3
    sudo apt-get update && sudo apt-get install python3 -y
    if [ $? -ne 0 ]; then
        echo "Failed to install Python3. Exiting."
        exit 1
    fi
fi

# Check if pip3 is installed (to install Python packages)
if command -v pip3 &>/dev/null; then
    echo "pip3 is already installed."
else
    echo "pip3 is not installed. Installing pip3..."
    sudo add-apt-repository universe -y && sudo apt-get update && sudo apt-get install python3-pip -y
    if [ $? -ne 0 ]; then
        echo "Failed to install pip3. Exiting."
        exit 1
    fi
fi

# Check if 'requests' module is installed
if ! python3 -c "import requests" &>/dev/null; then
    echo "Installing 'requests' module..."
    pip3 install requests
    if [ $? -ne 0 ]; then
        echo "Failed to install 'requests' module. Exiting."
        exit 1
    fi
else
    echo "'requests' module is already installed."
fi

# Run the Python script
if [ -f "${parent_path}/weather.py" ]; then
    python3 ${parent_path}/weather.py
else
    echo "Python script ${parent_path}/weather.py not found."
    exit 1
fi

#### CRON JOB SCHEDULING ######

# Prompt the user to input the interval (e.g., 1m for 1 minute, 2h for 2 hours, etc.)
read -p "Enter time interval (e.g., 1m, 2h, 1d, 1mo, 1w): " interval

interval="${interval,,}"

# Initialize cron schedule variable
cron_schedule=""

# Extract the last two characters to check for "mo" (months)
if [[ "${interval: -2}" == "mo" ]]; then
    months="${interval%??}"  # Extract the number before 'mo'
    if [[ "$months" -gt 11 ]]; then
        echo "Invalid input: The maximum allowed number of months is 11."
        echo "Error: Could not install the cron job due to an invalid input."
        exit 1
    fi
    cron_schedule="0 0 1 */$months *"  # Every N months on the first day
    status=$?

else
    # Handle single-character time units (m, h, d, w)
    case "${interval: -1}" in
        m)  # Minutes
            minutes="${interval%?}"  # Extract the number before 'm'
            if [[ "$minutes" -eq 1 ]]; then
                cron_schedule="* * * * *"  # Every minute
            else
               if [[ "$minutes" -gt 59 ]]; then
                echo "Invalid input: The maximum allowed number of minutes is 59."
                echo "Error: Could not install the cron job due to an invalid input."
                exit 1
               fi
                cron_schedule="*/$minutes * * * *"  # Every N minutes
            fi
            status=$?
            ;;
        h)  # Hours
            hours="${interval%?}"  # Extract the number before 'h'
            if [[ "$hours" -gt 23 ]]; then
                echo "Invalid input: The maximum allowed number of hours is 23."
                echo "Error: Could not install the cron job due to an invalid input."
                exit 1
            fi
            cron_schedule="0 */$hours * * *"  # Every N hours
            status=$?
            ;;
        d)  # Days
            days="${interval%?}"  # Extract the number before 'd'
            if [[ "$days" -gt 30 ]]; then
                echo "Invalid input: The maximum allowed number of days is 30."
                echo "Error: Could not install the cron job due to an invalid input."
                exit 1
            fi
            cron_schedule="0 0 */$days * *"  # Every N days at midnight
            status=$?
            ;;
        w)  # Weeks (Day of the week: 0=Sunday, 1=Monday, ..., 6=Saturday)
            weeks="${interval%?}"  # Extract the number before 'w'
            if [[ "$weeks" -gt 6 ]]; then
                echo "Invalid input: The maximum allowed number of days of week is 6."
                echo "Error: Could not install the cron job due to an invalid input."
                exit 1
            fi
            cron_schedule="0 0 * * $weeks"  # Run on the N-th day of the week
            status=$?
            ;;
        *)
            echo "Invalid input. Please use 'm' for minutes, 'h' for hours, 'd' for days, 'mo' for months, or 'w' for day of the week (0-6)."
            exit 1
            ;;
    esac
fi


# Output the cron schedule
echo "Cron syntax for the given interval: $cron_schedule"

# Construct the command to run the script 
command="bash ${parent_path}/weather.sh"

# Check if the case block executed successfully (status is 0)
if [[ "$status" -eq 0 ]]; then 
    # Install the cron job
    (crontab -l 2>/dev/null; echo "$cron_schedule $command >> ${parent_path}/logfile.log 2>&1") | crontab -
     echo "Cron job installed: $cron_schedule  $command >> ${parent_path}/logfile.log 2>&1"
fi


#!/bin/bash

repo_url="https://github.com/simplesand/weather/archive/refs/heads/main.zip"


echo "Downloading repository from GitHub..."
curl -L ${repo_url} -o weather.zip

# Check if the download was successful
if [ -f "weather.zip" ]; then
    echo "Repository downloaded successfully."
else
    echo "Failed to download the repository."
    exit 1
fi


if command -v unzip &>/dev/null; then
    echo "unzip is already installed."
else
    echo "unzip is not installed. Installing unzip..."
    sudo apt-get update && sudo apt-get install unzip -y
    if [ $? -ne 0 ]; then
        echo "Failed to install unzip. Exiting."
        exit 1
    fi
fi
# Unzip the downloaded file
echo "Extracting repository..."
unzip weather.zip 

sleep 2

cp weather-main/* .

chmod +x weather.sh
echo "Running script..."
./weather.sh

rm -rf weather.zip weather-main/
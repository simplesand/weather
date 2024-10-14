# weather fetching script
This is a shell script sets required executing python environment and runs python script which calls OpenWeatherAPI and get weather status in the form of json format and also sets cron scheduling based on minutes,hours,days,months or daysofweek.


# Usage
Download as zip, etract the folder, cd into it and give execute permission to weather.sh <br />
bash weather.sh <br />
Note: Enter nm to run every 'n' minutes <br />
&nbsp; &ensp; &emsp; nh to run every 'n' hours <br />
&nbsp; &ensp; &emsp; nmo to run every 'n' months <br />
&nbsp; &ensp; &emsp; nd to run every 'n' days <br />

# Curl.sh
Download curl.sh and give execute permission to run <br />
bash curl.sh

# Note
Before running this script, replace API_KEY with token in weather.py file  <br />
Don't use both methods at the same time. use either download as zip file or curl.

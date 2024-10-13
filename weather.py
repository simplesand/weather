import requests
import json
import os

def fetch_weather():
    
    API_KEY = 'e4bec17448c11464802f816c9946f016'
    CITY = 'London'
    URL = f'http://api.openweathermap.org/data/2.5/weather?q={CITY}&appid={API_KEY}'
    
    try:
        # Send a GET request to the API
        response = requests.get(URL)
        response.raise_for_status()  # Raise an error for bad responses

        # Get JSON data from the response
        data = response.json()

        # Define the output file path
        output_file = os.path.join(os.getcwd(), 'data.json')

        # Save the JSON data to a file in pretty format
        with open(output_file, 'a') as json_file:
            json.dump(data, json_file, indent=4)

        print(f"Weather data saved as '{output_file}'.")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from API: {e}")
		

if __name__ == "__main__":
    fetch_weather()


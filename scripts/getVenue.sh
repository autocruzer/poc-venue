#!/bin/bash

# Define the API endpoint (replace with your actual endpoint)
API_ENDPOINT="https://activesg.gov.sg/api/trpc/venue.listByActivity?input=%7B%22json%22%3A%7B%22activityId%22%3A%22YLONatwvqJfikKOmB5N9U%22%2C%22postalCode%22%3Anull%7D%2C%22meta%22%3A%7B%22values%22%3A%7B%22postalCode%22%3A%5B%5D%7D%7D%7D"

# Set the User-Agent header
USER_AGENT='Chrome/126.0.0.0'
mkdir -p data
# Make the HTTP GET request and capture the response and status code
response=$(curl -s --tlsv1 --tls-max 1.2 -w "http_code=%{http_code}" -A "$USER_AGENT" "$API_ENDPOINT")
status_code=$(echo "$response" | awk -F "http_code=" '{print $2}')
json_response=$(echo "$response" | awk -F "http_code=" '{print $1}')

if [[ -f $GITHUB_OUTPUT ]]; then
  echo "[INFO] GITHUB_OUTPUT exists"
else
  echo "[INFO] GITHUB_OUTPUT does not exist"
  GITHUB_OUTPUT=file.tmp
fi
# Handle the status code
if [ "$status_code" -eq 200 ]; then
  echo "Venue List JSON Response:"
  echo "$json_response" | jq | tee data/venues.json
  echo "venue-retrieved=true" >> $GITHUB_OUTPUT

else
  echo "[ERROR] Received HTTP status code $status_code"
   echo "venue-retrieved=false" >> $GITHUB_OUTPUT 
  echo "$json_response"
fi

#curl --tlsv1 --tls-max 1.2  -A "537.36" "https://activesg.gov.sg/api/trpc/venue.listByActivity?input=%7B%22json%22%3A%7B%22activityId%22%3A%22YLONatwvqJfikKOmB5N9U%22%2C%22postalCode%22%3Anull%7D%2C%22meta%22%3A%7B%22values%22%3A%7B%22postalCode%22%3A%5B%5D%7D%7D%7D"

#curl --tlsv1 --tls-max 1.2 -A "${USER_AGENT}" "$API_ENDPOINT"
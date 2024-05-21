#!/bin/bash

# Keycloak server base URL
KEYCLOAK_URL="http://localhost:8080"

# Keycloak realm
REALM="DEMO"

# Client ID
CLIENT_ID="demo"

# Client Secret
CLIENT_SECRET="8k6IZcpIszc4He4Sm8rDGGsNccKGFUlr"

# Username and password
USERNAME="user1"
PASSWORD="password"

# Function to get an access token from Keycloak
function get_access_token() {
    # POST request to get the access token
    local RESPONSE=$(curl -s -X POST "${KEYCLOAK_URL}/realms/${REALM}/protocol/openid-connect/token" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "username=${USERNAME}" \
        -d "password=${PASSWORD}" \
        -d "grant_type=password" \
        -d "client_id=${CLIENT_ID}" \
        -d "client_secret=${CLIENT_SECRET}")

    # Extract the access token from the response
    ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.access_token')

    if [ "$ACCESS_TOKEN" == "null" ]; then
        echo "Error: Unable to obtain access token from Keycloak."
        exit 1
    fi

    echo $ACCESS_TOKEN
}

# Get the access token
TOKEN=$(get_access_token)
# echo "Access Token: $TOKEN"
# echo "Bearer Token:"
echo "Bearer $TOKEN"
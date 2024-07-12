import globus_sdk
import requests
import json

# Globus ID and Scope
# ===================

# Define your Globus thick-client ID
# https://app.globus.org/settings/developers
# This needs to be created by users (they can also re-use one of the existing clients)
auth_client_id = "58fdd3bc-e1c3-4ce5-80ea-8d6b87cfb944"

# Define the inference-gateway resource service scope
# This will be publicly available to users
gateway_client_id = "681c10cc-f684-4540-bcd7-0b4df3bc26ef"
gateway_scope = f"https://auth.globus.org/scopes/{gateway_client_id}/action_all"

# Authentication and Access Token
# ===============================

# Start an Auth client with the vLLM scope
auth_client = globus_sdk.NativeAppAuthClient(auth_client_id)
auth_client.oauth2_start_flow(requested_scopes=gateway_scope)

# Authenticate with your Globus account
authorize_url = auth_client.oauth2_get_authorize_url()
print(f"Please go to this URL and login:\n\n{authorize_url}\n")

# Get the code from the command line
auth_code = input("Enter the code you just received: ")

# Exchange the code for an access token
# Collect access token to vLLM service
token_response = auth_client.oauth2_exchange_code_for_tokens(auth_code)
access_token = token_response.by_resource_server[gateway_client_id]["access_token"]
print(f"Access token: {access_token}")
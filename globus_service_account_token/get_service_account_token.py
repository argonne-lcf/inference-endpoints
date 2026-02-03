import os
import globus_sdk
from dotenv import load_dotenv
load_dotenv()

# ----------------------------------------------------------------------------
# The following is to generate an access token that will be valid for 48 hours
# ----------------------------------------------------------------------------

# Load your Globus service account client credentials
CLIENT_ID = os.getenv("GLOBUS_SERVICE_ACCOUNT_CLIENT_ID", None)
CLIENT_SECRET = os.getenv("GLOBUS_SERVICE_ACCOUNT_CLIENT_SECRET", None)

# Define the Globus Inference scope
INFERENCE_SCOPE_CLIENT_ID = "681c10cc-f684-4540-bcd7-0b4df3bc26ef"
INFERENCE_SCOPE = "https://auth.globus.org/scopes/681c10cc-f684-4540-bcd7-0b4df3bc26ef/action_all"

# Create an SDK client using the service account credentials
print("\nCreating Globus SDK client using credentials ...")
client = globus_sdk.ConfidentialAppAuthClient(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)

# Request an access token for your targeted scope
print("Generating access token for the ALCF inference scope ...")
token_response = client.oauth2_client_credentials_tokens(requested_scopes=[INFERENCE_SCOPE])

# Extract and print the access token
access_token = token_response.by_resource_server[INFERENCE_SCOPE_CLIENT_ID]["access_token"]

# ----------------------------------------------------------------------------
# The following is an optional introspection check to 
# ----------------------------------------------------------------------------

# Introspect token with Globus Auth
introspection = client.post(
    "/v2/oauth2/token/introspect",
    data={"token": access_token}, 
    encoding="form",
)

# Display introspection on the terminal
print("\nToken introspection data")
print("------------------------")
print(introspection)

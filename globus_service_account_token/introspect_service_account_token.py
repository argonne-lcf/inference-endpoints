import os
import globus_sdk
from dotenv import load_dotenv
load_dotenv()

# Load your Globus service account client credentials
CLIENT_ID = os.getenv("GLOBUS_SERVICE_ACCOUNT_CLIENT_ID", None)
CLIENT_SECRET = os.getenv("GLOBUS_SERVICE_ACCOUNT_CLIENT_SECRET", None)

# Load the service account access token
ACCESS_TOKEN = os.getenv("ACCESS_TOKEN", None)

# Create an SDK client using the service account credentials
client = globus_sdk.ConfidentialAppAuthClient(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)

# Introspect the access token and print result
introspection = client.post("/v2/oauth2/token/introspect", data={"token": ACCESS_TOKEN}, encoding="form")
print(introspection)
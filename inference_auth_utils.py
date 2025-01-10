import globus_sdk

# Globus UserApp name
APP_NAME = "inference_app"

# Public inference auth client
AUTH_CLIENT_ID = "58fdd3bc-e1c3-4ce5-80ea-8d6b87cfb944"

# Inference gateway API scope
GATEWAY_CLIENT_ID = "681c10cc-f684-4540-bcd7-0b4df3bc26ef"
GATEWAY_SCOPE = f"https://auth.globus.org/scopes/{GATEWAY_CLIENT_ID}/action_all"

# Path where access and refresh tokens are stored
TOKENS_PATH = f"~/.globus/app/{AUTH_CLIENT_ID}/{APP_NAME}/tokens.json"

# Get refresh authorizer
def get_refresh_authorizer():
    """
    Create a Globus UserApp with the inference service scope
    and trigger the authentication process. If authentication
    has already happened, existing tokens will be reused.
    """

    # Create Globus user application
    app = globus_sdk.UserApp(
        APP_NAME,
        client_id=AUTH_CLIENT_ID,
        scope_requirements={GATEWAY_CLIENT_ID: [GATEWAY_SCOPE]},
        config=globus_sdk.GlobusAppConfig(request_refresh_tokens=True),
    )

    # Authenticate using your Globus account
    auth = app.get_authorizer(GATEWAY_CLIENT_ID)

    # Return the Globus refresh token authorizer
    return auth

# Authenticate with native app
def authenticate_with_native_app():
    """
    Create a Globus NativeApp client, start a login flow, and
    extract and return the access token.
    """

    # Create a Globus native app
    auth_client = globus_sdk.NativeAppAuthClient(AUTH_CLIENT_ID)
    
    # Authenticate using your Globus account
    auth_client.oauth2_start_flow(requested_scopes=GATEWAY_SCOPE)
    authorize_url = auth_client.oauth2_get_authorize_url()
    print(f"Please go to this URL and login:\n\n{authorize_url}\n")
    auth_code = input("Enter the code you just received: ")

    # Collect access token
    token_response = auth_client.oauth2_exchange_code_for_tokens(auth_code)
    access_token = token_response.by_resource_server[GATEWAY_CLIENT_ID]["access_token"]

    # Return the access token
    return access_token
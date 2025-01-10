from sys import argv, exit
import globus_sdk


# Define whether the user needs a refresh token
# =============================================
refresh = False
if len(argv) > 2:
    print("Error: Only one argument can be passed.")
    exit()
elif len(argv) == 2:
    if argv[1] == "refresh":
        refresh = True
    else:
        print("Error: Only the 'refresh' flag can be passed as an argument.")
        exit()


# Inference service UUIDs and scope
# =================================

# Public inference auth client
auth_client_id = "58fdd3bc-e1c3-4ce5-80ea-8d6b87cfb944"

# Inference gateway API scope
gateway_client_id = "681c10cc-f684-4540-bcd7-0b4df3bc26ef"
gateway_scope = f"https://auth.globus.org/scopes/{gateway_client_id}/action_all"


# Generate new access and refresh tokens or reuse existing ones
# =============================================================
if refresh:

    # Create Globus user application
    app_name = "inference_app"
    app = globus_sdk.UserApp(
        app_name,
        client_id=auth_client_id,
        scope_requirements={gateway_client_id: [gateway_scope]},
        config=globus_sdk.GlobusAppConfig(request_refresh_tokens=True),
    )

    # Authenticate using your Globus account
    # Tokens will be stored locally in ~/.globus/app/58fdd3bc-e1c3-4ce5-80ea-8d6b87cfb944/<app_name>/tokens.json
    auth = app.get_authorizer(gateway_client_id)

    # Refresh current access token if expired
    auth.ensure_valid_token()

    # Token storage message
    path = f"~/.globus/app/58fdd3bc-e1c3-4ce5-80ea-8d6b87cfb944/{app_name}/tokens.json"
    print(f"The access and refresh tokens are stored in {path}")


# Generate new access token from scratch
# ======================================
else:

    # Create Globus auth client
    auth_client = globus_sdk.NativeAppAuthClient(auth_client_id)
    
    # Authenticate using your Globus account
    auth_client.oauth2_start_flow(requested_scopes=gateway_scope)
    authorize_url = auth_client.oauth2_get_authorize_url()
    print(f"Please go to this URL and login:\n\n{authorize_url}\n")
    auth_code = input("Enter the code you just received: ")

    # Collect access token
    token_response = auth_client.oauth2_exchange_code_for_tokens(auth_code)
    access_token = token_response.by_resource_server[gateway_client_id]["access_token"]

    # Store access token in a file
    file_name = "access_token.txt"
    with open(file_name, "w") as f:
        f.write(access_token)

    # Token storage message
    print(f"The access token is stored in {file_name}")
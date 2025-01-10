from sys import argv, exit
import inference_auth_utils as utils

# Path and file name of where the current access token is stored
FILE_NAME = "access_token.txt"

# Define whether the user needs a refresh token
# =============================================
REFRESH = False
if len(argv) > 2:
    print("Error: Only one argument can be passed.")
    exit()
elif len(argv) == 2:
    if argv[1] == "refresh":
        REFRESH = True
    else:
        print("Error: Only the 'refresh' flag can be passed as an argument.")
        exit()

# Generate new access and refresh tokens or reuse existing ones
# =============================================================
if REFRESH:

    # Authenticate using a Globus UserApp and create a refresh token authorizer
    # This will reuse existing tokens if available
    auth = utils.get_refresh_authorizer()

    # Refresh current access token if expired
    auth.ensure_valid_token()

    # Store access token in a file
    with open(FILE_NAME, "w") as f:
        f.write(auth.access_token)

    # Token storage message
    print(f"The current access token is stored in {FILE_NAME}")
    print(f"All tokens including the refresh token are stored in {utils.TOKENS_PATH}")


# Generate new access token from scratch
# ======================================
else:

    # Authenticate using a Globus native app client
    access_token = utils.authenticate_with_native_app()

    # Store access token in a file
    with open(FILE_NAME, "w") as f:
        f.write(access_token)

    # Token storage message
    print(f"The access token is stored in {FILE_NAME}")
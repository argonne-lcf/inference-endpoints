#!/usr/bin/env bash
set -euo pipefail

APP_NAME="inference_app"
AUTH_CLIENT_ID="58fdd3bc-e1c3-4ce5-80ea-8d6b87cfb944"
GATEWAY_CLIENT_ID="681c10cc-f684-4540-bcd7-0b4df3bc26ef"
GATEWAY_SCOPE="https://auth.globus.org/scopes/${GATEWAY_CLIENT_ID}/action_all"
SESSION_REQUIRED_POLICY="83732ff2-9c42-4548-b5ce-17e498c84f6a"

AUTH_BASE_URL="https://auth.globus.org"
AUTHORIZE_URL="${AUTH_BASE_URL}/v2/oauth2/authorize"
TOKEN_URL="${AUTH_BASE_URL}/v2/oauth2/token"
REVOKE_URL="${AUTH_BASE_URL}/v2/oauth2/token/revoke"
REDIRECT_URI="${AUTH_BASE_URL}/v2/web/auth-code"

TOKEN_DIR="${INFERENCE_AUTH_TOKEN_DIR:-${HOME}/.globus/app/${AUTH_CLIENT_ID}/${APP_NAME}}"
TOKEN_FILE="${INFERENCE_AUTH_TOKEN_FILE:-${TOKEN_DIR}/tokens-bash.json}"
EXPIRATION_SKEW_SECONDS=60

usage() {
    cat <<EOF
Usage: $(basename "$0") <action> [--units seconds|minutes|hours]

Actions:
  authenticate                         Authenticate and cache tokens
  get_access_token                     Print a valid bearer access token
  get_time_until_token_expiration      Print time until token expiration
  revoke_access_token                  Revoke cached tokens and remove cache

Environment:
  INFERENCE_AUTH_TOKEN_FILE            Override token cache path
  INFERENCE_AUTH_TOKEN_DIR             Override token cache directory
  BROWSER                              Browser opener command
EOF
}

die() {
    echo "Error: $*" >&2
    exit 1
}

require_commands() {
    local missing=()
    local cmd
    for cmd in awk curl jq openssl; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done
    if ((${#missing[@]})); then
        die "missing required command(s): ${missing[*]}"
    fi
}

urlencode() {
    jq -rn --arg value "$1" '$value | @uri'
}

form_body() {
    local body=""
    local key value
    while (($#)); do
        key="$1"
        value="$2"
        shift 2
        if [[ -n "$body" ]]; then
            body+="&"
        fi
        body+="$(urlencode "$key")=$(urlencode "$value")"
    done
    printf '%s' "$body"
}

random_urlsafe() {
    openssl rand -base64 32 | tr '+/' '-_' | tr -d '='
}

pkce_challenge() {
    printf '%s' "$1" |
        openssl dgst -sha256 -binary |
        openssl base64 -A |
        tr '+/' '-_' |
        tr -d '='
}

open_browser() {
    local url="$1"

    if [[ -n "${BROWSER:-}" ]] && command -v "$BROWSER" >/dev/null 2>&1; then
        "$BROWSER" "$url" >/dev/null 2>&1 &
        return 0
    fi

    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url" >/dev/null 2>&1 &
        return 0
    fi

    if command -v open >/dev/null 2>&1; then
        open "$url" >/dev/null 2>&1 &
        return 0
    fi

    return 1
}

http_post_form() {
    local url="$1"
    local body="$2"
    local tmp status

    tmp="$(mktemp)"
    status="$(
        printf '%s' "$body" |
            curl -sS -o "$tmp" -w '%{http_code}' \
                -H 'Content-Type: application/x-www-form-urlencoded' \
                --data-binary @- \
                "$url"
    )" || {
        rm -f "$tmp"
        die "request failed"
    }

    if [[ "$status" -lt 200 || "$status" -ge 300 ]]; then
        cat "$tmp" >&2
        rm -f "$tmp"
        die "request failed with HTTP ${status}"
    fi

    cat "$tmp"
    rm -f "$tmp"
}

select_gateway_token() {
    jq -c --arg resource_server "$GATEWAY_CLIENT_ID" --arg scope "$GATEWAY_SCOPE" '
        ([.] + (.other_tokens // []))
        | map(select(
            (.resource_server // "") == $resource_server
            or (((.scope // "") | split(" ")) | index($scope))
        ))
        | .[0] // empty
    '
}

save_token() {
    local token_json="$1"
    local fallback_refresh_token="${2:-}"
    local access_token refresh_token expires_in expires_at tmp

    access_token="$(jq -r '.access_token // empty' <<<"$token_json")"
    refresh_token="$(jq -r '.refresh_token // empty' <<<"$token_json")"
    expires_in="$(jq -r '.expires_in // empty' <<<"$token_json")"

    [[ -n "$access_token" ]] || die "token response did not include an access token"
    [[ -n "$expires_in" ]] || die "token response did not include an expiration"

    if [[ -z "$refresh_token" ]]; then
        refresh_token="$fallback_refresh_token"
    fi
    [[ -n "$refresh_token" ]] || die "token response did not include a refresh token"

    expires_at=$(($(date +%s) + expires_in))

    umask 077
    mkdir -p "$TOKEN_DIR"
    tmp="$(mktemp "${TOKEN_FILE}.tmp.XXXXXX")"
    jq -n \
        --arg app_name "$APP_NAME" \
        --arg client_id "$AUTH_CLIENT_ID" \
        --arg resource_server "$GATEWAY_CLIENT_ID" \
        --arg scope "$GATEWAY_SCOPE" \
        --arg access_token "$access_token" \
        --arg refresh_token "$refresh_token" \
        --argjson expires_at "$expires_at" \
        '{
            app_name: $app_name,
            client_id: $client_id,
            resource_server: $resource_server,
            scope: $scope,
            access_token: $access_token,
            refresh_token: $refresh_token,
            expires_at: $expires_at
        }' >"$tmp"
    mv "$tmp" "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
}

require_token_file() {
    [[ -f "$TOKEN_FILE" ]] || die "access token does not exist. Run: $(basename "$0") authenticate"
}

authenticate() {
    local verifier challenge authorize_url auth_code response token

    verifier="$(random_urlsafe)"
    challenge="$(pkce_challenge "$verifier")"
    authorize_url="${AUTHORIZE_URL}?client_id=$(urlencode "$AUTH_CLIENT_ID")"
    authorize_url+="&redirect_uri=$(urlencode "$REDIRECT_URI")"
    authorize_url+="&scope=$(urlencode "$GATEWAY_SCOPE")"
    authorize_url+="&state=_default"
    authorize_url+="&response_type=code"
    authorize_url+="&code_challenge=$(urlencode "$challenge")"
    authorize_url+="&code_challenge_method=S256"
    authorize_url+="&access_type=offline"
    authorize_url+="&session_required_policies=$(urlencode "$SESSION_REQUIRED_POLICY")"

    echo "Open this URL and log in:"
    echo
    echo "$authorize_url"
    echo
    open_browser "$authorize_url" || true

    read -r -p "Paste the Globus authorization code: " auth_code
    [[ -n "$auth_code" ]] || die "authorization code is required"

    response="$(
        http_post_form "$TOKEN_URL" "$(
            form_body \
                grant_type authorization_code \
                client_id "$AUTH_CLIENT_ID" \
                code "$auth_code" \
                code_verifier "$verifier" \
                redirect_uri "$REDIRECT_URI"
        )"
    )"
    token="$(select_gateway_token <<<"$response")"
    [[ -n "$token" ]] || die "token response did not include the inference gateway token"

    save_token "$token"
    echo "Authenticated. Token cache: ${TOKEN_FILE}"
}

refresh_access_token() {
    local refresh_token response token

    require_token_file
    refresh_token="$(jq -r '.refresh_token // empty' "$TOKEN_FILE")"
    [[ -n "$refresh_token" ]] || die "cached refresh token is missing. Run: $(basename "$0") authenticate"

    response="$(
        http_post_form "$TOKEN_URL" "$(
            form_body \
                grant_type refresh_token \
                client_id "$AUTH_CLIENT_ID" \
                refresh_token "$refresh_token"
        )"
    )" || die "refresh failed. Run: $(basename "$0") authenticate"

    token="$(select_gateway_token <<<"$response")"
    if [[ -z "$token" ]]; then
        token="$response"
    fi

    save_token "$token" "$refresh_token"
}

get_access_token() {
    local expires_at now

    require_token_file
    expires_at="$(jq -r '.expires_at // 0' "$TOKEN_FILE")"
    now="$(date +%s)"

    if ((now + EXPIRATION_SKEW_SECONDS >= expires_at)); then
        refresh_access_token
    fi

    jq -r '.access_token' "$TOKEN_FILE"
}

get_time_until_token_expiration() {
    local units="$1"
    local expires_at now seconds

    require_token_file
    expires_at="$(jq -r '.expires_at // 0' "$TOKEN_FILE")"
    now="$(date +%s)"
    seconds=$((expires_at - now))

    case "$units" in
        seconds)
            printf '%s\n' "$seconds"
            ;;
        minutes)
            awk -v seconds="$seconds" 'BEGIN { printf "%.2f\n", seconds / 60 }'
            ;;
        hours)
            awk -v seconds="$seconds" 'BEGIN { printf "%.2f\n", seconds / 3600 }'
            ;;
        *)
            die "units must be 'seconds', 'minutes', or 'hours'"
            ;;
    esac
}

revoke_token_value() {
    local token="$1"
    [[ -n "$token" ]] || return 0

    http_post_form "$REVOKE_URL" "$(
        form_body \
            token "$token" \
            client_id "$AUTH_CLIENT_ID"
    )" >/dev/null
}

revoke_access_token() {
    local access_token refresh_token

    require_token_file
    access_token="$(jq -r '.access_token // empty' "$TOKEN_FILE")"
    refresh_token="$(jq -r '.refresh_token // empty' "$TOKEN_FILE")"

    revoke_token_value "$access_token"
    revoke_token_value "$refresh_token"
    rm -f "$TOKEN_FILE"

    echo "Done. The Inference Gateway API can take up to ~10 minutes to incorporate the revocation."
}

main() {
    local action="${1:-}"
    local units="seconds"

    if [[ -z "$action" || "$action" == "-h" || "$action" == "--help" ]]; then
        usage
        exit 0
    fi
    shift || true

    while (($#)); do
        case "$1" in
            --units)
                [[ $# -ge 2 ]] || die "--units requires a value"
                units="$2"
                shift 2
                ;;
            -f|--force)
                # authenticate always starts a new OAuth flow, so this is accepted for
                # command-line compatibility with inference_auth_token.py.
                shift
                ;;
            *)
                die "unknown argument: $1"
                ;;
        esac
    done

    require_commands

    case "$action" in
        authenticate)
            authenticate
            ;;
        get_access_token)
            get_access_token
            ;;
        get_time_until_token_expiration)
            get_time_until_token_expiration "$units"
            ;;
        revoke_access_token)
            revoke_access_token
            ;;
        *)
            usage >&2
            exit 2
            ;;
    esac
}

main "$@"

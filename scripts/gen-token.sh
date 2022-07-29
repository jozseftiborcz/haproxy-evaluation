#/bin/bash

function base64url_encode {
  (if [ -z "$1" ]; then cat -; else echo -n "$1"; fi) \
    | openssl base64 -e -A \
    | sed s/\\+/-/g \
    | sed s/\\//_/g \
    | sed -E s/=+$//
}

function script_dir {
    SCRIPT_PATH="${BASH_SOURCE}"
    while [ -L "${SCRIPT_PATH}" ]; do
      SCRIPT_DIR="$(cd -P "$(dirname "${SCRIPT_PATH}")" >/dev/null 2>&1 && pwd)"
      SCRIPT_PATH="$(readlink "${SCRIPT_PATH}")"
      [[ ${SCRIPT_PATH} != /* ]] && SCRIPT_PATH="${SCRIPT_DIR}/${SCRIPT_PATH}"
    done
    SCRIPT_PATH="$(readlink -f "${SCRIPT_PATH}")"
    SCRIPT_DIR="$(cd -P "$(dirname -- "${SCRIPT_PATH}")" >/dev/null 2>&1 && pwd)"
}

script_dir

DATE=$(date -d "5 mins" +"%s")
ISS="https://auth.example.com"
AUD="https://mobile-client.example.com"

case $1 in
    "expired")
        DATE=$(date -d "-5 mins" +"%s")
        ;;
    "wrongaud")
        AUD="wrong"
        ;;
    "wrongaiss")
        ISS="wrong"
        ;;
    "valid")
        ;;
    *)
        echo "usage: $@ (valid|expired|wrongaud|wrongiss)"
        exit 1
        ;;
esac

UUID=$(uuidgen)
OUTFILE=$2

HEADER=$(base64url_encode '{"alg": "RS256", "typ": "JWT"}' )
BODY=$(echo -n "{\"exp\": \"$DATE\", \"iss\": \"$ISS\", \"aud\": \"$AUD\", \"sub\":\"$UUID\"}" | base64url_encode)
SIGN=$(echo -n "$HEADER.$BODY" |  openssl dgst -sha256 -binary -sigopt rsa_padding_mode:pkcs1 -sign $SCRIPT_DIR/../samples/privkey.pem | base64url_encode)

echo "$HEADER.$BODY.$SIGN"


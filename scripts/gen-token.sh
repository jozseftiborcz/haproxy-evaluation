#/bin/bash

function base64url_encode {
  (if [ -z "$1" ]; then cat -; else echo -n "$1"; fi) \
    | openssl base64 -e -A \
    | sed s/\\+/-/g \
    | sed s/\\//_/g \
    | sed -E s/=+$//
}

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
		echo "usage: $@ (valid|wrongaud|wrongiss)"
		exit 1
		;;
esac

UUID=$(uuidgen)
OUTFILE=$2

HEADER=$(base64url_encode '{"alg": "RS256", "typ": "JWT"}' )
BODY=$(echo -n "{\"exp\": \"$DATE\", \"iss\": \"$ISS\", \"aud\": \"$AUD\", \"sub\":\"$UUID\"}" | base64url_encode)
SIGN=$(echo -n "$HEADER.$BODY" |  openssl dgst -sha256 -binary -sigopt rsa_padding_mode:pkcs1 -sign samples/privkey.pem | base64url_encode)

echo "$HEADER.$BODY.$SIGN"

# Decode a JWT's header and payload to JSON (no signature check).
jwt-decode() {
  jq -R 'split(".") | .[0:2] | map(@base64d) | map(fromjson)' <<< "$1"
}

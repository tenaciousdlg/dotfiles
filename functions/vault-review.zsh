# Quick read-only review of the local demo/tooling Vault: container status,
# seal state, mounted secrets engines, and every key under secret/ recursed
# to full depth. Prints paths and key names only, never secret values.
vault-review() {
  echo "── container ──"
  docker ps --filter name=vault --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
  echo

  echo "── seal status ──"
  vault status
  echo

  echo "── secrets engines ──"
  vault secrets list
  echo

  echo "── secret/ paths ──"
  _vault_review_walk secret/
}

_vault_review_walk() {
  local kv_path="$1"
  vault kv list -format=json "$kv_path" 2>/dev/null | jq -r '.[]' | while read -r key; do
    if [[ "$key" == */ ]]; then
      _vault_review_walk "${kv_path}${key}"
    else
      echo "${kv_path}${key}"
    fi
  done
}

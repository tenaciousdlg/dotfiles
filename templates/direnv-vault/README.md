# direnv + Vault pattern for Terraform demo repos

Replaces the copy-pasted `export TF_VAR_...` blocks (secrets included) that
otherwise end up sitting in plaintext shell history.

Uses the local Vault container originally set up for the Terraform/Teleport
DB cert use case (`~/Documents/teleport/demos/docker_vault`) — the `mongo`/
`mysql` cert paths it already holds are untouched; new secrets live under
their own `secret/demo/*` namespace.

## Before each use: make sure Vault is unsealed

The container has `restart: always`, but Shamir-sealed Vault comes back
**sealed** after every container/host restart and needs 3 of its 6 unseal
keys before anything can read from it:

```bash
vault status   # Sealed: true means you need to unseal first
for key in <key1> <key2> <key3>; do vault operator unseal "$key"; done
```

(The 3 keys used to originally unseal it are currently only recorded in
`.zsh_history` — worth moving somewhere durable before that history rotates
or gets cleaned up.)

## One-time secret setup

```bash
vault kv put secret/demo/okta-integrator api_token=... metadata_url=...
vault kv put secret/demo/teleport-scim client_id=... client_secret=...
vault kv put secret/demo/slack-bot token=... channel_id=...
```

## Per-project setup

```bash
cd path/to/terraform/project
cp ~/github/dotfiles/templates/direnv-vault/envrc.example .envrc
# edit .envrc: swap in the right proxy/cluster values
direnv allow
```

`.envrc` is already excluded globally (see `gitignore_global`), so it never
risks getting committed even if a project's own `.gitignore` doesn't cover
it.

From then on, `cd` into the project loads every `TF_VAR_*` (plain and
secret) automatically from Vault; `cd` out unloads them. No more re-exporting
the same block by hand, and no secret ever touches `.zsh_history` again.

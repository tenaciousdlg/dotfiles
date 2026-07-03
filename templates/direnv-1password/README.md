# direnv + 1Password pattern for Terraform demo repos

Replaces the copy-pasted `export TF_VAR_...` blocks (secrets included) that
otherwise end up sitting in plaintext shell history.

## One-time setup

1. In 1Password, create a vault (e.g. "Demo Environments") and add the
   Okta/SCIM/Slack values as items — one item per credential, not one giant
   note. `op read 'op://<vault>/<item>/<field>'` pulls a single field.
2. `direnv` and `op` are both installed via the dotfiles bootstrap
   (`brew install direnv`; 1Password CLI ships with the 1Password app).

## Per-project setup

```bash
cd path/to/terraform/project
cp ~/github/dotfiles/templates/direnv-1password/envrc.example .envrc
# edit .envrc: swap in the right proxy/cluster values and op:// paths
direnv allow
```

`.envrc` is already excluded globally (see `gitignore_global`), so it never
risks getting committed even if a project's own `.gitignore` doesn't cover it.

From then on, `cd` into the project loads every `TF_VAR_*` (plain and
secret) automatically; `cd` out unloads them. No more re-exporting the same
block by hand, and no secret ever touches `.zsh_history`.

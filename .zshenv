# Keep tsh out of the system ssh-agent's blast radius: with the default
# (auto), every tsh client init dials SSH_AUTH_SOCK and loads keys with no
# timeout — a wedged agent silently hangs every tsh command (root-caused
# 2026-08-18; see teleport-zsh docs / tsh --add-keys-to-agent).
export TELEPORT_ADD_KEYS_TO_AGENT=no

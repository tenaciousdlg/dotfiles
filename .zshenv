# Keep tsh out of the system ssh-agent's blast radius: with the default
# (auto), every tsh client init dials SSH_AUTH_SOCK and loads keys with no
# timeout — a wedged agent silently hangs every tsh command (root-caused
# 2026-08-18; see teleport-zsh docs / tsh --add-keys-to-agent).
export TELEPORT_ADD_KEYS_TO_AGENT=no

# Teleport managed client-tools updates: ONE cluster decides, not all of them.
#
# Left to itself, every cluster with tools-updates enabled dictates the
# tsh/Connect version, so hopping between clusters on different versions made
# tsh re-download+swap and Connect relaunch each time ("building again",
# 2026-09-09). `off` stopped that, but also meant nothing could ever update the
# tools.
#
# Now teleport.chrisdlg.com is the primary/stable cluster and is the only one
# allowed to move the version. `teleport-tools-sync` reads what it advertises
# and caches it here; every other cluster is ignored because an explicit
# version always wins over a cluster's own instruction.
#
# The fallback is `off`, deliberately: an unreachable or never-synced primary
# must leave tsh working exactly as it does today, never blocked on a download.
_tp_tools_pin=$(cat "${XDG_CACHE_HOME:-$HOME/.cache}/teleport/tools-version" 2>/dev/null)
export TELEPORT_TOOLS_VERSION="${_tp_tools_pin:-off}"
unset _tp_tools_pin

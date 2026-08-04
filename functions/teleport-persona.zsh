# Persona shell launcher for demo stations — codifies the two-identity
# pattern (TELEPORT_HOME=~/.tsh-<persona>) so a persona terminal is one
# command:
#
#   tpersona bob             # bob@blackhat (default proxy)
#   tpersona alice a4232.teleportdemo.com
#
# Sets the terminal tab title (BOB — blackhat), logs in with --auth=local
# if the persona has no live cert, and drops into a subshell where the
# teleport prompt segment renders in persona magenta. Exit the subshell to
# return to your own identity; the tab title is restored.
#
# Default proxy comes from TELEPORT_PERSONA_PROXY (falls back to blackhat).

tpersona() {
  emulate -L zsh
  local name=$1
  if [[ -z $name ]]; then
    print -u2 "usage: tpersona <name> [proxy]"
    return 1
  fi
  local proxy=${2:-${TELEPORT_PERSONA_PROXY:-blackhat.teleportdemo.com}}
  local phome=$HOME/.tsh-$name
  mkdir -p "$phome"

  print -n "\e]0;${(U)name} — ${proxy%%.*}\a"
  if ! TELEPORT_HOME=$phome command tsh status &>/dev/null; then
    print -P "%F{5}logging in as ${name}@${proxy} (local auth)...%f"
    if ! TELEPORT_HOME=$phome command tsh login --proxy=${proxy}:443 $proxy --auth=local --user=$name; then
      print -n "\e]0;\a"
      return 1
    fi
  fi
  TELEPORT_HOME=$phome zsh
  print -n "\e]0;\a"
}

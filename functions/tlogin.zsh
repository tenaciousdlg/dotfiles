# Shortcuts for the Teleport demo clusters logged into most often.
# Update the case entries below as demo clusters come and go.
tlogin() {
  case "$1" in
    presales)
      tsh login --proxy=presales.teleportdemo.com:443 presales.teleportdemo.com --auth=okta-integrator
      ;;
    gke)
      tsh login --proxy=teleport-gke.teleportsedemo.com --insecure
      ;;
    dlg)
      tsh login --proxy=dlgdemo.teleport.sh --user=chris.delagarza@goteleport.com --auth=local
      ;;
    a4232)
      tsh login --proxy=a4232.teleportdemo.com:443 a4232.teleportdemo.com
      ;;
    bold-truth)
      tsh login --proxy=bold-truth.beams.run:443 --user=dlg@goteleport.com
      ;;
    *)
      echo "usage: tlogin {presales|gke|dlg|a4232|bold-truth}" >&2
      return 1
      ;;
  esac
}

tswitch() {
  tsh logout
  tlogin "$1"
}

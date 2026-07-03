function gssh() {
  readonly local name="$1"
  local filter result instance_name zone

  printf "🖥️   Connecting to instance: %s\n\n" "$name"

  filter="(name:${name} AND status:RUNNING)"
  result="$(gcloud compute instances list --sort-by=-createTime --format='value(name,zone)' --filter="$filter")"
  instance_name="$(echo "$result" | awk 'NR==1 {print $1}')"
  zone="$(echo "$result" | awk 'NR==1 {print $2}')"

  if [ -n "$instance_name" ]; then
    gcloud beta compute ssh "$name" --zone "$(basename "$zone")"
  else
    printf "❌  Instance not found\n"
  fi
}

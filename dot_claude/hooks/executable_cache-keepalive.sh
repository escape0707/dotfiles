#!/usr/bin/env bash
# Keep the prompt cache warm on an idle session by pinging the model shortly
# before the 1h cache TTL expires. At most KEEPALIVE_MAX pings per idle stretch.
#
# Events (from ~/.claude/settings.json):
#   Stop             (asyncRewake) arm: sleep, then exit 2 to wake the model
#   UserPromptSubmit reset: a real prompt cancels pending timers, zeroes count
#   SessionEnd       cleanup: drop state so pending timers exit quietly
#
# Env overrides (for testing): KEEPALIVE_DELAY seconds, KEEPALIVE_MAX count.
set -u

DELAY=${KEEPALIVE_DELAY:-3300}
MAX=${KEEPALIVE_MAX:-3}
ROOT=${XDG_STATE_HOME:-$HOME/.local/state}/claude-keepalive

input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input")
sid=$(jq -r '.session_id // empty' <<<"$input")
[ -n "$sid" ] || exit 0
dir=$ROOT/$sid

case $event in
  UserPromptSubmit)
    mkdir -p "$dir"
    [ -n "${KEEPALIVE_DEBUG:-}" ] && echo "$input" >>"$dir/debug.jsonl"
    # The rewake of our own ping also fires UserPromptSubmit; don't let it
    # reset the count, or pings never stop.
    case $(jq -r '.prompt // empty' <<<"$input") in
      *"Cache keep-alive ping"*) exit 0 ;;
    esac
    echo 0 >"$dir/count"
    date +%s%N >"$dir/gen"   # invalidates any armed timer
    ;;
  SessionEnd)
    rm -rf "$dir"
    ;;
  Stop)
    # Sweep state left by sessions that ended without SessionEnd.
    find "$ROOT" -mindepth 1 -maxdepth 1 -mtime +1 -exec rm -rf {} + 2>/dev/null
    mkdir -p "$dir"
    count=$(cat "$dir/count" 2>/dev/null || echo 0)
    [ "$count" -lt "$MAX" ] || exit 0
    token=$(date +%s%N)
    echo "$token" >"$dir/gen"
    sleep "$DELAY"
    # Superseded by a newer Stop, a user prompt, or session end.
    [ "$(cat "$dir/gen" 2>/dev/null)" = "$token" ] || exit 0
    count=$(( $(cat "$dir/count" 2>/dev/null || echo 0) + 1 ))
    echo "$count" >"$dir/count"
    # This ping refreshes the 1h TTL. Remaining pings each add DELAY, so if
    # nobody returns the cache goes cold 1h after the last one.
    cold=$(date -d "@$(( $(date +%s) + (MAX - count) * DELAY + 3600 ))" +%H:%M)
    echo "Cache keep-alive ping. Reply with exactly this line and nothing else:" \
      "pong $count/$MAX - cache cold at $cold if still idle" >&2
    exit 2
    ;;
esac
exit 0

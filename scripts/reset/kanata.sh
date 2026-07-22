#!/usr/bin/env bash
# reset-kanata.sh
#
# Tears down everything install.sh / config.sh set up, plus anything left
# behind by `cargo install kanata`, so you can start clean.
#
# What it does:
#   1. Kills any running kanata processes (any source: brew, cargo, manual build)
#   2. Boots out and removes the com.example.* LaunchDaemons
#   3. Deactivates the Karabiner-DriverKit-VirtualHIDDevice system extension
#   4. Removes the DriverKit daemon/manager app support files
#   5. Optionally uninstalls kanata itself (brew + cargo)
#
# Safe to re-run. Non-fatal errors are ignored so it can clean up partial state.
#
# Usage:
#   chmod +x reset-kanata.sh
#   sudo ./reset-kanata.sh            # reset daemons/driver, keep kanata binary
#   sudo ./reset-kanata.sh --purge    # also uninstall kanata (brew + cargo)

set -uo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Please run with sudo: sudo $0 $*"
  exit 1
fi

PURGE=false
[[ "${1:-}" == "--purge" ]] && PURGE=true

REAL_USER="${SUDO_USER:-$(whoami)}"
REAL_HOME=$(eval echo "~${REAL_USER}")

echo "=== 1. Killing running kanata processes ==="
pkill -x kanata 2>/dev/null || true
pkill -f "/kanata " 2>/dev/null || true
sleep 1
if pgrep -x kanata >/dev/null 2>&1; then
  echo "kanata still running, force killing..."
  pkill -9 -x kanata 2>/dev/null || true
fi
echo "done"

echo
echo "=== 2. Tearing down com.example.* LaunchDaemons ==="
for job in com.example.kanata com.example.karabiner-vhiddaemon com.example.karabiner-vhidmanager; do
  echo "-- ${job}"
  launchctl bootout "system/${job}" 2>/dev/null || true
  rm -f "/Library/LaunchDaemons/${job}.plist"
done
echo "done"

echo
echo "=== 3. Killing any leftover Karabiner VirtualHIDDevice daemon processes ==="
pkill -f "Karabiner-VirtualHIDDevice-Daemon" 2>/dev/null || true
pkill -f "Karabiner-VirtualHIDDevice-Manager" 2>/dev/null || true
echo "done"

echo
echo "=== 4. Deactivating the DriverKit virtual HID extension ==="
MANAGER="/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
if [[ -x "$MANAGER" ]]; then
  "$MANAGER" deactivate || true
else
  echo "manager binary not found at expected path, skipping deactivate"
fi
echo "NOTE: macOS will mark this 'requires reboot' -- that's expected."

echo
echo "=== 5. Clearing stale rootonly IPC/socket state ==="
rm -rf "/Library/Application Support/org.pqrs/tmp/rootonly/vhidd_client" 2>/dev/null || true
rm -rf "/Library/Application Support/org.pqrs/tmp/rootonly/vhidd_response" 2>/dev/null || true
echo "done"

echo
echo "=== 6. Removing logs ==="
rm -rf /Library/Logs/Kanata 2>/dev/null || true
echo "done"

if $PURGE; then
  echo
  echo "=== 7. Purging kanata binary (brew + cargo) ==="
  if command -v brew >/dev/null 2>&1; then
    sudo -u "$REAL_USER" brew uninstall kanata 2>/dev/null || true
  fi
  CARGO_BIN="${REAL_HOME}/.cargo/bin/kanata"
  if [[ -f "$CARGO_BIN" ]]; then
    rm -f "$CARGO_BIN"
    echo "removed ${CARGO_BIN}"
  fi
  echo "done"
fi

echo
echo "=== Reset complete ==="
echo "Next steps:"
echo "  1. Reboot the Mac now (DriverKit extension state won't fully clear until you do)."
echo "  2. After reboot, run your install.sh again to reinstall + reactivate the driver."
echo "  3. Go to System Settings > General > Login Items & Extensions > Driver Extensions"
echo "     and re-approve Karabiner-DriverKit-VirtualHIDDevice if prompted."
echo "  4. Only THEN reinstall/rerun kanata (brew or cargo) -- installing kanata while the"
echo "     driver extension is mid-reset is likely why it's locking your keyboard: kanata"
echo "     grabs the keyboard exclusively at the OS level even when its virtual HID output"
echo "     can't connect, so input goes into a black hole. If you get locked out again,"
echo "     kanata's docs note lctl+spc+esc (defsrc-side keys) force-quits it."

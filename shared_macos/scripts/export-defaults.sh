#!/bin/bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
shared_dir="$(cd $this_script_abs_path/../../shared >/dev/null && pwd)"
shared_dir_macos="$(cd $this_script_abs_path/.. >/dev/null && pwd)"

set -e
source "$shared_dir"/scripts/helper.sh
host_dir="$(cd $shared_dir/../macos/$system_hostname >/dev/null && pwd)"
trap trap_error ERR

# AltTab
alttab_key="com.lwouis.alt-tab-macos"
alttab_file="$shared_dir_macos/plist/${alttab_key}.plist"

# BetterDisplay
betterdisplay_key="pro.betterdisplay.BetterDisplay"
betterdisplay_file="$host_dir/${betterdisplay_key}.plist"

# Mac Mouse Fix
macmousefix_key="com.nuebling.mac-mouse-fix"
macmousefix_file="$shared_dir_macos/plist/${macmousefix_key}.plist"

# Rectangle
rectangle_key="com.knollsoft.Rectangle"
rectangle_file="$shared_dir_macos/plist/${rectangle_key}.plist"
rectangle_chords_key="com.knollsoft.Hookshot"
rectangle_chords_file="$shared_dir_macos/plist/${rectangle_chords_key}.plist"

[ "$1" = "--source-keys-only" ] && return 0 || true

log_info ">>> Exporting AltTab settings..."
defaults export "$alttab_key" "$alttab_file"

log_info ">>> Exporting Betterdisplay settings..."
defaults export "$betterdisplay_key" "$betterdisplay_file"

log_info ">>> Exporting Mac Mouse Fix settings..."
cp "$HOME/Library/Application Support/${macmousefix_key}/config.plist" "$macmousefix_file"

log_info ">>> Exporting Rectangle settings..."
defaults export "$rectangle_key" "$rectangle_file"

log_info ">>> Exporting Rectangle chord settings..."
defaults export "$rectangle_chords_key" "$rectangle_chords_file"
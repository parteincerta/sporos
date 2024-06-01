#!/bin/bash

this_script="$(basename ${BASH_SOURCE[0]})"
this_script_rel_path="$(dirname ${BASH_SOURCE[0]})"
this_script_abs_path="$(cd $this_script_rel_path >/dev/null && pwd)"
shared_dir="$(cd $this_script_abs_path/../../shared >/dev/null && pwd)"
shared_dir_macos="$(cd $this_script_abs_path/.. >/dev/null && pwd)"

source "$shared_dir"/scripts/helper.sh
host_dir="$(cd $shared_dir/../macos/$system_hostname >/dev/null && pwd)"

trap_error () {
	local exit_code=$?
	local failed_cmd="$BASH_COMMAND"
	local failed_line_nr="$BASH_LINENO"
	log_error ">>> Failed the execution of $this_script on line $failed_line_nr."
	log_error ">>> Command '$failed_cmd' failed with exit code $exit_code."
}

set -e
trap trap_error ERR

altab_key="com.lwouis.alt-tab-macos"
altab_file="$shared_dir_macos/plist/${altab_key}.plist"

betterdisplay_key="pro.betterdisplay.BetterDisplay"
betterdisplay_file="$host_dir/${betterdisplay_key}.plist"

macmousefix_key="com.nuebling.mac-mouse-fix"
macmousefix_file="$shared_dir_macos/plist/${macmousefix_key}.plist"

rectangle_key="com.knollsoft.Rectangle"
rectangle_file="$shared_dir_macos/plist/${rectangle_key}.plist"
rectangle_chords_key="com.knollsoft.Hookshot"
rectangle_chords_file="$shared_dir_macos/plist/${rectangle_chords_key}.plist"

log_info ">>> Exporting AltTab settings to $altab_file ..."
defaults export "$altab_key" "$altab_file"

log_info ">>> Exporting Betterdisplay settings to $betterdisplay_file ..."
defaults export "$betterdisplay_key" "$betterdisplay_file"

log_info ">>> Exporting Mac Mouse Fix settings to $macmousefix_file..."
cp "$HOME/Library/Application Support/${macmousefix_key}/config.plist" "$macmousefix_file"

log_info ">>> Exporting Rectangle settings to $rectangle_file ..."
defaults export "$rectangle_key" "$rectangle_file"

log_info ">>> Exporting Rectangle chord settings to $rectangle_chords_file ..."
defaults export "$rectangle_chords_key" "$rectangle_chords_file"
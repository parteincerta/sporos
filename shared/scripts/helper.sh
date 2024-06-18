# vim:ft=bash

color_reset="\033[0m"
fg_blue="\033[0;36m"
fg_green="\033[0;32m"
fg_orange="\033[0;33m"
fg_red="\033[0;31m"

# NOTE: To understand Bash's parameter expansion:
# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
system_hostname="${HOSTNAME/%.local/}"
if [ "$system_hostname" = "Fernando-Moreira-MacBook-Pro-16-inch-Nov-2023-" ]; then
	system_hostname="dremio"
fi

enter_password () {
	local pwd1="pwd1"
	local pwd2="pwd2"
	while [ "$pwd1" != "$pwd2" ]; do
		read -s -p Password: pwd1
		>&2 echo
		read -s -p Confirm: pwd2
		>&2 echo
		[ "$pwd1" != "$pwd2" ] &&
			log_warning "  -> Passwords don't match. Enter them again."
	done
	printf "$pwd1"
}

join_strings () {
	echo "$(IFS=; echo "$*")"
}

log_default () {
	>&2 echo -e "$1"
}

log_error () {
	>&2 echo -e "${fg_red}$1${color_reset}"
}

log_info () {
	>&2 echo -e "${fg_blue}$1${color_reset}"
}

log_success () {
	>&2 echo -e "${fg_green}$1${color_reset}"
}

log_warning () {
	>&2 echo -e "${fg_orange}$1${color_reset}"
}

trap_error () {
	local exit_code=$?
	local failed_cmd="$BASH_COMMAND"
	local failed_line_nr="$BASH_LINENO"
	log_error ">>> Failed the execution of $this_script on line $failed_line_nr."
	log_error ">>> Command '$failed_cmd' failed with exit code $exit_code."
}
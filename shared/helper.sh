# vim:ft=bash

color_reset="\033[0m"
fg_blue="\033[0;36m"
fg_green="\033[0;32m"
fg_orange="\033[0;33m"
fg_red="\033[0;31m"

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
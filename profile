# Append "$1" to $PATH when not already in.
# Copied from Arch Linux, see #12803 for details.
append_path () {
	case ":$PATH:" in
		*:"$1":*)
			;;
		*)
			PATH="${PATH:+$PATH:}$1"
			;;
	esac
}

append_path "/usr/local/sbin"
append_path "/usr/local/bin"
append_path "/usr/sbin"
append_path "/usr/bin"
append_path "/sbin"
append_path "/bin"
unset -f append_path

export PATH
export PAGER=less
umask 022

# set up fallback default PS1
: "${HOSTNAME:=$(hostname)}"
PS1='${HOSTNAME%%.*}:$PWD'
[ "$(id -u)" = "0" ] && PS1="${PS1}# "
[ "$(id -u)" = "0" ] || PS1="${PS1}\$ "

# use nicer PS1 for bash and busybox ash
[ -n "$BASH_VERSION" -o "$BB_ASH_VERSION" ] && PS1='\h:\w\$ '

# use nicer PS1 for zsh
[ -n "$ZSH_VERSION" ] && PS1='%m:%~%# '

# export PS1 as before
export PS1

for script in /etc/profile.d/*.sh ; do
	if [ -r "$script" ] ; then
		. "$script"
	fi
done
unset script

# 256-bit ANSI Colors
BLACK="\e[38;5;232m"
RED="\e[38;5;196m"  
GREEN="\e[38;5;77m" 
YELLOW="\e[38;5;227m"
ORANGE="\e[38;5;202m"
BLUE="\e[38;5;4m" 
PURPLE="\e[38;5;165m"
PINK="\e[38;5;201m"
CYAN="\e[38;5;51m"
WHITE="\e[38;5;255m"
RESTORE="\e[0m" 


if [ -z $SCHROOT_CHROOT_NAME ]; then
    SCHROOT_CHROOT_NAME=" "
fi

PS1="${ORANGE}\u${WHITE}@${GREEN}\h${SCHROOT_CHROOT_NAME}${BLUE}\w ${WHITE}\$ $RESTORE"

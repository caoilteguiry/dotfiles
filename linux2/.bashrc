# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
  case `whoami` in
  root)
	  prompt_color="01;31"
	  ;;
  *)
	  if [ "" = "${SSH_CONNECTION}" ]
    then
	  	prompt_color="01;32";
	  else
	  	prompt_color="01;35";
    fi
	  ;;
  esac
  PS1='${debian_chroot:+($debian_chroot)}\[\033[${prompt_color}m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#####################################
# DEFAULT .bashrc ends here
#####################################
# some more ls aliases
alias sl=ls  # pretty common typo
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF' 
alias lias='ls -lias' # long listing with inodes, hidden files, size
alias lld='ls -l | grep ^d'  # long-list dirs 
alias lll='ls -l | grep ^l'  # long-list links

# for safety...
alias cp='cp -iv'
alias rm='rm -iv'
alias mv='mv -iv'

# for verbosity...
alias mkdir='mkdir -v'

# Some svn diff aliases
alias svndiff='svn diff --diff-cmd svnvimdiff'  
alias svnmeld='svn diff --diff-cmd=meld'

# rlwrap...
alias telnet='rlwrap telnet'

# misc...
alias units='units --verbose'   # no idea why this isn't the default
alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'  # quickly share files in cwd
alias random_password="egrep -ioam1 '[a-z0-9]{8}' /dev/urandom"  # pseudo-random password
alias vimdiff_empty='vimdiff <(echo) <(echo)'  # handy for debugging

# disable ctrl+d accidental closing of terminal 
set -o ignoreeof
# avoid accidental file overwrites
set -o noclobber

# Env vars
export PATH=${PATH}:~/bin
export EDITOR=vim
export HISTSIZE=50000
# color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;34m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export PYTHONSTARTUP=~/.pythonrc.py

# Functions
# Subversion pipes to extract modified files, unversioned files and added files
function getsvnmod() { svn status | grep ^M | awk '{print $2}' | sed -n $1p; }
function getsvnunversioned() { svn status | grep ^? | awk '{print $2}' | sed -n $1p; }
function getsvnadd() { svn status | grep ^A | awk '{print $2}' | sed -n $1p; }
function unixtime2datetime()
{ 
  python -c 'from datetime import datetime; print datetime.fromtimestamp('$1')'; 
}

function wgetdiff()
{
  local usage="wgetdiff <url> <url>"
  if [ $# -ne 2 ]
  then
    echo "Invalid number of args"
    echo $usage
    return
  fi
  vimdiff <(wget "$1" -O -) <(wget $2 -O -)
}



function compare_dirs()
{
  local usage="Usage: compare_dirs [options] dir1 dir2\n"
  usage+="Options:"
  usage+="\n--non-recursive, -nr"
  usage+="\n\tDo a non-recursive comparison"
  if [ "--non-recursive" = "${1}" -o "-nr" = "${1}" ]
  then
    r=""
    shift    
  else
    r="-R"
  fi 
  if [ -d "$1" -a -d "$2" ]; 
  then 
    vimdiff <(ls -l ${r} "$1" | awk '{print $5" "$8}') <(ls -l ${r} "$2" | awk '{print $5" "$8}')
  else
    echo -e "Syntax error." 
    echo -e $usage
  fi
}

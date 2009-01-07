# jruby stuff:
export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.10
export JRUBY_HOME=/usr/src/jruby-1.1.2
export PATH=$PATH:$JRUBY_HOME/bin
for f in $JRUBY_HOME/bin/*; do
  f=$(basename $f)
  case $f in jruby*|jirb*|*.bat|*.rb|_*) continue ;; esac
  eval "alias j$f='jruby -S $f'"
done

# oracle shit:
export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server/
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


# Genereric bash configuration (with color) below:
# =============================================================================

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

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
force_colored_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias dir='ls --color=auto --format=vertical'
  alias vdir='ls --color=auto --format=long'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
alias l='ls -lh'

alias g='vim --remote-tab'
case $TERM in
  rxvt|*term|xterm*)
    alias g='gvim --remote-tab'
  ;;
esac

if [ "`id -u`" -eq 0 ]; then
  alias hosts='vim /etc/hosts'
else
  alias hosts='sudo vim /etc/hosts'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# Colorize and add support for all major Version Control Systems:
# =============================================================================

_bold=$(tput bold)
_normal=$(tput sgr0)
 
__prompt_command() {
  local vcs base_dir sub_dir ref last_command
  sub_dir() {
    local sub_dir
    # uncomment next line for OSX:
    # sub_dir=$(stat -f "${PWD}")
    # or choose next line for Ubuntu:
    sub_dir=$(stat --printf="%n" "${PWD}")
    sub_dir=${sub_dir#$1}
    echo ${sub_dir#/}
  }
 
  git_dir() {
    base_dir=$(git rev-parse --show-cdup 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir=$(git rev-parse --show-prefix)
    sub_dir="/${sub_dir%/}"
    ref=$(git symbolic-ref -q HEAD || git name-rev --name-only HEAD 2>/dev/null)
    ref=${ref#refs/heads/}
    vcs="git"
    alias pull="git pull"
    alias commit="git commit -v -a"
    alias push="commit ; git push"
    alias revert="git checkout"
  }
 
  svn_dir() {
    [ -d ".svn" ] || return 1
    base_dir="."
    while [ -d "$base_dir/../.svn" ]; do base_dir="$base_dir/.."; done
    base_dir=`cd $base_dir; pwd`
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=$(svn info "$base_dir" | awk '/^URL/ { sub(".*/","",$0); r=$0 } /^Revision/ { sub("[^0-9]*","",$0); print r":"$0 }')
    vcs="svn"
    alias pull="svn up"
    alias commit="svn commit"
    alias push="svn ci"
    alias revert="svn revert"
  }
 
  bzr_dir() {
    base_dir=$(bzr root 2>/dev/null) || return 1
    if [ -n "$base_dir" ]; then
      base_dir=`cd $base_dir; pwd`
    else
      base_dir=$PWD
    fi
    sub_dir="/$(sub_dir "${base_dir}")"
    ref=$(bzr revno 2>/dev/null)
    vcs="bzr"
    alias pull="bzr pull"
    alias commit="bzr commit"
    alias push="bzr push"
    alias revert="bzr revert"
  }
  
 
  git_dir || svn_dir || bzr_dir
 
  if [ -n "$vcs" ]; then
    alias st="$vcs status"
    alias d="$vcs diff"
    alias up="pull"
    alias cdb="cd $base_dir"
    base_dir="$(basename "${base_dir}")"
    working_on="[$base_dir] "
    __vcs_prefix="($vcs)"
    __vcs_ref="[$ref]"
    __vcs_sub_dir="${sub_dir}"
    __vcs_base_dir="${base_dir/$HOME/~}"
  else
    __vcs_prefix=':'
    __vcs_base_dir="${PWD/$HOME/~}"
    __vcs_ref=''
    __vcs_sub_dir=''
    working_on=""
  fi
 
  last_command=$(history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")
  __tab_title="$working_on[$last_command]"
  __pretty_pwd="${PWD/$HOME/~}"
}
 
PROMPT_COMMAND=__prompt_command

if [ "`id -u`" -eq 0 ]; then
  PS1='\[\e]2;\h:$__pretty_pwd\a\e]1;$__tab_title\a\]\[\033[1;37;41m\]\u\[\033[00;00m\]\[\033[1;32;35m\]${__vcs_prefix}\[\033[1;32;34m\]${__vcs_base_dir}\[\033[1;32;33m\]${__vcs_ref}\[\033[1;32;34m\]${__vcs_sub_dir}\[\033[1;37;41m\]\$\[\033[00;00m\] '
else
  PS1='\[\e]2;\h:$__pretty_pwd\a\e]1;$__tab_title\a\]\[\033[1;32;32m\]\u\[\033[1;32;35m\]${__vcs_prefix}\[\033[1;32;34m\]${__vcs_base_dir}\[\033[1;32;33m\]${__vcs_ref}\[\033[1;32;34m\]${__vcs_sub_dir}\[\033[1;32;32m\]\$\[\033[00;00m\] '
fi

# Show the currently running command in the terminal title:
# http://www.davidpashley.com/articles/xterm-titles-with-bash.html
if [ -z "$TM_SUPPORT_PATH"]; then
case $TERM in
  rxvt|*term|xterm*)
    trap 'echo -e "\e]2;$working_on$BASH_COMMAND\007\c"' DEBUG
  ;;
esac
fi

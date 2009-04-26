# Colorize and add support for all major Version Control Systems:
# Source: Relevance (github.com/relavance/etc), but colored, and with Ubuntu support
# =============================================================================

_bold=$(tput bold)
_normal=$(tput sgr0)
_blue=`tput setf 1`
_green=`tput setf 2`
_cyan=`tput setf 3`
_red=`tput setf 4`
_magenta=`tput setf 5`
_yellow=`tput setf 6`
_white=`tput setf 7`

if [ `id -u` -eq 0 ]; then
  _user_color=`tput setf 4`
else
  _user_color=`tput setf 2`
fi

__prompt_command() {
  local vcs base_dir sub_dir ref last_command diff_options status_options

  diff_options="" # diff_options will get overrided by svn, because it needs colordiff as piped argument
  status_options="" # status in svn will automatically get the base_dirs status, so it behaves as git

  sub_dir() {
    local sub_dir
    # uncomment next line for OSX:
    # sub_dir=$(stat -f "${PWD}")
    # or choose next line for Ubuntu:
    sub_dir=$(stat --printf="%n" "${PWD}")
    sub_dir=${sub_dir#$1}
    echo ${sub_dir#/}
  }
 
 
  # http://github.com/blog/297-dirty-git-state-in-your-prompt
  function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "${_red}"
  }
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/$(parse_git_dirty)\1/"
  }
  function dirty_svn {
    if `svnversion $1 | grep -Eq 'M$'`; then echo "${_red}`svnversion | grep -o '[0-9]*' --color=no`"; else echo "${_yellow}`svnversion`"; fi
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
    ref=$(parse_git_branch)
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
    ref=$(dirty_svn "$base_dir")
    vcs="svn"
    diff_options=" | colordiff"
    if [ " $sub_dir " = " / " ]; then
      status_options=""
    else # perform a status for the entire project
      status_options=" ${base_dir}"
    fi
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
    alias st="$vcs status$status_options"
    alias d="$vcs diff$diff_options"
    alias up="pull"
    alias cdb="cd $base_dir"
    base_dir="$(basename "${base_dir}")"
    working_on="$base_dir"
    __vcs_prefix="$vcs "
    __vcs_ref=" $ref "
    __vcs_sub_dir="${sub_dir}"
    __vcs_base_dir="${base_dir/$HOME/~}"
  else
    __vcs_prefix=''
    __vcs_base_dir="${PWD/$HOME/~}"
    __vcs_ref=''
    __vcs_sub_dir=''
    working_on=""
  fi
 
  last_command=$(history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//g")
  __tab_title="$working_on[$last_command]:"
  __pretty_pwd="${PWD/$HOME/~}"
}


PROMPT_COMMAND=__prompt_command

# black and white prompt
#PS1='\[\e]2;\h::$__pretty_pwd\a\e]1;$__tab_title\a\]\u:$__vcs_prefix\[${_bold}\]${__vcs_base_dir}\[${_normal}\]${__vcs_ref}\[${_bold}\]${__vcs_sub_dir}\[${_normal}\]\$ '
# COLOR
PS1='\[\e]2;$__pretty_pwd\a\e]1;$__tab_title\a\]\[$_bold\]\[$_user_color\]\u \[$_magenta\]$__vcs_prefix\[$_blue\]${__vcs_base_dir}\[$_yellow\]${__vcs_ref}\[$_blue\]${__vcs_sub_dir}\n\[$_user_color\]\$\[$_normal\] '

# Show the currently running command in the terminal title:
# http://www.davidpashley.com/articles/xterm-titles-with-bash.html
if [ -z "$TM_SUPPORT_PATH"]; then
case $TERM in
  rxvt|*term|xterm-color)
    trap 'echo -e "\e]1;$working_on>$BASH_COMMAND<\007\c"' DEBUG
  ;;
esac
fi

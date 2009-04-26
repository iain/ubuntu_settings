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
alias df='df -h'

case $TERM in
  rxvt|*term|xterm*)
    alias g='gvim --remote-tab'
  ;;
esac

# general shortcuts
alias c='cd '
alias ::='cd ..'
alias :::='cd ../..'
alias ::::='cd ../../..'
alias v='vmstat'
alias md=mkdir

# Need to do this so you use backspace in screen...I have no idea why
alias screen='TERM=screen screen'

# listing files
alias ltr='ls -ltr'
alias lth='l -t|head'
alias lh='ls -Shl | less'
alias tf='tail -f -n 100'
alias t500='tail -n 500'
alias t1000='tail -n 1000'
alias t2000='tail -n 2000'

# svn
alias sup='svn up'
alias sst='svn st'
alias sstu='svn st -u'
alias sci='svn ci -m'
alias sdiff='svn diff | colordiff'
alias sadd="sst | grep '?' | cut -c5- | xargs svn add"

# ignore svn metadata - pipe this into xargs to do stuff
alias no_svn="find . -path '*/.svn' -prune -o -type f -print"

# grep for a process
function psg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# Debian style apache control
alias htreload='sudo /etc/init.d/apache2 reload'
alias htrestart='sudo /etc/init.d/apache2 restart'
alias htstop='sudo /etc/init.d/apache2 stop'


# Edit hosts-file easily
if [ "`id -u`" -eq 0 ]; then
  alias hosts='vim /etc/hosts'
else
  alias hosts='sudo vim /etc/hosts'
fi

# ruby shortcuts
alias sc='script/console'
alias scprod='script/console production'
alias ss='script/server'
alias sg='script/generate'
alias rake='rake --silent'
alias rt='rake --trace'
alias rs='rake spec'
alias rrcov='rake spec:rcov'
alias rdm='rake db:migrate && rake db:test:prepare'
alias rdtp='rake db:test:prepare'
alias rdr='rake db:rollback'
alias rroutes='rake routes'
alias dbsqlite3='cp config/database{.sqlite3,}.yml'
alias dbmysql='cp config/database{.mysql,}.yml'

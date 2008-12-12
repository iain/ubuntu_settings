# Colored prompt, identifying root
if [ "`id -u`" -eq 0 ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

alias l='ls -lh'
alias g='gvim --remote-tab'
alias hosts='sudo vim /etc/hosts'

# JRuby
export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.10
export JRUBY_HOME=/usr/src/jruby-1.1.2
export PATH=$PATH:$JRUBY_HOME/bin

for f in $JRUBY_HOME/bin/*; do
  f=$(basename $f)
  case $f in jruby*|jirb*|*.bat|*.rb|_*) continue ;; esac
  eval "alias j$f='jruby -S $f'"
done

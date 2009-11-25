#!/bin/sh

# Install a bunch of Ubuntu apps and libs
sudo apt-get install \
  git-core \
  ruby \
  rake \
  vim \
  curl \
  rdoc \
  subversion \
  ruby1.8-dev \
  libopenssl-ruby1.8 \
  libsqlite3-ruby1.8 \
  libnotify-bin \
  imagemagick \
  build-essential \
  libmagick9-dev \
  irb \
  libxml-ruby \
  libxslt-ruby \
  libxslt-dev \
  graphviz \
  rubygems \
  colordiff \
  -y

# Get the project it comes from and install it
rm -rf ~/.ubuntu_settings
git clone git://github.com/iain/ubuntu_settings.git ~/.ubuntu_settings
cd ~/.ubuntu_settings/
ruby install-dotfiles.rb

# Install VIM stuf
cd ~
mkdir -p ~/.vim/tmp/swap
mkdir -p ~/.vim/tmp/backup
git clone git://github.com/tpope/vim-rails.git
cd vim-rails
rake install
cd ~


# RubyGems config
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem
# no local installs please!
sudo chown root:root -R ~/.gem
sudo chmod 0700 -R ~/.gem

# Install a lot of gems to get you started
sudo gem sources --add http://gems.github.com
sudo gem install \
  rails \
  rspec \
  rspec-rails \
  ZenTest \
  rcov \
  roodi \
  reek \
  redgreen \
  flay \
  flog \
  voloko-sdoc \
  syntax \
  jscruggs-metric_fu \
  mongrel \
  rmagick \
  fastercsv \
  mislav-will_paginate \
  thoughtbot-factory_girl \
  thoughtbot-shoulda \
  authlogic \
  mocha \
  rr \
  haml \
  rak \
  wirble \
  nokogiri \
  cucumber \
  webrat \
  faker \
  railroad \
  ya2yaml \
  hpricot \
  rack \
  term-ansicolor \
  treetop \
  diff-lcs \
  --no-ri --no-rdoc

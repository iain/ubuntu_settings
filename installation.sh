#!/bin/sh

# Install a bunch of Ubuntu apps and libs
sudo apt-get install \
  git-core \
  ruby \
  vim-full \
  rdoc \
  subversion \
  ruby1.8-dev \
  libopenssl-ruby1.8 \
  libsqlite3-ruby1.8 \
  imagemagick \
  build-essential \
  libmagick9-dev \
  irb \
  libxml-ruby \
  libxslt-ruby \
  libxslt-dev \
  -y

# Get the project it comes from and install it
git clone git://github.com/iain/ubuntu_settings.git ~/.ubuntu_settings
cd ~/.ubuntu_settings/
ruby install_dotfiles.rb

# Install VIM stuf
cd ~
mkdir -p ~/.vim/tmp/swap
mkdir -p ~/.vim/tmp/backup

# Install RubyGems
# Goto http://rubyforge.org/frs/?group_id=126 for the newest version
wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar -vxf rubygems-1.3.1.tgz
cd rubygems-1.3.1/
sudo ruby setup.rb
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

# Install a lot of gems to get you started
sudo gem sources --add http://gems.github.com
sudo gem install \
  rails \
  rspec \
  rspec-rails \
  ZenTest \
  jscruggs-metric_fu \
  mongrel \
  rmagick \
  iain-not \
  nifty-generators \
  iain-pizza-generators \
  mislav-will_paginate \
  thoughtbot-factory_girl \
  thoughtbot-shoulda \
  authlogic \
  mocha \
  haml \
  rak \
  wirble \
  rspec \
  rails-rspec \
  nokogiri \
  cucumber \
  brynary-webrat \
  faker \
  railroad \
  ya2yaml \
  giraffesoft-resource_controller

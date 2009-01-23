
sudo apt-get install git-core ruby vim-full rdoc subversion ruby1.8-dev libopenssl-ruby1.8 libsqlite3-ruby1.8 imagemagick build-essential libmagick9-dev irb -y
git clone git://github.com/iain/ubuntu_settings.git
cd ubuntu_settings/
ruby install_dotfiles.rb
cd ~
mkdir -p ~/.vim/tmp/swap
mkdir -p ~/.vim/tmp/backup
# goto http://rubyforge.org/frs/?group_id=126 for the newest gem version
wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar -vxf rubygems-1.3.1.tgz
cd rubygems-1.3.1/
sudo ruby setup.rb
sudo ln -s /usr/bin/gem1.8 /usr/bin/gem
sudo gem sources --add http://gems.github.com
sudo gem install rails rspec rspec-rails ZenTest jscruggs-metric_fu mongrel rmagick iain-not nifty-generators haml rak wirble

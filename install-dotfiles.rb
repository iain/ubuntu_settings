require 'fileutils'
files = Dir["dotfiles/*"].each do |f|
  cmd = "ln -fs #{File.expand_path(f)} ~/.#{File.basename(f)}"
  puts cmd
  `#{cmd}`
end

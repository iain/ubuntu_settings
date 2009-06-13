require 'fileutils'
files = Dir["dotfiles/*"].each do |f|
  `mv ~/.#{File.basename(f)} ~/#{File.basename(f)}.bak`
  cmd = "ln -fs #{File.expand_path(f)} ~/.#{File.basename(f)}"
  puts cmd
  `#{cmd}`
end

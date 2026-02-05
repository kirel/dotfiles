home_dir = Dir.home
OS_TYPE = `uname`.strip

# Files/folders to skip on Linux
LINUX_SKIP = [
  '.raycast',
  '.config/crush',
  '.gitconfig.work' # Usually only for my work mac
]

task :symlink do
  ext = '.symlink'
  Dir.glob("**/*#{ext}", File::FNM_DOTMATCH) do |path|
    # Skip certain files on Linux
    if OS_TYPE == 'Linux'
      base_name = File.basename(path, ext)
      next if LINUX_SKIP.any? { |skip| path.include?(skip) }
    end

    dotfile = "#{Dir.pwd}/#{path}"
    symlink = File.expand_path("#{home_dir}/#{(File.dirname path)}/#{File.basename(path, ext)}")
    
    # skip if it's the current directory or parent
    next if path == "." || path == ".."
    
    # delete symlink if exists
    FileUtils.rm_rf symlink
    FileUtils.mkdir_p File.dirname(symlink)
    FileUtils.ln_s dotfile, symlink, :force => true, :verbose => true
  end
end

task :dump do
  puts "Dumping Brewfiles..."
  tmp = "Brewfile.tmp"
  # Use sh to execute the shell command
  sh "brew bundle dump --force --file=#{tmp}"
  
  # Extract MAS entries and the mas CLI to Brewfile.mas
  # We use grep to filter lines. '^mas ' matches MAS apps, '^brew "mas"' matches the mas tool itself.
  sh "grep -E '^mas |^brew \"mas\"' #{tmp} > Brewfile.mas"
  
  # Put everything else into the main Brewfile
  sh "grep -vE '^mas |^brew \"mas\"' #{tmp} > Brewfile"
  
  rm tmp
  puts "Done! Split into Brewfile and Brewfile.mas"
end

task :default => :symlink


home_dir = Dir.home
OS_TYPE = `uname`.strip

# Files/folders to skip on Linux
LINUX_SKIP = [
  '.raycast',
  '.config/crush'
]

task :symlink do
  ext = '.symlink'

  Dir.glob("**/*#{ext}", File::FNM_DOTMATCH).sort.each do |path|
    # Skip if it's the current directory or parent
    next if path == "." || path == ".."

    # If a parent directory is already a *.symlink package, everything below it
    # is regular repo content and must not be symlinked again.
    parent_parts = File.dirname(path).split(File::SEPARATOR)
    next if parent_parts.any? { |part| part.end_with?(ext) }

    # Skip certain files on Linux
    if OS_TYPE == 'Linux'
      next if LINUX_SKIP.any? { |skip| path.include?(skip) }
    end

    dotfile = "#{Dir.pwd}/#{path}"
    symlink = File.expand_path("#{home_dir}/#{File.dirname(path)}/#{File.basename(path, ext)}")

    # delete symlink if exists
    FileUtils.rm_rf symlink
    FileUtils.mkdir_p File.dirname(symlink)
    FileUtils.ln_s dotfile, symlink, :force => true, :verbose => true
  end
end

task :dump do
  puts "Dumping Brewfiles..."
  tmp = "Brewfile.tmp"
  sh "brew bundle dump --force --file=#{tmp}"
  
  # Extract MAS entries to Brewfile.personal (since they are 'play' stuff now)
  sh "grep -E '^mas ' #{tmp} > Brewfile.personal.new || touch Brewfile.personal.new"
  # Append existing personal casks if they were in the dump (they will be)
  # This is tricky because we don't know which casks are personal vs base vs work automatically.
  # For now, let's just keep the split logic simple: 
  # 1. Everything that is currently in Brewfile.personal stays there.
  # 2. Everything that is currently in Brewfile.work stays there.
  # 3. New stuff goes to main Brewfile.
  
  puts "Manual cleanup may be required to move new casks between Brewfile, Brewfile.personal, and Brewfile.work."
  sh "grep -vE '^mas ' #{tmp} > Brewfile"
  
  # Append MAS to personal
  sh "cat Brewfile.personal.new >> Brewfile.personal"
  sh "sort -u Brewfile.personal -o Brewfile.personal"
  
  rm tmp Brewfile.personal.new
  puts "Done! MAS apps moved to Brewfile.personal. Casks/Brews are in Brewfile."
end

task :default => :symlink


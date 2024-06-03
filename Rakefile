home_dir = Dir.home

task :symlink do
  ext = '.symlink'
  Dir.glob("**/*#{ext}", File::FNM_DOTMATCH) do |path|
    # path = Dir.glob("**/*#{ext}", File::FNM_DOTMATCH).first
    # path = Dir.glob("**/*#{ext}", File::FNM_DOTMATCH).last
    dotfile = "#{Dir.pwd}/#{path}"
    symlink = File.expand_path("#{home_dir}/#{(File.dirname path)}/#{File.basename(path, ext)}")
    # delete symlink
    FileUtils.rm_rf symlink
    FileUtils.mkdir_p File.dirname(symlink) # Create intermediate directories if necessary
    FileUtils.ln_s dotfile, symlink, :force => true, :verbose => true
  end
end

task :default => :symlink


task :symlink do
  ext = '.symlink'
  Dir.glob("*#{ext}") do |path|
    dotfile = "#{Dir.pwd}/#{path}"
    symlink = "../.#{File.basename(path, ext)}"
    FileUtils.ln_s dotfile, symlink, :force => true, :verbose => true
  end
end

task :default => :symlink

task :symlink do
  ext = '.symlink'
  Dir.glob("*#{ext}") do |path|
    File.symlink("#{Dir.pwd}/#{path}", "../.#{File.basename(path, ext)}")
  end
end

task :default => :symlink

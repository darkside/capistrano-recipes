Capistrano::Configuration.instance(:must_exist).load do
  unless exists?(:config_files)
    set :config_files, 'database.yml'
  end
  
  namespace :symlink do
    desc <<-DESC
    Create shared directories. Specify which directories are shared via:
      set :shared_dirs, %w(avatars videos)
    DESC
    task :create_shared_dirs, :roles => :app do
      shared_dirs.each { |link| run "mkdir -p #{shared_path}/#{link}" } if shared_dirs
    end
    
    desc <<-DESC
    Create links to shared directories from current deployment's public directory.
    Specify which directories are shared via:
      set :shared_dirs, %w(avatars videos)
    DESC
    task :shared_directories, :roles => :app do
      shared_dirs.each do |link| 
        run "rm -rf #{release_path}/public/#{link}"
        run "ln -nfs #{shared_path}/#{link} #{release_path}/public/#{link}" 
      end if shared_dirs
    end
    
    desc <<-DESC
    Create links to config files stored in shared config directory.
    Specify which config files to link using the following:
      set :config_files, 'database.yml'
    DESC
    task :shared_config_files, :roles => :app do
      config_files.each do |file_path|
        begin
          run "#{sudo} rm #{config_path}#{file_path}"         
          run "#{sudo} ln -nfs #{shared_config_path}#{file_path} #{config_path}#{file_path}"
        rescue
          puts "Problem linking to #{file_path}. Be sure file already exists in #{shared_config_path}."
        end
      end if config_files
    end
  end
  
  def config_path
    "#{current_release}/config/"
  end
  
  def shared_config_path
    "#{shared_path}/config/"
  end
end
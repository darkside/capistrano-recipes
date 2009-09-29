Capistrano::Configuration.instance(:must_exist).load do
  namespace :symlink do
    
    desc <<-DESC
    Create shared directories
    DESC
    task :create_shared_dirs, :roles => :app do
      symlinks.each { |link| run "mkdir -p #{shared_path}/#{link}" } if symlinks
    end
    
    desc <<-DESC
    Create links to shared directories from current deployment's public directory
    DESC
    task :create_links, :roles => :app do
      symlinks.each { |link| 
        run "rm -rf #{release_path}/public/#{link}"
        run "ln -nfs #{shared_path}/#{link} #{release_path}/public/#{link}" 
      } if symlinks
    end
    
  end
end
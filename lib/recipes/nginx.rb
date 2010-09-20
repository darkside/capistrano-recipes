Capistrano::Configuration.instance(:must_exist).load do
    
  # Where your nginx lives. Usually /opt/nginx or /usr/local/nginx for source
  # compiled.
  set :nginx_path_prefix, "/opt/nginx" unless exists?(:nginx_path_prefix)

  # Path to the nginx erb template to be parsed before uploading to remote
  set(:nginx_local_config) { "#{templates_path}/nginx.conf.erb" } unless exists?(:nginx_local_config)

  # Path to where your remote config will reside (I use a directory sites inside conf)
  set(:nginx_remote_config) do
    "#{nginx_path_prefix}/conf/sites/#{application}.conf"
  end unless exists?(:nginx_remote_config)

  # Nginx tasks are not *nix agnostic, they assume you're using Debian/Ubuntu.
  # Override them as needed.
  namespace :nginx do
    
    desc "Parses and uploads nginx configuration for this app."
    task :setup, :roles => :app , :except => { :no_release => true } do
      generate_config(nginx_local_config, nginx_remote_config)
    end
    
    # [internal] Parses config file and outputs it to STDOUT
    task :parse, :roles => :app , :except => { :no_release => true } do
      puts parse_config(nginx_local_config)
    end
    
    desc "Restart nginx"
    task :restart, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx restart"
    end
    
    desc "Stop nginx"
    task :stop, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx stop"
    end
    
    desc "Start nginx"
    task :start, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx start"
    end

    desc "Show nginx status"
    task :status, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx status"
    end
    
  end
  
  after 'deploy:setup', 'nginx:setup' if is_using_nginx
    
end


Capistrano::Configuration.instance.load do

  # Where your nginx lives. Usually /opt/nginx or /usr/local/nginx for source compiled.
  set :nginx_path_prefix, "/opt/nginx" unless exists?(:nginx_path_prefix)

  # Path to the nginx erb template to be parsed before uploading to remote
  set(:nginx_local_config) { "#{templates_path}/nginx.conf.erb" } unless exists?(:nginx_local_config)

  # Init scripts
  set(:nginx_init_local) { "#{docs_path}/nginx/nginx.init" }
  set :nginx_init_temp,   '/tmp/nginx.init'
  set :nginx_init_remote, '/etc/init.d/nginx'

  # Path to where your remote config will reside (I use a directory sites inside conf)
  set(:nginx_remote_config) do
    "#{nginx_path_prefix}/conf/sites/#{application}.conf"
  end unless exists?(:nginx_remote_config)

  # Nginx tasks are not *nix agnostic, they assume you're using Debian/Ubuntu.
  # Override them as needed.
  namespace :nginx do
    desc "|capistrano-recipes| Parses and uploads nginx configuration for this app."
    task :setup, :roles => :app , :except => { :no_release => true } do
      generate_config(nginx_local_config, nginx_remote_config)
    end

    desc "|capistrano-recipes| Bootstraps Nginx to init.d"
    task :setup_init, :roles => :app do
      upload nginx_init_local, nginx_init_temp, :via => :scp
      sudo "mv #{nginx_init_temp} #{nginx_init_remote}"
      # Allow executing the init.d script
      sudo "chmod +x #{nginx_init_remote}"
      # Make it run at bootup
      sudo "update-rc.d nginx defaults"
    end

    desc "|capistrano-recipes| Parses config file and outputs it to STDOUT (internal task)"
    task :parse, :roles => :app , :except => { :no_release => true } do
      puts parse_config(nginx_local_config)
    end

    desc "|capistrano-recipes| Restart nginx"
    task :restart, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx restart"
    end

    desc "|capistrano-recipes| Stop nginx"
    task :stop, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx stop"
    end

    desc "|capistrano-recipes| Start nginx"
    task :start, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx start"
    end

    desc "|capistrano-recipes| Show nginx status"
    task :status, :roles => :app , :except => { :no_release => true } do
      sudo "service nginx status"
    end
  end

  after 'deploy:setup' do
    nginx.setup if Capistrano::CLI.ui.agree("Create nginx configuration file? [Yn]")
  end if is_using_nginx
end


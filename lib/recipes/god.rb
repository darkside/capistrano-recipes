# God Monitoring Tool
# God is a Process Monitoring Framework written in Ruby
# More info at http://god.rubyforge.org/
#------------------------------------------------------------------------------
Capistrano::Configuration.instance(:must_exist).load do
  _cset(:god_local_config)  { "#{templates_path}/app.god.erb" }
  _cset(:god_remote_config) { "#{shared_path}/config/app.god" }

  namespace :god do
    
    desc "Parses and uploads god configuration for this app"
    task :setup do
      generate_config(god_local_config, god_remote_config)
    end

    _cset(:bin_god) { defined?(:rvm_ruby_string) ? 'bootup_god' : 'god' }
    _cset(:server_name)    { "#{application}-unicorn" }
    _cset(:god_init_local) { "#{docs_path}/god/god.init" }
    _cset :god_init_temp,   '/tmp/god.init'
    _cset :god_init_remote, '/etc/init.d/god'
    _cset(:god_defo_local) { "#{docs_path}/god/god"}
    _cset :god_defo_temp,   '/tmp/god'
    _cset :god_defo_remote, '/etc/default/god'
    _cset(:god_conf_local) { "#{docs_path}/god/god.conf" }
    _cset :god_conf_temp,   '/tmp/god.conf'
    _cset :god_conf_remote, '/etc/god/god.conf'
    
    
    task :setup_temp, :roles => :app do
      sudo "rm -f #{god_conf_remote} #{god_init_remote} #{god_defo_remote}"
    end
    
    task :setup_conf, :roles => :app do
      upload god_conf_local, god_conf_temp, :via => :scp
      sudo "mkdir -p #{File.dirname(god_conf_remote)}"
      sudo "mv #{god_conf_temp} #{god_conf_remote}"
    end
    
    task :setup_init, :roles => :app do
      upload god_init_local, god_init_temp, :via => :scp
      sudo "mv #{god_init_temp} #{god_init_remote}"  
      # Allow executing the init.d script
      sudo "chmod +x #{god_init_remote}"
      # Make it run at bootup     
      sudo "update-rc.d god defaults"    
    end
    
    task :setup_defo, :roles => :app do
      upload god_defo_local, god_defo_temp, :via => :scp
      sudo "mv #{god_defo_temp} #{god_defo_remote}"
    end
    
    desc "Bootstraps god on your server. Be careful with this."
    task :bootstrap, :roles => :app do
      setup_temp
      setup_defo
      setup_init
      setup_conf    

      puts "God is bootstrapped. To remove use 'cap god:implode'"
    end
    
    desc "(Seppuku) Completely remove god from the system init"
    task :implode, :roles => :app do
      #  Removing any system startup links for /etc/init.d/god ...
      sudo "update-rc.d -f god remove"
      
      # Suicide follows.
      sudo "rm -f #{god_conf_remote}"
      sudo "rm -f #{god_defo_remote}"
      sudo "rm -f #{god_init_remote}"
      puts "God is no more."
    end
    
    task :restart_unicorn, :roles => :app do
      sudo "#{bin_god} restart #{server_name}"
    end
    
    task :log, :roles => :app do
      sudo "#{bin_god} log #{application}"
    end
    
    desc "Reload config"
    task :reload, :roles => :app do
      sudo "#{bin_god} load #{god_remote_config}"
    end

    desc "Start god service"
    task :start, :roles => :app do
      sudo "service god start"
    end
    
    desc "Stops god service"
    task :stop, :roles => :app do
      sudo "service god stop"
    end
        
    desc "Quit god, but not the processes it's monitoring"
    task :quit, :roles => :app do
      sudo "#{bin_god} quit"
    end

    desc "Terminate god and all monitored processes"
    task :terminate, :roles => :app do
      sudo "#{bin_god} terminate"
    end

    desc "Describe the status of the running tasks"
    task :status, :roles => :app do
      sudo "#{bin_god} status"
    end
  end
  after 'deploy:setup', 'god:setup' if is_using_god
end

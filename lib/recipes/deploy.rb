Capistrano::Configuration.instance(:must_exist).load do
  set :shared_children, %w(system log pids config)

  after "deploy:setup" do
    db.create_yaml if Capistrano::CLI.ui.agree("Create database.yml in app's shared path?")  
  end
  
  
  namespace :deploy do
    desc "Deploy it, github-style."
    task :default do
      update
      restart
    end
    
    desc "[Seppuku] Destroy everything"
    task :seppuku do
      run "rm -rf #{current_path}; rm -rf #{shared_path}"
      rubycas.seppuku
    end
    
     task :setup_dirs, :except => { :no_release => true } do
      commands = shared_dirs.map do |path|
        "mkdir -p #{shared_path}/#{path}"
      end
      run commands.join(" && ")
    end
    
    desc "Uploads your local config.yml to the server"
    task :configure, :except => { :no_release => true } do
      generate_config('config/config.yml', "#{shared_path}/config/config.yml")
    end
    
    desc "Setup a GitHub-style deployment."
    task :setup, :except => { :no_release => true } do
      run "rm -rf #{current_path}"
      setup_dirs
      run "git clone #{repository} #{current_path}"
    end
    
    desc "Update the deployed code."
    task :update_code, :except => { :no_release => true } do
      run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    end

    task :symlink, :except => { :no_release => true } do
      symlinks.make
    end

    desc "[Obsolete] Nothing to cleanup when using reset --hard on git"
    task :cleanup, :except => { :no_release => true } do
      #nothing to cleanup, we're not working with 'releases'
      puts "Nothing to cleanup, yay!"
    end

    namespace :rollback do
      desc "Rollback a single commit."
      task :default, :except => { :no_release => true } do
        set :branch, "HEAD^"
        deploy.default
      end    
    end

    desc <<-DESC
      Restarts your application. This depends heavily on what server you're running. 
      If you are running Phusion Passenger, you can explicitly set the server type:
      
        set :server, :passenger
          
      ...which will touch tmp/restart.txt, a file monitored by Passenger.

      If you are running Unicorn, you can set:
      
        set :server, :unicorn
      
      ...which will use unicorn signals for restarting its workers.

      Otherwise, this command will call the script/process/reaper \
      script under the current path.
      
      If you are running with Unicorn, you can set the server type as well:
      
      set :server, :unicorn

      By default, this will be invoked via sudo as the `app' user. If \
      you wish to run it as a different user, set the :runner variable to \
      that user. If you are in an environment where you can't use sudo, set \
      the :use_sudo variable to false:

        set :use_sudo, false
    DESC
    task :restart, :roles => :app, :except => { :no_release => true } do
      if exists?(:server)
        case fetch(:server).to_s.downcase
          when 'passenger'
            passenger.bounce
          when 'unicorn'
            is_using_god ? god.restart_unicorn : unicorn.restart
        end
      else
        puts "Dunno how to restart your internets! kthx!"
      end
    end
  end
end

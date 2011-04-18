Capistrano::Configuration.instance.load do
  namespace :resque do  
    namespace :worker do
      desc "|capistrano-recipes| List all workers"
      task :list, :roles => :app do
        run "cd #{current_path} && #{sudo} resque list"
      end
    
      desc "|capistrano-recipes| Starts the workers"
      task :start, :roles => :app do
        run "cd #{current_path} && #{sudo} god start #{resque_service}"
      end
    
      desc "|capistrano-recipes| Stops the workers"
      task :stop, :roles => :app do
        run "cd #{current_path} && #{sudo} god stop #{resque_service}"
      end
    
      desc "|capistrano-recipes| Restart all workers"
      task :restart, :roles => :app do
        run "cd #{current_path} && #{sudo} god restart #{resque_service}"
      end  
    end
  
    namespace :web do
      desc "|capistrano-recipes| Starts the resque web interface"
      task :start, :roles => :app do
        run "cd #{current_path}; resque-web -p 9000 -e #{rails_env} "
      end
    
      desc "|capistrano-recipes| Stops the resque web interface"
      task :stop, :roles => :app do
        run "cd #{current_path}; resque-web -K"
      end
    
      desc "|capistrano-recipes| Restarts the resque web interface "
      task :restart, :roles => :app do
        stop
        start
      end
    
      desc "|capistrano-recipes| Shows the status of the resque web interface"
      task :status, :roles => :app do
        run "cd #{current_path}; resque-web -S"
      end 
    end
  end
end
Capistrano::Configuration.instance.load do  
  namespace :bluepill do
    desc "|DarkRecipes| Install the bluepill monitoring tool"
    task :install, :roles => [:app] do
      sudo "gem install bluepill"
    end
    
    desc "|DarkRecipes| Stop processes that bluepill is monitoring and quit bluepill"
    task :quit, :roles => [:app] do
      args = options || ""
      begin
        sudo "bluepill stop #{args}"
      rescue
        puts "Bluepill was unable to finish gracefully all the process"
      ensure
        sudo "bluepill quit"
      end
    end
    
    desc "|DarkRecipes| Load the pill from {your-app}/config/pills/{app-name}.pill"
    task :init, :roles =>[:app] do
      sudo "bluepill load #{current_path}/config/pills/#{application}.pill"
    end
 
    desc "|DarkRecipes| Starts your previous stopped pill"
    task :start, :roles =>[:app] do
      args = options || ""
      sudo "bluepill start #{args}"
    end
    
    desc "|DarkRecipes| Stops some bluepill monitored process"
    task :stop, :roles =>[:app] do
      args = options || ""
      sudo "bluepill stop #{args}"
    end
    
    desc "|DarkRecipes| Restarts the pill from {your-app}/config/pills/{app-name}.pill"
    task :restart, :roles =>[:app] do
      args = options || ""
      sudo "bluepill restart #{args}"
    end
 
    desc "|DarkRecipes| Prints bluepills monitored processes statuses"
    task :status, :roles => [:app] do
      args = options || ""
      sudo "bluepill status #{args}"
    end
  end
    
  after 'deploy:setup' do
    bluepill.install if Capistrano::CLI.ui.agree("Do you want to install the bluepill monitor? [Yn]")
  end if is_using('bluepill', :monitorer)
end
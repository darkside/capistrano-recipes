Capistrano::Configuration.instance.load do
  namespace :passenger do
    desc "|DarkRecipes| Restart Rails app running under Phusion Passenger by touching restart.txt"
    task :bounce, :roles => :app do
      run "#{sudo} touch #{current_path}/tmp/restart.txt"
    end

    desc "|DarkRecipes| Inspect Phusion Passenger's memory usage."
    task :memory, :roles => :app do
      run "sudo passenger-memory-stats"
    end
        
    desc "|DarkRecipes| Inspect Phusion Passenger's internal status."
    task :status, :roles => :app do
      run "sudo passenger-status"
    end
  end
end
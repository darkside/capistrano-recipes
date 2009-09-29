Capistrano::Configuration.instance(:must_exist).load do
  namespace :passenger do
    
    desc "Restart Rails app running under Phusion Passenger by touching restart.txt"
    task :bounce, :roles => :app do
      run "#{sudo} touch #{current_path}/tmp/restart.txt"
    end

    desc "Inspect Phusion Passenger's memory usage. Assumes binaries are located in /opt/ruby-enterprise."
    task :memory, :roles => :app do
      run "#{sudo} /opt/ruby-enterprise/bin/passenger-memory-stats"
    end
        
    desc "Inspect Phusion Passenger's internal status. Assumes binaries are located in /opt/ruby-enterprise."
    task :status, :roles => :app do
      run "#{sudo} /opt/ruby-enterprise/bin/passenger-status"
    end
    
  end
end
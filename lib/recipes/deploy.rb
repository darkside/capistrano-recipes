Capistrano::Configuration.instance(:must_exist).load do
  set :shared_children, %w(system log pids config)

  after "deploy:setup" do
    db.create_yaml if Capistrano::CLI.ui.agree("Create database.yml in app's shared path?")  
  end
  
  
  namespace :deploy do
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
            unicorn.restart
        end
      else
        try_runner "#{current_path}/script/process/reaper"
      end
    end
  end
end

Capistrano::Configuration.instance.load do
  namespace :bundler do
    desc "|capistrano-recipes| Installs bundler gem to your server"
    task :setup, :roles => :app do
      run "if ! gem list | grep --silent -e 'bundler'; then #{try_sudo} gem uninstall bundler; #{try_sudo} gem install --no-rdoc --no-ri bundler; fi"
    end
    
    desc "|capistrano-recipes| Runs bundle install on the app server (internal task)"
    task :install, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && bundle install --deployment --without=development test"
    end
  end
end


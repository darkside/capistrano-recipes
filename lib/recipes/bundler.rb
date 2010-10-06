# Bundler
# Manages gems in a sane way.
# http://gembundler.com/
Capistrano::Configuration.instance(:must_exist).load do
  namespace :bundler do
    set :bundler_ver, '1.0.0'
    desc "Installs bundler gem to your server"
    task :setup, :roles => :app do
      run "if ! gem list | grep --silent -e 'bundler.*#{bundler_ver}'; then #{try_sudo} gem uninstall bundler; #{try_sudo} gem install --no-rdoc --no-ri bundler; fi"
    end
    
    # [internal] runs bundle install on the app server
    task :install, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && bundle install --deployment"
    end
  end  
    
end


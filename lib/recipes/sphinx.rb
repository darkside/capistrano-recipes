Capistrano::Configuration.instance.load do
  namespace :sphinx do
    desc "|DarkRecipes| Generates Configuration file for TS"
    task :config, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:config"
    end
 
    desc "|DarkRecipes| Starts TS"
    task :start, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:start"
    end
 
    desc "|DarkRecipes| Stops TS"
    task :stop, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:stop"
    end
 
    desc "|DarkRecipes| Rebuild TS"
    task :rebuild, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:rebuild"
    end
 
    desc "|DarkRecipes| Indexes TS"
    task :index, :roles => :app do
      run "cd #{current_path}; #{rake_bin} RAILS_ENV=#{rails_env} ts:in"
    end
   
    desc "|DarkRecipes| Re-establishes symlinks"
    task :symlinks do
      run <<-CMD
        rm -rf #{current_path}/db/sphinx && ln -nfs #{shared_path}/db/sphinx #{current_path}/db/sphinx
      CMD
    end
  end
  
  after "deploy:migrate" do 
    sphinx.rebuild
  end unless is_app_monitored?
end
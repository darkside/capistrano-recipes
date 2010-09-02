Capistrano::Configuration.instance(:must_exist).load do

  # User settings
  set :user, 'deploy'   unless exists?(:user)
  set :group,'www-data' unless exists?(:group)
  
  
  # Server settings
  set :server, :unicorn unless exists?(:server)
  set :runner, user     unless exists?(:runner)
  
  # Database settings
  set :database, :mysql unless exists?(:database)
  
  # SCM settings
  set :scm, :git
  set :branch, 'master' unless exists?(:branch)
  set :deploy_to, "/var/www/apps/#{application}" unless exists?(:deploy_to)
  set :deploy_via, :remote_cache
  set :keep_releases, 3
  set :git_enable_submodules, true
  set :rails_env, 'production' unless exists?(:rails_env)
  set :use_sudo, false

  # Git settings for capistrano
  default_run_options[:pty] = true 
  ssh_options[:forward_agent] = true
end

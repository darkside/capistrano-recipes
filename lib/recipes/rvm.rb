Capistrano::Configuration.instance.load do
  # RVM settings
  set :using_rvm, true unless exists?(:using_rvm)
  
  if defined?(using_rvm) && using_rvm
    $:.unshift(File.expand_path('./lib', ENV['rvm_path']))  # Add RVM's lib directory to the load path.
    require "rvm/capistrano"                                # Load RVM's capistrano plugin.
    
    # Sets the rvm to a specific version (or whatever env you want it to run in)
    set :rvm_ruby_string, 'ree' unless exists?(:rvm_ruby_string)
  end
end

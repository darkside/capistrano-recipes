# RVM jazz
#------------------------------------------------------------------------------
Capistrano::Configuration.instance(:must_exist).load do
  if defined?(using_rvm) && using_rvm
    # Add RVM's lib directory to the load path.
    $:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 

    # Load RVM's capistrano plugin.
    require "rvm/capistrano"
  end
end

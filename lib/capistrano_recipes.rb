require 'capistrano'
require 'capistrano/cli'
require 'capistrano/ext/multistage'
require 'yaml'
require 'helpers'

@@cap_config = Capistrano::Configuration.respond_to?(:instance) ? 
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)
  
Dir.glob(File.join(File.dirname(__FILE__), '/recipes/*.rb')).each { |f| load f }
require 'capistrano'
require 'capistrano/cli'
require 'capistrano/ext/multistage'
require 'helpers'

Dir.glob(File.join(File.dirname(__FILE__), '/recipes/*.rb')).each { |f| load f }
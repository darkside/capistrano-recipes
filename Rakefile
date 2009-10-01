require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "capistrano-recipes"
    gem.summary = %Q{Capistrano recipes}
    gem.description = 'Extend the Capistrano gem with these useful recipes'
    gem.email = "phil@webficient.com"
    gem.homepage = "http://github.com/webficient/capistrano-recipes"
    gem.authors = ["Phil Misiowiec"]
    gem.add_dependency('capistrano', ['>= 2.5.9'])
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'capistrano-recipes'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
# Common hooks for all scenarios.
Capistrano::Configuration.instance.load do
  after 'deploy:setup' do
    app.setup
    bundler.setup if Capistrano::CLI.ui.agree("Do you need to install the bundler gem? [Yn]")
  end
    
  after "deploy:update_code" do
    symlinks.make
    bundler.install
  end
end



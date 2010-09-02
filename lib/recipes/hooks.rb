Capistrano::Configuration.instance(:must_exist).load do
  after 'deploy:setup' do
    app.setup
    bundler.setup
  end
    
  after "deploy:update_code" do
    symlinks.make
    bundler.install
    deploy.cleanup
  end
end



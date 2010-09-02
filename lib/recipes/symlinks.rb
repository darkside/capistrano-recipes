Capistrano::Configuration.instance(:must_exist).load do
  # These are set to the same structure in shared <=> current
  set :normal_symlinks, %w(
    config/database.yml
  ) unless exists?(:normal_symlinks)
  
  # Weird symlinks go somewhere else. Weird.
  set :weird_symlinks, {
     'bundle' => 'vendor/bundle'
  } unless exists?(:weird_symlinks)

  namespace :symlinks do
    desc "Make all the damn symlinks in a single run"
    task :make, :roles => :app, :except => { :no_release => true } do
      commands = normal_symlinks.map do |path|
        "rm -rf #{release_path}/#{path} && \
         ln -s #{shared_path}/#{path} #{release_path}/#{path}"
      end

      commands += weird_symlinks.map do |from, to|
        "rm -rf #{release_path}/#{to} && \
         ln -s #{shared_path}/#{from} #{release_path}/#{to}"
      end


      run <<-CMD
        cd #{release_path} &&
        #{commands.join(" && ")}
      CMD
    end
  end
  
end

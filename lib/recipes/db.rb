require 'erb'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :db do
    namespace :mysql do
      desc "Create MySQL database and user for this environment using prompted values"
      task :setup, :roles => :db, :only => { :primary => true } do
        prepare_for_db_command

        sql = <<-SQL
        CREATE DATABASE #{db_name};
        GRANT ALL PRIVILEGES ON #{db_name}.* TO #{db_user}@localhost IDENTIFIED BY '#{db_pass}';
        SQL

        run "mysql --user=#{db_admin_user} -p --execute=\"#{sql}\"" do |channel, stream, data|
          if data =~ /^Enter password:/
            pass = Capistrano::CLI.password_prompt "Enter database password for '#{db_admin_user}':"
            channel.send_data "#{pass}\n" 
          end
        end
      end      
    end
    
    desc "Create database.yml in shared path with settings for current stage and test env"
    task :create_yaml do      
      set(:db_user) { Capistrano::CLI.ui.ask "Enter #{stage} database username:" }
      set(:db_pass) { Capistrano::CLI.password_prompt "Enter #{stage} database password:" }
      
      db_config = ERB.new <<-EOF
      base: &base
        adapter: mysql
        username: #{db_user}
        password: #{db_pass}

      #{stage}:
        database: #{application}_#{stage}
        <<: *base

      test:
        database: #{application}_test
        <<: *base
      EOF

      put db_config.result, "#{shared_path}/config/database.yml"
    end
      
    desc "Create symlink for database yaml stored in shared path" 
    task :symlink do
      run "#{sudo} ln -nfs #{shared_path}/config/database.yml #{current_release}/config/database.yml" 
    end
  end
    
  def prepare_for_db_command
    set :db_name, "#{application}_#{stage}"
    set(:db_admin_user) { Capistrano::CLI.ui.ask "Username with priviledged database access (to create db):" }
    set(:db_user) { Capistrano::CLI.ui.ask "Enter #{stage} database username:" }
    set(:db_pass) { Capistrano::CLI.password_prompt "Enter #{stage} database password:" }
  end
end
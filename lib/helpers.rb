# =========================================================================
# These are helper methods that will be available to your recipes.
# =========================================================================

# automatically sets the environment based on presence of 
# :stage (multistage gem), :rails_env, or RAILS_ENV variable; otherwise defaults to 'production'
def environment  
  if exists?(:stage)
    stage
  elsif exists?(:rails_env)
    rails_env  
  elsif(ENV['RAILS_ENV'])
    ENV['RAILS_ENV']
  else
    "production"  
  end
end

# Execute a rake task, example:
#   run_rake log:clear
def run_rake(task)
  run "cd #{current_path} && rake #{task} RAILS_ENV=#{environment}"
end
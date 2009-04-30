# =========================================================================
# These are helper methods that will be available to your recipes.
# =========================================================================

# Execute a rake task, example:
#   run_rake log:clear
def run_rake(task)
  run "cd #{current_path} && rake #{task} RAILS_ENV=#{stage}"
end
namespace :node do
  def remote_link_exists?(full_path)
  results = []
  invoke_command("if [ -L '#{full_path}' ]; then echo -n 'true'; fi") do |ch, stream, out|
    results << (out == 'true')
  end
  results == [true]
end
  # Override the upstart config to avoid needing to do sudo
  #  1. check that a symlink to the upstart file exists instead
  #  2. only update the upstart_config file in the shared folder.
  task :check_upstart_config do
    # Create/update the config file if it is different
    create_upstart_config if remote_file_differs?(temp_config_file_path, upstart_file_contents)
    # Make sure that the file is symlinked from upstart_file_path
    symlink_upstart_config unless remote_link_exists?(upstart_file_path)
  end
  set :temp_config_file_path, lambda { "#{shared_path}/#{application}.conf" }
  desc "Create upstart script for this node app"
  task :create_upstart_config do

    # Generate and upload the upstart script
    put upstart_file_contents, temp_config_file_path

    # Copy the script into place and make executable
    # sudo "cp #{temp_config_file_path} #{upstart_file_path}"
  end

  task :symlink_upstart_config do
    "ln -s #{temp_config_file_path} #{upstart_file_path}"
  end

  # desc "Start the node application"
  # task :start do
  #   "start #{upstart_job_name}"
  # end

  # desc "Stop the node application"
  # task :stop do
  #   "stop #{upstart_job_name}"
  # end

  # desc "Restart the node application"
  # task :restart do
  #   "stop #{upstart_job_name}; true"
  #   "start #{upstart_job_name}"
  # end


end

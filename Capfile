# load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
# load 'config/deploy' # remove this line to skip loading any of the default tasks

require "capistrano/node-deploy"
require "capistrano/shared_file"

load "config/recipes/override_upstart_file"

set :use_sudo, false

set :application, "blog"
set :user, "joshuaballoch"
set :deploy_to, "/var/www/blog"

set :node_user, "deploy"
set :node_env, "production"

set :scm, :git
set :repository,  "https://github.com/joshuaballoch/ghost-blog.git"
set :deploy_via, :rsync_with_remote_cache

role :app, "162.243.109.240"
role :web, "162.243.109.240"
role :db, "162.243.109.240"

set :shared_files,    ["config.js"]
set :shared_children, ["content/data", "content/images"]

set :keep_releases, 5

namespace :deploy do
  task :mkdir_shared do
    run "cd #{shared_path} && mkdir -p data images files"
  end
end

after "deploy:create_symlink", "deploy:mkdir_shared"

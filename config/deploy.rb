set :application, "albums"
set :repository,  "git://github.com/clifff/albums_of_the_year.git"
set :scm, :git

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "104.236.51.131"
set :user, "albums"
set :deploy_to, "/home/albums"

# TODO: not this
set :use_sudo, false
default_run_options[:pty] = true

set :deploy_via, :remote_cache

set :rails_env, 'production'

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path} && fig up -d -f fig-production.yml"
  end
  task :stop, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path} && fig stop -f fig-production.yml"
  end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "cd #{current_path} && fig restart -f fig-production.yml"
  end
end

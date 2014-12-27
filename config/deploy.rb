set :application, "albums"
set :repository,  "git://github.com/clifff/albums_of_the_year.git"
set :scm, :git

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "104.236.51.131"
set :user, "albums"
set :deploy_to, "/home/albums"
set :branch, `git branch  | awk '$1 ~ /\\*/ {print $2}'`.strip

# TODO: not this
set :use_sudo, false
default_run_options[:pty] = true

set :deploy_via, :remote_cache

set :rails_env, 'production'
set :fig_file, "#{release_path}/fig-production.yml"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :build, :roles => :web, :except => { :no_release => true } do
    sudo "sh -c 'cd #{release_path} && fig -f #{fig_file} build'"
  end
  task :start, :roles => :web, :except => { :no_release => true } do
    build
    sudo "sh -c 'cd #{release_path} && fig -f #{fig_file} up -d'"
  end
  task :stop, :roles => :web, :except => { :no_release => true } do
    sudo "sh -c 'cd #{release_path} && fig -f #{fig_fiel} stop'"
  end
  task :restart, :roles => :web, :except => { :no_release => true } do
    build
    sudo "sh -c 'cd #{release_path} && fig -f #{fig_file} restart'"
  end
end

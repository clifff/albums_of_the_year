require "bundler/capistrano"

set :application, "albums"
set :repository,  "git://github.com/clifff/albums_of_the_year.git"
set :scm, :git

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "linode"
set :user, "albums"
set :deploy_to, "/home/albums"

# TODO: not this
set :use_sudo, true
default_run_options[:pty] = true

set :deploy_via, :remote_cache

set :rails_env, 'production'
set :unicorn_binary, "bundle exec unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start, :roles => :web, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
    run "cd #{current_path} && #{try_sudo} bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -f ./Procfile.production"
    run "cd #{current_path} && #{try_sudo} start #{application}"
  end
  task :stop, :roles => :web, :except => { :no_release => true } do 
    run " kill `cat #{unicorn_pid}`"
    run "cd #{current_path} && #{try_sudo} stop #{application}"
  end
  task :graceful_stop, :roles => :web, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
    run "cd #{current_path} && #{try_sudo} stop #{application}"
  end
  task :reload, :roles => :web, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
    run "cd #{current_path} && #{try_sudo} stop #{application}"
    run "cd #{current_path} && #{try_sudo} start #{application}"
  end
  task :restart, :roles => :web, :except => { :no_release => true } do
    stop
    start
  end
end

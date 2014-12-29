require 'shellwords'

set :application, "albums"
set :repository,  "git://github.com/clifff/albums_of_the_year.git"
set :scm, :git

# PROBLEM: If we use the normal shared directories (tmp/pids, log, public/system)
# than we run into permission/existence problems when the container looks in these places,
# because it has symlinks pointing to things that didn't get mounted. So instead,
# share nothing between containers
set :shared_children, []

role :web, "104.236.51.131"
set :user, "albums"
set :deploy_to, "/home/albums"
set :branch, `git branch  | awk '$1 ~ /\\*/ {print $2}'`.strip

set :use_sudo, true
default_run_options[:pty] = true

set :deploy_via, :remote_cache

set :rails_env, 'production'
set :fig_file, "fig-production.yml"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :build, :roles => :web, :except => { :no_release => true } do
    sudo "sh -c 'cd #{latest_release} && fig -f #{fig_file} build'"
    sudo "sh -c 'cd #{latest_release} && fig -f #{fig_file} run web bundle exec rake assets:precompile RAILS_ENV=production'"
  end
  task :start, :roles => :web, :except => { :no_release => true } do
    build
    sudo "sh -c 'cd #{latest_release} && fig -f #{fig_file} up -d'"
  end
  task :stop, :roles => :web, :except => { :no_release => true } do
    # Force a sudo command so that capture doesn't later try to
    # ask for the password
    sudo("pwd")
    # PROBLEM: When we specify a fig file, things like stop/ps/log ONLY look
    # at the docker instances particular to that exact path, so instances created
    # by previous releases don'ts how up. As such, we can't JUST 'fig stop' and
    # try this instead
    containers =  capture("sudo -p 'sudo password: ' sh -c 'docker ps -q'").split("\r")
    containers.each do |container|
      container = container.strip
      next if container.nil? || container == ""
      sudo("sh -c 'docker stop #{container}'")
    end
  end
  task :restart, :roles => :web, :except => { :no_release => true } do
    stop
    start
  end
end

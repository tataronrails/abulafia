require "bundler/capistrano"
require "rvm/capistrano"
require 'capistrano/ext/multistage'
#require "whenever/capistrano"
require 'hipchat/capistrano'
require "delayed/recipes"

set :application,   "abulafia"
#set :repository,    "git@bitbucket.org:almazom/abulafia.git"
set :repository,    "git@github.com:tataronrails/abulafia.git"
set :rails_env,     :production
set :deploy_via,    :remote_cache # :checkout
set :shared_files,  %w(config/database.yml config/keys.yml config/email.yml)

set :rvm_ruby_string, "1.9.3@e-office"
set :use_sudo, false

set :stages, %w(edge production)
set :default_stage, 'edge'

#set :default_stage, 'production'

#set :whenever_command, "bundle exec whenever"

default_run_options[:pty]   = true
ssh_options[:forward_agent] = true

set :scm, :git
set :git_shallow_clone, 1
set :group_writable, false
#
set :hipchat_token, "94ecc0337c81806c0d784ab0352ee7"
set :hipchat_room_name, "abulafia"
set :hipchat_announce, false
set :hipchat_color, 'green'
set :hipchat_failed_color, 'red'

namespace :deploy do
  task :start do ; end
  task :stop  do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "touch #{File.join(current_path, "tmp/restart.txt")}"
    #run "touch #{File.join(current_path, "thin stop -p7004 && thin start -p7004 -e production -d")}"
  end

  desc "Restart the Thin processes"
  task :restart do
    run <<-CMD
      cd ~/www/apps/#{application}_#{branch}/current; bundle exec thin stop -p#{thin_port} && bundle exec thin start -p#{thin_port} -e production -d
    CMD
  end

  task :update_shared_symlinks do
    shared_files.each do |path|
      run "rm -rf #{File.join(release_path, path)}"
      run "ln -s #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
    end
  end

  namespace :db do
    task :create do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake db:create"
    end
  end
end

namespace :logs do
  task :watch do
    stream("tail -f #{shared_path}/log/#{rails_env}.log")
  end
end

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

before 'deploy:migrate', 'deploy:db:create'

#before "deploy:assets:precompile" do
#  run ["ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml",
#       "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml",
#       "ln -fs #{shared_path}/uploads #{release_path}/uploads"
#      ].join(" && ")
#end


after  "deploy:finalize_update", "deploy:update_shared_symlinks"
after  "deploy", "deploy:cleanup"


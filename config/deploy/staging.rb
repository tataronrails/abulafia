set :domain,        "edge.iq300.ru"
set :hostingserver, "46.4.91.186"
set :port,          2287
set :user,          "almazom"
set :branch,        "dev"
set :rails_env,     :staging

set :scm_username, user
set :runner, user
set :deploy_to,     "/home/#{user}/www/apps/#{application}"

set :rvm_type, :user
set :rvm_ruby_string, "1.9.3@iq300"

role :app, hostingserver
role :web, hostingserver
role :db,  hostingserver, :primary => true

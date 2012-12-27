set :domain,        "abulafia"
set :hostingserver, "46.4.91.186"
set :port,          2287
set :user,          "almazom"
set :branch,        "master"

set :scm_username, user
set :runner, user
set :deploy_to,     "/home/#{user}/www/apps/abu_production"

set :rvm_type, :user
set :rvm_ruby_string, "1.9.3@_abulafia_production"

role :app, hostingserver
role :web, hostingserver
role :db,  hostingserver, :primary => true

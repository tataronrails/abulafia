set :domain,        "new.iq300.ru"
set :hostingserver, "178.207.18.182"
set :port,          16543
set :user,          "iq300"
set :branch,        "stable"

set :scm_username, user
set :runner, user
set :deploy_to,     "/var/www/v3.iq300.ru/www/apps/#{application}"

set :rvm_type, :system

role :app, hostingserver
role :web, hostingserver
role :db,  hostingserver, :primary => true

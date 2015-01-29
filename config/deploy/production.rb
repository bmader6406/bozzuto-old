set :application,   'bozzuto'
set :user,          'deploy'
set :deploy_to,     "/var/www/#{application}/production"
set :branch,        'origin/production'
set :slack_app_url, 'http://bozzuto.com'

role :web, '54.215.11.223:8022'
role :app, '54.215.11.223:8022'
role :db,  '54.215.11.223:8022', :primary => true

after 'deploy', 'refresh_sitemaps'

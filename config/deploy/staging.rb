set :user,          'www-data'
set :branch,        'staging'
set :slack_app_url, 'http://bozzuto.staging.vigetx.com'

server 'bozzuto.staging.vigetx.com', :web, :app, :db, :resque_worker, primary: true

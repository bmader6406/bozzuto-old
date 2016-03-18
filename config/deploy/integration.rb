set :user,          'www-data'
set :branch,        'master'
set :slack_app_url, 'http://bozzuto.integration.vigetx.com'

server 'bozzuto.integration.vigetx.com', :web, :app, :db, :resque_worker, primary: true

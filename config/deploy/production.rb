set :user,          'deploy'
set :branch,        'production'
set :slack_app_url, 'http://bozzuto.com'

server '54.215.11.223:8022', :web, :app, :db, :resque_worker, primary: true

after 'deploy', 'refresh_sitemaps'

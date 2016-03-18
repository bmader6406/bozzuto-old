set :user,          'deploy'
set :branch,        'modernization'
set :slack_app_url, 'http://bozzuto.modernization.vigetx.com'

server '52.86.2.232', :web, :app, :db, :resque_worker, primary: true

set :user,          'deploy'
set :repository,    'git@code.qburst.com:BozzutoGroup/bozzuto.git'
set :branch,        'master'

set :deploy_to,     '/var/www/bozzuto/develop'

server '34.210.34.154', :web, :app, :db, :resque_worker, primary: true, port: 8022

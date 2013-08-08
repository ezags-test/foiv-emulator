set :branch, ENV['BRANCH'] || 'develop'
set :rails_env, ENV['rails_env'] || ENV['RAILS_ENV'] || 'develop'
server '192.168.24.87', :app, :web, :db, primary: true

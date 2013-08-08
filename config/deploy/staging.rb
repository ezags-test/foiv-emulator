require File.expand_path '../../../lib/branched_deploy', __FILE__

set :rails_env, ENV['rails_env'] || ENV['RAILS_ENV'] || 'staging'
server '192.168.24.196', :app, :web, :db, primary: true

namespace :deploy do
  task :set_branch do
    set :branch, BranchedDeploy.new.prompt
  end
  before "deploy:update" , "deploy:set_branch"
end

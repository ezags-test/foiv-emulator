require 'capistrano/ext/multistage'

set :default_environment, {
  'RBENV_VERSION' => '1.9.3-p327-perf',
  'PATH' => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH'
}

set :user, 'user'

set :stages, %w(staging develop)
set :default_stage, 'develop'

set :application, 'foiv-emulator'
set :deploy_to, "/home/user/app/#{application}"
set :repository, "git@github.com:ezags/#{application}.git"

set :git_enable_submodules, true

set :scm, :git
set :scm_verbose, false
set :use_sudo, false
set :deploy_via, :remote_cache

set :keep_releases, 5

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :server_port, 9000

set :bundle_cmd, 'bundle'
set :bundle_without, [ :development, :test ]
set :bundle_flags,   '--quiet'
set :bundle_dir,     ''

require 'bundler/capistrano'

set :shared_children, shared_children << 'sockets'

namespace :deploy do
  task :restart do
    foreman.restart
  end
end

task :log do
  run "cd #{shared_path}/log && tail -f #{stage}.log"
end

after 'deploy:finalize_update', 'db:rename'

after 'deploy:update', 'foreman:export'
after 'deploy:update', 'deploy:cleanup'

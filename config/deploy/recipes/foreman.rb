namespace :foreman do
  desc 'Export the Procfile to Ubuntu\'s upstart scripts'
  task :export, roles: :app do
    run %{cd #{release_path} && #{bundle_cmd} exec foreman export upstart /etc/init -f #{release_path}/Procfile.#{stage} -p #{server_port} -a #{application} -u #{user} -l #{shared_path}/log}
  end

  desc 'Start the application services'
  task :start, roles: :app do
    app = ENV['PROCESS'] || application
    run "sudo start #{application}"
  end

  desc 'Stop the application services'
  task :stop, roles: :app do
    app = ENV['PROCESS'] || application
    run "sudo stop #{app}"
  end

  desc 'Restart the application services'
  task :restart, roles: :app do
    app = ENV['PROCESS'] || application
    run "sudo restart #{application} || sudo start #{app}"
  end

  desc 'Display logs for a certain process - arg example: PROCESS=web'
  task :logs, roles: :app do
    process = [ENV['PROCESS'] || 'web', 1].join('-')
    run "cd #{current_path}/log && tail -f #{process}.log"
  end
end

namespace :db do
  desc 'Run a task drop database and create new.'
  task :reset do
    run("cd #{current_path} && RAILS_ENV=#{stage} #{rake} app:db:reset --trace")
  end

  desc 'Run a task migrate database'
  task :migrate do
    run("cd #{current_path} && RAILS_ENV=#{stage} #{rake} db:migrate --trace")
  end

  desc 'Rename database.yml'
  task :rename do
    run("cd #{release_path} && mv config/database.yml.#{stage} config/database.yml")
  end
end


desc "Crawl app with tarantula"
task :tarantula do
  sh 'rm -rf ../../../tmp/tarantula'
  sh "bash -c \"RAILS_ENV=test #{ENV['APP_ROOT']}/script/with_mysql rake db:test:prepare app:tarantula:test\""
end
namespace :http do
  desc 'start the http contract'
  task :serve do
    Rake::Task['before:http'].invoke if Rake::Task.task_defined?('before:http')
        
    require './contracts/http.rb'
    Dir["#{ENV['BASEDIR']}/http*.rb"].map &method(:require)

    Rack::Handler::WEBrick.run(
      Http::Server.instance,
      Port: 9101
    )
  end
end

namespace :http do
  desc 'start the http contract'
  task :serve do
    require './contracts/http.rb'
    Dir["#{ENV['BASEDIR']}/adapters/http/*.rb"].map &method(:require)

    Rack::Handler::WEBrick.run(
      Http::Server.instance,
      Port: 9101
    )
  end
end

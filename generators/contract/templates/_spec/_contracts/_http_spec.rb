ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'

require './contracts/http.rb'
Http::Api.class_eval("get '/' do 'Hello World' end;")

describe Http do
  include Rack::Test::Methods

  def app
    Http::Server.new
  end

  describe Http::Server do
    it 'response with http' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Hello World')
    end

    it 'has a public assets dir' do
      path_to_file = "#{ENV['BASEDIR']}/adapters/http_public/out.txt"
      File.open(path_to_file, 'w') { |f| f.write('tester in sachsen') }
      get '/out.txt'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('tester in sachsen')
      File.delete(path_to_file)
    end
  end

  describe Http::Router do
    before(:all) do
      Http.class_eval("class Test < Grape::API;get '/hallo' do 'Hello World' end;end;")
      @router = Http::Router.new
    end

    it 'gets all routes' do
      routes = @router.instance_variable_get(:@routes)
      expect(routes).to include(:Test)
      expect(routes).not_to include(:Api, :Router, :Server)
    end

    it 'mounts to api' do
      @router.mount
      expect(
        Http::Api.routes.any? { |route| route.route_method == 'GET' && route.route_path = '/hallo' }
      ).to be_truthy
    end
  end
end

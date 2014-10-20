require 'grape'
require 'rack'
require 'rack/cors'

module Http
  class Server
    def initialize
      @filenames = ['', '.html', 'index.html', '/index.html']
      root = File.expand_path("#{ENV['BASEDIR']}/adapters/http_public", __FILE__)
      @rack_static = ::Rack::Static.new(
        -> { [404, {}, []] },
        urls: Dir.glob("#{root}/*").map { |fn| fn.gsub(/#{root}/, '') },
        root: root
        )
    end

    def self.instance
      @instance ||= Rack::Builder.new do
        use Rack::Cors do
          allow do
            origins '*'
            resource '*', headers: :any, methods: :get
          end
        end

        run Http::Server.new
      end.to_app
    end

    def call(env)
      # api
      router = Http::Router.new
      router.mount
      response = Http::Api.call(env)

      # Check if the App wants us to pass the response along to others
      if response[1]['X-Cascade'] == 'pass'
        # static files
        request_path = env['PATH_INFO']
        @filenames.each do |path|
          response = @rack_static.call(env.merge('PATH_INFO' => request_path + path))
          return response if response[0] != 404
        end
      end

      # Serve error pages or respond with API response
      case response[0]
      when 404, 500
        content = @rack_static.call(env.merge('PATH_INFO' => "/errors/#{response[0]}.html"))
        [response[0], content[1], content[2]]
      else
        response
      end
    end
  end

  class Api < Grape::API; end
  class Router
    def initialize
      @reserved_routes = [:Api, :Server, :Router]
      @routes = routes
    end

    def mount
      @routes.map { |name| Http::Api.class_eval("mount(::Http::#{name});") }
    end

    private

    def routes
      Http.constants.select { |c| Class === Http.const_get(c) } - @reserved_routes
    end
  end
end

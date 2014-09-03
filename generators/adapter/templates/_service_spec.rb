ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'


require './contracts/http.rb'
require './adapters/http/<%= service %>.rb'

describe Http::<%= Service %> do
  include Rack::Test::Methods

  def app
    Http::Server.new
  end

  it 'get /<%= service %>s' do
    get '/<%= service %>s'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"Mongoid::<%= Service %>.all"')
  end

  it 'get /<%= service %>s/:id' do
    get '/<%= service %>s/:id'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"Mongoid::<%= Service %>.find(params[:id])"')
  end

  it 'post /<%= service %>s' do
    post '/<%= service %>s'
    expect(last_response).to be_successful
    expect(last_response.body).to eql('"<%= service %>.save!"')
  end

  it 'put /<%= service %>s/:id' do
    put '/<%= service %>s/5'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"erroring"')
  end

  it 'delete /<%= service %>s/:id' do
    delete '/<%= service %>s/5'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"Mongoid::<%= Service %>.find(params[:id]).delete"')
  end
end

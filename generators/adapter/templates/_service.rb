require 'grape'

module Http
  class <%= Service %> < Grape::API
    default_error_status 400
    format :json

    desc 'GET	/<%= service %>s	display a list of all <%= service %> elements'
    get '/<%= service %>s' do
      'Mongoid::<%= Service %>.all'
    end

    desc 'GET	/<%= service %>s/:id	<%= service %>s#show	display a specific <%= service %>'
    params do
      requires :id
    end
    get '/<%= service %>s/:id' do
      'Mongoid::<%= Service %>.find(params[:id])'
    end

    desc 'POST	/<%= service %>s	<%= service %>s#create	create a new <%= service %>'
    post '/<%= service %>s' do
      '<%= service %>.save!'
    end

    desc 'PATCH/PUT	/<%= service %>s/:id	<%= service %>s#update	update a specific <%= service %>'
    put '/<%= service %>s/:id' do
      'erroring'
    end

    delete '/<%= service %>s/:id' do
      'Mongoid::<%= Service %>.find(params[:id]).delete'
    end
  end
end

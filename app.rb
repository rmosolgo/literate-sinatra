# compiled from readme.md by literate-ruby
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json' 
require 'csv'  
require 'thin' # HTTP server
require 'haml' # for quick views
require 'barista' # for using :coffescript in Haml
# configure :production do
# 	# heroku addons:add newrelic:standard
# 	# paste new relic's code into config/newrelic.yml
# 	require 'newrelic_rpm'
# end
# require 'dalli'
# require 'memcachier'
# CACHES = Dalli::Client.new
# require 'pg'
# require 'data_mapper'
# require 'dm-postgres-adapter'
# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://postgres:postgres@localhost/postgres')
require 'mongo'
require 'mongo_mapper'
# require 'bson_ext' # you're gonna want this but it can be a hassle to gem install it
require 'uri'
include Mongo
database_name = "your_db_name"
mongo_url = ENV['MONGOHQ_URL'] || "mongodb://localhost/#{database_name}"
MongoMapper.connection = Mongo::Connection.from_uri mongo_url
MongoMapper.database = URI.parse(mongo_url).path.gsub(/^\//, '') #Extracts 'dbname' from the uri
# YourModel.ensure_index(:field_name)
# class Model
# end
helpers do
	def returns_json(serializable_object=nil)
	    content_type :json
	    response = ""
	    if serializable_object
	    	if serializable_object.respond_to? :to_json
	    		response = serializable_object.to_json
	    	else
	    		response = JSON.dump(serializable_object)
	    	end
	    end
	    response
	end
	def returns_csv(filename='data')
	    content_type 'application/csv'
	    attachment "#{filename}.csv"
	end
	def protected!
		unless authorized?
			p "Unauthorized request."
			response['WWW-Authenticate'] = %(Basic)
			throw(:halt, [401, "Not authorized\n"])
		end
	end
	AUTH_PAIR = [ENV['HTTP_USERNAME'] || 'username', ENV['HTTP_PASSWORD'] || 'password']
	def authorized?
		@auth ||=  Rack::Auth::Basic::Request.new(request.env)
		@auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == AUTH_PAIR
	end
end
get "/" do
	"Home"
end

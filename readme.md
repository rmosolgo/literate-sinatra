
# Boilerplate Sinatra app in Literate Ruby

## About literate_ruby.rb
keep your code:


  - in "readme.md"
  - tab-indented (not four spaces, sorry)
  - use ```Ruby ... ``` for pretty printing on Github


to run in development: 
```
  $ rake run
```
to commit: (requires `git remote origin` )

```
  $ rake github:push["some commit message"]
```
to deploy: (requires `git remote heroku`)
 
```  
  $ rake heroku:deploy["some commit message"]
```

# App setup
extra quotes for code highlighting in Sublime ```
## Gems, config

```Ruby
	require 'rubygems'
	require 'bundler/setup'
	require 'sinatra'
	require 'json' # you'll thank me later
	require 'csv'  # ditto

	require 'thin' # HTTP server
	require 'haml' # for quick views
	require 'barista' # for using :coffescript in Haml
```

### Monitoring w/ New Relic

Uncomment these lines to install New Relic on Heroku:

```Ruby	
	# configure :production do
	# 	# heroku addons:add newrelic:standard
	# 	# paste new relic's code into config/newrelic.yml
	# 	require 'newrelic_rpm'
	# end
```

### Caching

Uncomment these lines to create `CACHES` with [Memcached](http://memcached.org/)/[Memcachier](https://devcenter.heroku.com/articles/memcachier)/[Dalli](https://github.com/mperham/dalli):
(requires Memcached running on default local port)

```Ruby
	# require 'dalli'
	# require 'memcachier'
	# CACHES = Dalli::Client.new
```	
### Choose an ORM:

Postgres/DataMapper:
```Ruby

	# require 'pg'
	# require 'data_mapper'
	# require 'dm-postgres-adapter'
	# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://postgres:postgres@localhost/postgres')
```

MongoDB/MongoMapper:

```Ruby

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

```
# App Setup

## Models

Declare your models here.
```Ruby 
	# class Model
	# end
```

## Helpers
```Ruby
	helpers do
```


### Syntactic sugar for data:

JSON:

```Ruby
		def returns_json(serializable_object=nil)
```
for example, 
`returns_json(@country)` 
sends @country.to_json

```Ruby
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
```

CSV:

Oops, this one doesn't work that way.
It just sets the content-type and attachment headers.

```Ruby
		def returns_csv(filename='data')
		    content_type 'application/csv'
		    attachment "#{filename}.csv"
		end
```

### HTTP Basic Authorization

Set ENV HTTP_USERNAME and HTTP_PASSWORD to use password protection with "protected!"
```Ruby 
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
```
end helpers
```Ruby
	end
```
# Routes 
```Ruby
	get "/" do
		"Home"
	end
```




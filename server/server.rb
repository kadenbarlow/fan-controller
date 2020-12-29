#! /usr/bin/env ruby

require 'sinatra'

require './database.rb'

set :environment, :production
set :port, 80

get '/sensor/:type' do
  content_type :json
  { status: DB[:sensors].where(type: params[:type]).get(:value) }.to_json
end

# get '/light'
# post '/light'

# get '/fan'
# post '/fan'

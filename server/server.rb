#! /usr/bin/env ruby

require 'json'
require 'sinatra'
require 'data_mapper'

DataMapper.setup :default, "sqlite3://#{Dir.pwd}/controller.db"

get '/sensor/:type' do
end

get '/light'
post '/light'

get '/fan'
post '/fan'

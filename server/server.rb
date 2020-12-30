#! /usr/bin/env ruby

require 'serialport'
require 'sinatra'

require './database.rb'

set :environment, :production
set :port, 80

SPEEDS = %w[low medium high].freeze
serial_port = SerialPort.new('/dev/ttyACM0', 9600, 8, 1, SerialPort::NONE)

get '/sensor/:type' do
  content_type :json
  { state: DB[:sensors].where(type: params[:type]).get(:state) }.to_json
end

get '/light/:name' do
  content_type :json
  { state: DB[:lights].where(name: params[:name]).get(:state) }.to_json
end

post '/light/:name' do
  content_type :json
  body = JSON.parse(request.body.read)

  current_state = DB[:lights].where(name: params[:name]).get(:state)
  if current_state != body['state']
    # The command to turn on or off the light is a single toggle command on the controller
    serial_port.write('l')
    DB[:lights].where(name: params[:name]).update(state: body['state'])
  end

  { state: body['state'] }.to_json
end

get '/fan/:name' do
  content_type :json
  current_state = DB[:fans].where(name: params[:name]).get(:state)
  current_speed = DB[:fans].where(name: params[:name]).get(:speed)
  state = current_state == 'on' ? current_speed : current_state

  { state: state }.to_json
end

post '/fan/:name' do
  content_type :json
  body = JSON.parse(request.body.read)

  current_state = DB[:fans].where(name: params[:name]).get(:state)
  current_speed = DB[:fans].where(name: params[:name]).get(:speed)

  if %w[on off].include?(body['state']) && current_state != body['state']
    # The command to turn on or off the fan is a single toggle command on the controller
    # We know we can toggle because the new state is different from the current state
    serial_port.write('f')
    DB[:fans].where(name: params[:name]).update(state: body['state'])
  end

  if SPEEDS.include?(body['state']) && current_state == 'off'
    DB[:fans].where(name: params[:name]).update(state: 'on')
    serial_port.write('f')
  end

  if SPEEDS.include?(body['state']) && current_speed != body['state']
    current_index = SPEEDS.index(current_speed)
    new_index = SPEEDS.index(body['state'])
    # There are two commands for setting the speed of the fan, increase the speed or decrease the speed
    # we only want to send the command if the new speed is different from the previous
    command = new_index > current_index ? 'S' : 's'

    # If going from low to high need to send the command multiple times
    (new_index - current_index).times { serial_port.write(command) }
    DB[:fans].where(name: params[:name]).update(speed: body['state'])
  end

  # Home assistant doesn't have a concept of on, the states it wants are in %w[off low medium high]
  state = body['state'] == 'on' ? current_speed : body['state']
  { state: state }.to_json
end

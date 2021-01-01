#! /usr/bin/env ruby

require 'json'
require 'serialport'

require './database.rb'

def update_sensor(type, value)
  DB[:sensors].where(type: type).update(state: value)
end

def update_state(data)
  data.each do |key, value|
    update_sensor(key, value) if %w[temperature humidity].include?(key)
  end
end

file = Dir['/dev/ttyACM*'].first
serial_port = SerialPort.new(file, 9600, 8, 1, SerialPort::NONE)
while (line = serial_port.readline("\n").chomp)
  data = JSON.parse(line) rescue next

  update_state(data) if data['type'] == 'update'
end

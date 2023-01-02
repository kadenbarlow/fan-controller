# Hunter Ceiling Fan Arduino Controller

Code for Arduino Mega 2560 and Raspberry Pi Zero W to automate a Hunter Ceiling Fan. For more background and explanation 
see [this blog post](https://www.kadenbarlow.dev/blog/2021-01-18-arduino-smart-fan).

## controller/controller.ino 
The controller code has two purposes. Transmit RF signals to the fan in place of a remote controller and sample temperature
and humidity sensor data. Commands are received serially as a single byte from the Raspberry Pi which is running a web server.

## record.ino and transmit.ino
The code in this repository could be used to automate any RF device. The scripts are a modified version of 
[RFreplayEPS](https://github.com/sillyfrog/RFreplayESP) that work with the Mega 2560. There is no file system on the board,
and some of the variable sizes needed to be changed to avoid overflow.

## server/server.rb && servier/serial-monitor.rb
The server was written in Ruby using Sinatra. It only has a few GET and POST endpoints. It uses a Sqlite database to maintain
state. The serial monitor receives the temperature and humidity updates sent as JSON.


#!/usr/bin/env bash

sudo cp server/sinatra.service /etc/systemd/system/sinatra.service
sudo cp server/serial-monitor.service /etc/systemd/system/serial-monitor.service
sudo systemctl enable sinatra
sudo systemctl enable serial-monitor
sudo systemctl start sinatra
sudo systemctl start serial-monitor

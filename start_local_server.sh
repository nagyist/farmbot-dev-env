#!/bin/bash
echo "[WARNING] THERE IS NO ERROR CHECKING IN THIS BECAUSE CONNOR IS LAZY"
WD=$HOME/farmbot

cd $WD/FarmBot-Web-API
bundle install
exec gnome-terminal -e MQTT_HOST=localhost:1883 rails s

# Start teh MQTT broker.
cd $WD/mqtt-gateway
npm install
exec gnome-terminal WEB_APP_URL=http://localhost:3000 node app/index.js

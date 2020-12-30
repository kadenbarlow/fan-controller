/*  IR Fan Controller
 *  By Kaden Barlow
 *
 *  Controls IR celing fan and light
 *  Reports on temperature and humidity
 */

#include <SimpleDHT.h>

// dht11 is the temperature / humidity sensor
const int pinDHT11 = 2;
SimpleDHT11 dht11(pinDHT11);

// Incoming serial data
int incomingByte = 0;

void setup() {
  Serial.begin(9600);
}

void checkSensors() {
  byte temperatureC = 0;
  byte humidity = 0;

  float temperatureF = 0.0;

  int err = SimpleDHTErrSuccess;
  if (err = dht11.read(&temperatureC, &humidity, NULL) != SimpleDHTErrSuccess) {
    // Serial.print("Read DHT11 failed\n");
    // For now just don't report the new values on this iteration
    return;
  }

  temperatureF = (float)temperatureC * 9.0/5.0 + 32.0; // °F = °C x 9/5 + 32.
  Serial.print("{ \"type\": \"update\"");
  Serial.print(", \"temperature\": "); Serial.print(temperatureF);
  Serial.print(", \"humidity\": "); Serial.print((float)humidity);
  Serial.print(" }\n");
}

void serverCommands() {
  if (Serial.available() > 0) {
    incomingByte = Serial.read();

    // TODO: REMOVE THIS
    Serial.print("I received: ");
    Serial.println(incomingByte, DEC);

    switch (incomingByte) {
      case 'l': // toggle light
        break;
      case 'f': // toggle fan
        break;
      case 'S': // increase fan speed
        break;
      case 's': // decrease fan speed
        break;
    }
  }
}

void remoteCommands() {
  // If the remote controller of the fan is pressed we should let the server know the new state
  // of the devices
}

void loop() {
  serverCommands();
  remoteCommands();
  checkSensors();

  delay(500);
}

/*  IR Fan Controller
 *  By Kaden Barlow
 *
 *  Controls IR celing fan and light
 *  Reports on temperature and humidity
 */

#include <SimpleDHT.h>

const int pinDHT11 = 2;
SimpleDHT11 dht11(pinDHT11);

void setup() {
  Serial.begin(9600);
}

void loop() {
  byte temperatureC = 0;
  byte humidity = 0;

  float temperatureF = 0.0;

  int err = SimpleDHTErrSuccess;
  if (err = dht11.read(&temperatureC, &humidity, NULL) != SimpleDHTErrSuccess) {
    // Serial.print("Read DHT11 failed\n");
    return;
  }

  temperatureF = (float)temperatureC * 9.0/5.0 + 32.0; // °F = °C x 9/5 + 32.
  Serial.print("{ \"temperature\": "); Serial.print(temperatureF);
  Serial.print(", \"humidity\": "); Serial.print((float)humidity);
  Serial.print(" }\n");

  delay(2000);
}

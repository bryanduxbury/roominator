#include <Wire.h>

void setup() {
  //Serial.begin(9600); //For debugging
  Wire.begin();
}

void loop() {
  Wire.beginTransmission(1);
  Wire.send(0);
  Wire.send(5);
  Wire.send("OREO");
  Wire.endTransmission();
  delay(100);
}


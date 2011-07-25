#include "Wire.h"

void setup () {
  Serial.begin(9600);
  Wire.begin(); 
}

void loop() {
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  Serial.println("requesting...");
  Wire.requestFrom(1, 1);
  while (Wire.available()) {
    int received = Wire.receive();
    Serial.print("1:");
    Serial.println(received);
  } 
  
  Wire.requestFrom(2, 1);
  while (Wire.available()) {
    int received = Wire.receive();
    Serial.print("2:");
    Serial.println(received);
  } 
  delay(500);
}

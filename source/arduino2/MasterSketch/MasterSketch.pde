#include <string.h>
#include <Wire.h>
#include <NetworkMaster.h>


NetworkMaster master;

void setup() {
  master.setName("o hai");
  
  //Serial.begin(9600); //For debugging
  Wire.begin();
}

void loop() {
  master.sendData(1);
  delay(100);
}


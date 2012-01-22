#include <Wire.h>
#include "Messages.h"

MasterSlaveMessage DEFAULT_MESSAGE;

void setup() {
  strcpy(DEFAULT_MESSAGE.message1L1, "message 1 line 1    ");
  
  //  strcpy("message 1 line 1    \0", DEFAULT_MESSAGE.message1L1);
//  strcpy("message 1 line 2    \0", DEFAULT_MESSAGE.message1L2);
  
  Wire.begin();
  Serial.begin(9600);
}

void loop() {
  for (int i = 0; i < 5; i++) {
    Wire.requestFrom(i, 1);
    int statusCode = 0;
    while (Wire.available()) {
      if (statusCode == 0) statusCode = Wire.read();
      Wire.read();
    }
    Serial.print("Node ");
    Serial.print(i);
    if (statusCode == 0) {
      Serial.println(" is unreachable");
    } else {
      Serial.print(" is online with status code: ");
      Serial.println(statusCode);
      
      Wire.beginTransmission(i);
      Wire.write(1);
      Wire.write(DEFAULT_MESSAGE.message1L1);
//      Wire.write("test");
      int result = Wire.endTransmission();
      Serial.print("Sent message, got result: ");
      Serial.println(result);
    }
    

  }
  delay(1000);
}

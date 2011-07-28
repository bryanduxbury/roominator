#include <Wire.h>
#include <LiquidCrystal.h>
#include <NetworkSlave.h>
#include <DisplayController.h>
#include <BounceButton.h>
#include <string.h>

NetworkSlave slave;
DisplayController dc("name");
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

BounceButton reserve(2);
BounceButton cancel(6);

void setup() {
  lcd.begin(19, 4);
  
  reserve.initialize();
  cancel.initialize();
  
  Serial.begin(9600);
  Wire.begin(1);
  Wire.onReceive(handleReceive);
  Wire.onRequest(handleRequest); 
}

void loop() {
  delay(50);
  
  lcd.setCursor(0,0);
  lcd.print(slave.getDisplayString());
  
  if (reserve.check()) {
    slave.reserve();
    Serial.print("Cancel:");
    Serial.println(slave.getCancel());
    Serial.print("Reserve:");
    Serial.println(slave.getReserve());
  }
  
  if (cancel.check()) {
    slave.cancel();
    Serial.print("Cancel:");
    Serial.println(slave.getCancel());
    Serial.print("Reserve:");
    Serial.println(slave.getReserve());
  }
  
  Serial.println((slave.getCancel()) ? 0xFF : slave.getReserve());
}

void handleRequest() {
  handleEncodedIntegerRequest();
//  handleCharArrayRequest();
}

void handleEncodedIntegerRequest() {
  Wire.send((slave.getCancel()) ? 0xF : slave.getReserve()); 
}

void handleCharArrayRequest() {
  char message[2];
  message[0] = (char) slave.getCancel();
  message[1] = (char) slave.getReserve();
  Wire.send(message);
}

void handleReceive(int numBytes) {
  char packet[numBytes];
  
  for (int i=0; 1 < Wire.available(); i++) {
    packet[i] = (char) Wire.receive();
  }
  
  slave.setDownstreamData(packet);
}

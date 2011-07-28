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
//BounceButton cancel(3);

int check;


void setup() {
  lcd.begin(19, 4);
  reserve.initialize();
//  cancel.initialize();
  Serial.begin(9600);  
  Wire.begin(1);
  Wire.onReceive(handleReceive);
  Wire.onRequest(handleRequest); 
  check = 0;
  
}

void loop() {
  
  delay(100);
  lcd.setCursor(0,0);
  lcd.print(slave.getDisplayString());
  
  if (reserve.check()) {
    check++;
    lcd.print(check);
//    slave.reserve();
  }
  
//  if (cancel.check()) {
//    slave.cancel();
//  }
  
}

void handleRequest() {
  byte *packet = slave.getUpstreamData(); 
  Wire.beginTransmission(); 
  Wire.send(packet);
  Wire.endTransmission();
}

void handleReceive(int numBytes) {
  byte *packet[numBytes];
  int i = 0;
  while (1 < Wire.available()) {
    byte[i] = Wire.receive();
    i++;  
  }
  slave.processDownstreamData(packet);
}


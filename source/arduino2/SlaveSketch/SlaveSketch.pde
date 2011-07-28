#include <Wire.h>
#include <LiquidCrystal.h>
#include <NetworkSlave.h>
#include <DisplayController.h>
#include <BounceButton.h>
#include <string.h>

NetworkSlave slave;
DisplayController dc("Waiting");
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

BounceButton reserve(2);
BounceButton cancel(6);

void setup() {
  lcd.begin(19, 4);
  
  reserve.initialize();
  cancel.initialize();
  
  //Serial.begin(9600);
  Wire.begin(1);
  Wire.onReceive(handleReceive);
  Wire.onRequest(handleRequest);
  
  lcd.setCursor(0,0);
  lcd.print(slave.getDisplayString());
  
  DisplayColor color;
  if (slave.getCurrentReservation()) {
    color = RED;
  } else if (slave.getPendingReservation()) {
    color = YELLOW;
  } else {
    color = GREEN;
  }
  
  dc.setDisplayColor(color);
}

void loop() {
  delay(50);
  
  if (reserve.check()) {
    slave.reserve();
  }
  
  if (cancel.check()) {
    slave.cancel();
  }
}

void handleRequest() {
  Serial.println("In handle request");
  handleEncodedIntegerRequest();
//  handleCharArrayRequest();
}

void handleEncodedIntegerRequest() {
  Serial.println("In encoded int before send");
  Serial.println((slave.getCancel()) ? 0xFF : slave.getReserve());
//  Wire.send((slave.getCancel()) ? 0xFF : slave.getReserve());
  Wire.send('a');
  Serial.println("In encoded int after send");
}

void handleCharArrayRequest() {
  char message[2];
  message[0] = (char) slave.getCancel();
  message[1] = (char) slave.getReserve();
  Wire.send(message);
}

void handleReceive(int numBytes) {
  char packet[numBytes];
  
  int numRead = 0;
  while (numRead < numBytes) {
    if (1 < Wire.available()) {
      packet[numRead] = Wire.receive();
      numRead++;
    }
  }
  
  slave.setDownstreamData(packet);
  
  lcd.setCursor(0,0);
  lcd.print(slave.getDisplayString());
  
  DisplayColor color;
  if (slave.getCurrentReservation()) {
    color = RED;
  } else if (slave.getPendingReservation()) {
    color = YELLOW;
  } else {
    color = GREEN;
  }
  
  dc.setDisplayColor(color);
}


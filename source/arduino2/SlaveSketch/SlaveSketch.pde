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
BounceButton cancel(5);

void setup() {
  lcd.begin(19, 4);
  
  reserve.initialize();
  cancel.initialize();
  
  Serial.begin(9600);
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
  if (reserve.check()) {
    slave.reserve();
    dc.setDisplayColor(YELLOW);
  }
  
  if (cancel.check()) {
    slave.cancel();
    dc.setDisplayColor(YELLOW);
  }
}

void handleRequest() {
  handleEncodedIntegerRequest();
}

void handleEncodedIntegerRequest() {
  Wire.send((slave.getCancel()) ? 0xFF : slave.getReserve());
}


//Take this OUT!
void handleCharArrayRequest() {
  char message[2];
  message[0] = (char) slave.getCancel();
  message[1] = (char) slave.getReserve();
  Wire.send(message);
}

void handleReceive(int numBytes) {
  Serial.print("Number of bytes is: ");
  Serial.println(numBytes);
  char* packet = (char*) malloc(numBytes);
  int i = 0;
  char temp;
  while(Wire.available())
  {
    temp = Wire.receive();
    Serial.print(i);
    Serial.println(temp);
    packet[i] = temp;
    i++;
  }
  
  if (numBytes != 0) {
    slave.setDownstreamData(packet);
    free(packet);
  
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
}


#include <Wire.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>

#include <NetworkSlave.h>
#include <DisplayController.h>
#include <BounceButton.h>
#include <string.h>
 
//Junior
int fig[] = {2,3,4,5,6,8,9,10,11,12,13,1};

//Senior 
//int fig[] = {4,3,2,6,5,8,9,10,11,12,13,2};

// [GreenPin, YellowPin, RedPin, ResPin, CancelPin, LCD1, LCD2, LCD3, LCD4, LCD5, LCD6, I2CAddress]
//byte fig[12];
//configuration will now hold a 12 byte array of bytes
//for(int i = 0; i < 12; i++)
//{
//  fig[i] = fig[i);  
//}

NetworkSlave slave;
DisplayController dc("Waiting", fig[2], fig[1], fig[0]);
//LiquidCrystal lcd(7, 8, 9, 10, 11, 12);
LiquidCrystal lcd(fig[5], fig[6], fig[7], fig[8], fig[9], fig[10]);

BounceButton reserve(fig[3]);
BounceButton cancel(fig[4]);

void setup() {
  lcd.begin(20, 4);
  
  reserve.initialize();
  cancel.initialize();
  
  Serial.begin(9600);
  Wire.begin(fig[11]);
  Wire.onReceive(handleReceive);
  Wire.onRequest(handleRequest);
  
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("1234567890abcdefghij");
  lcd.setCursor(0,1);
  lcd.print("1234567890abcdefghij");
  lcd.setCursor(0,2);
  lcd.print("1234567890abcdefghij");
  lcd.setCursor(0,3);
  lcd.print("1234567890abcdefghij");
  delay(2000);
  lcd.clear();
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
    if (slave.getCancel() || (slave.getReserve() != 0)) {
      slave.setDisplayString("Waiting on server...");
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print(slave.getDisplayString());
    }
  }
  
  if (cancel.check()) {
    slave.cancel();
    if (slave.getCancel() || (slave.getReserve() != 0)) {
      slave.setDisplayString("Waiting on server...");
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print(slave.getDisplayString());
    }
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
    
    lcd.clear();
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


#include <Wire.h>
#include <LiquidCrystal.h>

struct MasterSlaveMessage {
  char message1L1[21];
  char message1L2[21];
};

unsigned int counter = 0;

char message[21];

LiquidCrystal lcd(13,12,11,10,9,8);

void setup() {
  lcd.begin(20,4);
  lcd.setCursor(0, 0);
  lcd.print("Hello world!");
  
  Wire.begin(1);
  Wire.onRequest(requestHandler);
  Wire.onReceive(receiveHandler);
}

void loop() {
  lcd.setCursor(0, 1);
  lcd.print(counter);
  lcd.setCursor(0, 2);
  lcd.print(message);
  delay(100);
}

void requestHandler() {
  counter++;
  Wire.write(counter);
}

void receiveHandler(int numBytes) {
  lcd.setCursor(0, 3);
  lcd.print(numBytes);
  for (int i = 0; i < numBytes; i++) {
    message[i] = Wire.read();
  }
}

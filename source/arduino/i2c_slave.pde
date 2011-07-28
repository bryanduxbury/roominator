#include "Wire.h"
#include <LiquidCrystal.h>

byte value = 0;
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

void setup() {
  Wire.begin(1);
  Wire.onRequest(onRequestHandler);
  Serial.begin(9600);
  lcd.begin(20, 4);
  lcd.print("woot! powered up.");
}

void onRequestHandler() {
  Serial.println("onReceiveHandler fired!");
  value--;
  lcd.setCursor(0,0);
  lcd.print("Sending value: ");
  lcd.print((int)value);
  Wire.send(value);
}

void loop () {
  delay(100);
}

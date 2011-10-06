// DisplayController.c

#include <LiquidCrystal.h>
#include "WProgram.h"
#include <DisplayController.h>
#include <EEPRom.h>
#include <Wire.h>

using namespace std;

DisplayController::DisplayController(LiquidCrystal* lcd,
                                      NetworkSlave* slave,
                                      int redPin,
                                      int yellowPin,
                                      int greenPin,
                                      BounceButton* reserveButton,
                                      BounceButton* cancelButton)
{
  this->lcd = lcd;
  this->slave = slave;
  this->redPin = redPin;
  this->yellowPin = yellowPin;
  this->greenPin = greenPin;
  this->reserveButton = reserveButton;
  this->cancelButton = cancelButton;
}

void DisplayController::begin() {
  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(greenPin, OUTPUT);

  digitalWrite(redPin, HIGH);
  digitalWrite(yellowPin, HIGH);
  digitalWrite(greenPin, HIGH);


  lcd->begin(20, 4);
  // display the self-test
  lcd->clear();
  lcd->setCursor(0,0);
  lcd->print("####################");
  lcd->setCursor(0,1);
  lcd->print("#     SELF TEST    #");
  lcd->setCursor(0,2);
  lcd->print("#                  #");
  lcd->setCursor(0,3);
  lcd->print("####################");

  digitalWrite(redPin, LOW);
  delay(750);
  digitalWrite(yellowPin, LOW);
  delay(750);
  digitalWrite(greenPin, LOW);

  lcd->setCursor(0,2);
  lcd->print("#     COMPLETE!    #");

  delay(2000);

  digitalWrite(redPin, HIGH);
  digitalWrite(yellowPin, HIGH);
  digitalWrite(greenPin, HIGH);
  lcd->clear();

  setOrResetDeviceId();

  lastStateChangeMillis = millis();
}

void DisplayController::setHigh(int displayColor) {
  digitalWrite(redPin, (displayColor == LED_RED) ? LOW : HIGH);
  digitalWrite(yellowPin, (displayColor == LED_YELLOW) ? LOW : HIGH);
  digitalWrite(greenPin, (displayColor == LED_GREEN) ? LOW : HIGH);
}

void DisplayController::draw() {
  if (millis() - lastStateChangeMillis > 1500) {
    msgNum++;
    lastStateChangeMillis = millis();
  }

  setHigh(slave->getDownstreamData()->statusLed);

  lcd->setCursor(0,0);
  lcd->print(slave->getDownstreamData()->roomName);

  if (slave->getCancel() || slave->getReserve()) {
    lcd->setCursor(0,1);
    lcd->print("cancel or reserve");
  } else {
    if (msgNum % 3 == 0) {
      lcd->setCursor(0,1);
      lcd->print(slave->getDownstreamData()->msg1Line1);
      lcd->setCursor(0,2);
      lcd->print(slave->getDownstreamData()->msg1Line2);
    } else if (msgNum % 3 == 1) {
      lcd->setCursor(0,1);
      lcd->print(slave->getDownstreamData()->msg2Line1);
      lcd->setCursor(0,2);
      lcd->print(slave->getDownstreamData()->msg2Line2);
    } else {
      lcd->setCursor(0,1);
      lcd->print(slave->getDownstreamData()->msg3Line1);
      lcd->setCursor(0,2);
      lcd->print(slave->getDownstreamData()->msg3Line2);
    }
  }

  lcd->setCursor(0,3);
  char buttonBuffer[21];
  buttonBuffer[20] = '\0';

  memset(buttonBuffer, ' ', 20);
  if (slave->getDownstreamData()->lbutton_status == LBUTTON_RESERVE) {
    memcpy(buttonBuffer, "Reserve", 7);
  } else if (slave->getDownstreamData()->lbutton_status == LBUTTON_EXTEND) {
    memcpy(buttonBuffer, "Extend", 6);
  }

  if (slave->getDownstreamData()->rbutton_status == RBUTTON_ENABLED) {
    memcpy(buttonBuffer + 14, "Cancel", 6);
  }
  lcd->print(buttonBuffer);
}

void DisplayController::setOrResetDeviceId() {
  int deviceId = EEPROM.read(0);
  lcd->setCursor(0,0);

  if (deviceId == 0) {
    lcd->print("No Display ID set.");
    delay(2000);
    deviceId = getId();
  } else {
    long startMillis = millis();
    
    while(true) {
      long curMillis = millis();
      if (curMillis - startMillis > 6000) {
        break;
      }

      lcd->setCursor(0,0);
      lcd->print("Current ID: ");
      lcd->print(deviceId);
      lcd->setCursor(0,1);
      lcd->print("Press and hold both ");
      lcd->setCursor(0,2);
      lcd->print("buttons in the next ");
      lcd->setCursor(0,3);
      lcd->print((5000 - (curMillis-startMillis)) / 1000);
      lcd->print(" secs to change");
      
      
      bool res = reserveButton->check();
      bool can = cancelButton->check();
      if (res && can) {
        deviceId = getId();
        break;
      }
      delay(10);
    }
  }

  // store the device id back into the eeprom
  EEPROM.write(0, deviceId);

  // boot up the i2c interface with the provided device ID
  Wire.begin(deviceId);

  lcd->clear();
}

int DisplayController::getId() {
  lcd->clear();
  lcd->setCursor(0,0);
  lcd->print("Current value:");
  lcd->setCursor(0,3);
  lcd->print("Increment     Accept");
  while(reserveButton->check() || cancelButton->check()){delay(100);}

  int deviceId = 1;
  int i = 0;
  while (true) {
    i++;
    if (reserveButton->check()) {
      deviceId++;
      if (deviceId == 33) {
        deviceId = 1;
      }
      while(reserveButton->check()){}
    }
    if (cancelButton->check()) {
      break;
    }
    lcd->setCursor(0,1);
    lcd->print(deviceId);
    delay(10);
  }
  lcd->setCursor(0,2);
  lcd->print("      Accepted!     ");
  lcd->setCursor(0,3);
  lcd->print("                    ");
  delay(2000);
  
  return deviceId;
}
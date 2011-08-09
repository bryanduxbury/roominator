// DisplayController.c

#include <LiquidCrystal.h>
#include "WProgram.h"
#include <DisplayController.h>
using namespace std;

#define RED 2
#define YELLOW 1
#define GREEN 0

DisplayController::DisplayController(LiquidCrystal* lcd, NetworkSlave* slave, int redPin, int yellowPin, int greenPin) {
  this->lcd = lcd;
  this->slave = slave;
  this->redPin = redPin;
  this->yellowPin = yellowPin;
  this->greenPin = greenPin;
}

void DisplayController::begin() {
  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(greenPin, OUTPUT);

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

  digitalWrite(redPin, HIGH);
  delay(750);
  digitalWrite(yellowPin, HIGH);
  delay(750);
  digitalWrite(greenPin, HIGH);

  lcd->setCursor(0,2);
  lcd->print("#     COMPLETE!    #");

  delay(2000);

  digitalWrite(redPin, LOW);
  digitalWrite(yellowPin, LOW);
  digitalWrite(greenPin, LOW);
  lcd->clear();

  lastStateChangeMillis = millis();
}

void DisplayController::setHigh(int displayColor) {
  digitalWrite(redPin, (displayColor == RED) ? HIGH : LOW);
  digitalWrite(yellowPin, (displayColor == YELLOW) ? HIGH : LOW);
  digitalWrite(greenPin, (displayColor == GREEN) ? HIGH : LOW);
}

void DisplayController::draw() {
  if (millis() - lastStateChangeMillis > 1500) {
    msgNum++;
    lastStateChangeMillis = millis();
  }

  int displayColor = GREEN;

  // negative secs on next reservation means that there is no current reservation
  if (slave->getCurrentReservation()->secs > 0) {
    displayColor = RED;
  } else if ((slave->getCurrentReservation()->secs < 0) && (slave->getCurrentReservation()->secs > -60*15)) {
    // the next reservation is less than 15 minutes away, so light the yellow LED
    displayColor = YELLOW;
  }

  setHigh(displayColor);

  lcd->setCursor(0,0);
  lcd->print(slave->getRoomName());

  if (slave->getCancel() || slave->getReserve()) {
    lcd->setCursor(0,1);
    lcd->print("cancel or reserve");
  } else {
    if (msgNum % 3 == 0) {
      lcd->setCursor(0,1);
      lcd->print(slave->getCurrentReservation()->msg1Line1);
      lcd->setCursor(0,2);
      lcd->print(slave->getCurrentReservation()->msg1Line2);
    } else if (msgNum % 3 == 1) {
      lcd->setCursor(0,1);
      lcd->print(slave->getCurrentReservation()->msg2Line1);
      lcd->setCursor(0,2);
      lcd->print(slave->getCurrentReservation()->msg2Line2);
    } else {
      lcd->setCursor(0,1);
      lcd->print(slave->getCurrentReservation()->msg3Line1);
      lcd->setCursor(0,2);
      lcd->print(slave->getCurrentReservation()->msg3Line2);
    }
  }

  lcd->setCursor(0,3);
  char buttonBuffer[21];
  buttonBuffer[20] = '\0';

  memset(buttonBuffer, ' ', 20);
  if (displayColor == GREEN) {
    memcpy(buttonBuffer, "Reserve", 7);
  } else if (displayColor == RED) {
    memcpy(buttonBuffer, "Extend", 6);
  }

  if (displayColor == RED) {
    memcpy(buttonBuffer + 14, "Cancel", 6);
  }
  lcd->print(buttonBuffer);
}

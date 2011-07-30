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
  strcpy(_displayName, "  waiting to sync   ");
  strcpy(_currentReservation, "                    ");

  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(greenPin, OUTPUT);

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
}

void DisplayController::setHigh(DisplayColor displayColor) {
  digitalWrite(redPin, (displayColor == RED) ? HIGH : LOW);
  digitalWrite(yellowPin, (displayColor == YELLOW) ? HIGH : LOW);
  digitalWrite(greenPin, (displayColor == GREEN) ? HIGH : LOW);
}

void DisplayController::setDisplayColor(DisplayColor displayColor) {
  _displayColor = displayColor;
}

void DisplayController::setDisplayName(char* displayName) {
  strncpy(_displayName, displayName, 20);
}

void DisplayController::draw() {
  setHigh(_displayColor);

  lcd->clear();
  lcd->setCursor(0,0);
  lcd->print(_displayName);
  lcd->setCursor(0,1);
  lcd->print(_currentReservation);
  lcd->setCursor(0,3);
  lcd->print("Reserve");
  lcd->setCursor(13,3);
  lcd->print("Cancel");
}
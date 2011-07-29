// DisplayController.c

#include "WProgram.h"
#include <DisplayController.h>
using namespace std;

#define RED 2
#define YELLOW 1
#define GREEN 0

DisplayController::DisplayController(char displayName[], int redPin, int yellowPin, int greenPin) {
  this->redPin = redPin;
  this->yellowPin = yellowPin;
  this->greenPin = greenPin;
  strcpy(displayName, _displayName);
  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
}

void DisplayController::setHigh(DisplayColor displayColor) {
  digitalWrite(redPin, (displayColor == RED) ? HIGH : LOW);
  digitalWrite(yellowPin, (displayColor == YELLOW) ? HIGH : LOW);
  digitalWrite(greenPin, (displayColor == GREEN) ? HIGH : LOW);
}

void DisplayController::setDisplayColor(DisplayColor displayColor) {
  _displayColor = displayColor;
  setHigh(displayColor);
}


//BounceButton.cpp

#include "WProgram.h"
#include <BounceButton.h>
using namespace std;

#define DELAY 50

BounceButton::BounceButton(int pin_number) {
	pin = pin_number;
	currentState = LOW;
	lastState = LOW;
	lastDebounceTime = 0;
}

void initialize() {
	pinMode(pin, INPUT);
  digitalWrite(pin, HIGH);
}

bool check() {
	int reading = digitalRead(buttonPin);
	
 // If the switch changed, due to noise or pressing:
 if (reading != lastButtonState) {
   // reset the debouncing timer
   lastDebounceTime = millis();
 } 
 
 if ((millis() - lastDebounceTime) > DELAY) {
   // whatever the reading is at, it's been there for longer
   // than the debounce delay, so take it as the actual current state:
   currentState = reading;
   
   //Invert output
   if (lastState == LOW && currentState == HIGH) {
     lastState = currentState;
		 return true;
   } else {
   	 lastState = currentState;
   	 return false;
 	 }
}

int getState() {
	return currentState;
}

int getLastState() {
	reutrn lastState;
}

int getTime() {
	return lastDebounceTime;
}
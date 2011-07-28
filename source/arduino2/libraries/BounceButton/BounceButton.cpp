//BounceButton.cpp

#include "WProgram.h"
#include <BounceButton.h>

#define DELAY 50

BounceButton::BounceButton(int pin_number) {
	pin = pin_number;
	currentState;
	lastState = LOW;
	lastSavedState = LOW;
	lastDebounceTime = 0;
}

void BounceButton::initialize() {
	pinMode(pin, INPUT);
  digitalWrite(pin, HIGH);  
}

bool BounceButton::check() {
	int reading = digitalRead(pin);
	
	//If the switch changed, due to noise or pressing:
	if (reading != lastState) {
   // reset the debouncing timer
   lastDebounceTime = millis();
  } 
 
 	int ledState;
 	bool value = false;
 	if ((millis() - lastDebounceTime) > DELAY) {
	 // whatever the reading is at, it's been there for longer
	 // than the debounce delay, so take it as the actual current state:
	 currentState = reading;
		
	if (lastSavedState == HIGH && currentState == LOW) {
		value = true;
	} else {
		value = false;
	}       
		
	lastSavedState = currentState;
		
  }
	
	lastState = reading;
	return value;

}

int BounceButton::getState() {
	return currentState;
}

int BounceButton::getLastState() {
	return lastState;
}

int BounceButton::getTime() {
	return lastDebounceTime;
}

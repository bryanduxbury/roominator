#include "DownstreamDataParser.h"
#include "stdlib.h"
#include "WProgram.h"

#define VALID 0

void DownstreamDataParser::parseAndUpdateDownstreamData(char* received, DownstreamData* dd) {
  
  switch ((int) received[0]) {
    case 1: // RED
    dd->setCurrentReservation(true);
    dd->setPendingReservation(false);
    break;
    
    case 2: // YELLOW
    dd->setCurrentReservation(false);
    dd->setPendingReservation(true);
    break;
    
    case 3: // GREEN
    dd->setCurrentReservation(false);
    dd->setPendingReservation(false);
  }
  
  int stringLength = (int) received[1];
  char displayString[stringLength];
  
  for (int i=0; i<stringLength; i++) {
    displayString[i] = (char) received[i+2];
  }
  displayString[stringLength] = '\0';
  Serial.println(displayString);
  dd->setDisplayString(displayString);
}

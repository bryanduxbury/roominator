#include "DownstreamDataParser.h"

#define VALID 0

DownstreamData* DownstreamDataParser::parseDownstreamData(char *received) {
  DownstreamData *dd;
  
  if (((int) received[0]) != VALID) {
    // TODO
  }
  
  switch ((int) received[1]) {
    case 0:
    dd->setCurrentReservation(true);
    dd->setPendingReservation(false);
    break;
    
    case 1:
    dd->setCurrentReservation(false);
    dd->setPendingReservation(true);
    break;
    
    case 2:
    dd->setCurrentReservation(false);
    dd->setPendingReservation(false);
  }
  
  int stringLength = received[2];
  char displayString[stringLength];
  for (int i=0; i<stringLength; i++) {
    displayString[i] = (char) received[i+3]; 
  }
  dd.setDisplayString(displayString);
  free(displayString);
  
  return dd;
}

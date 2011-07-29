#include "DownstreamDataParser.h"
#include "stdlib.h"

#define VALID 0

DownstreamData DownstreamDataParser::parseDownstreamData(char *received) {
  DownstreamData dd;
  
  switch ((int) received[0]) {
    case 0: // RED
    dd.setCurrentReservation(true);
    dd.setPendingReservation(false);
    break;
    
    case 1: // YELLOW
    dd.setCurrentReservation(false);
    dd.setPendingReservation(true);
    break;
    
    case 2: // GREEN
    dd.setCurrentReservation(false);
    dd.setPendingReservation(false);
  }
  
  int stringLength = received[1];
  char displayString[stringLength];
  for (int i=0; i<stringLength; i++) {
    displayString[i] = (char) received[i+2];
  }
  dd.setDisplayString(displayString);
  
  return dd;
}

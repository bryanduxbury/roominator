#include "DownstreamDataParser.h"

#define VALID 0

DownstreamDataParser::DownstreamData* parseDownstreamData(byte *received) {
  DownstreamData *dd;
  
  if (((int) dd[0]) != VALID) {
    // TODO
  }
  
  switch (dd[1]) {
    case 0:
    dd.setCurrentReservation(true);
    dd.setPendingReservation(NULL);
    break;
    
    case 1:
    dd.setCurrentReservation(false);
    dd.setPendingReservation(true);
    break;
    
    case 2:
    dd.setCurrentReservation(false);
    dd.setPendingReservation(false);
  }
  
  int stringLength = dd[2];
  char displayString[stringLength];
  for (int i=0; i<stringLength; i++) {
    displayString[i] = (char) received[i+3]; 
  }
  dd.setDisplayString(&displayString);
  
  return dd;
}

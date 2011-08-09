#include "WProgram.h"
#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {
  strcpy(dataStruct.roomName,                     "  waiting to sync   ");
  strcpy(dataStruct.msg1Line1, "                    ");
  dataStruct.msg1Line1[20] = '\0';
  strcpy(dataStruct.msg1Line2, "                    ");
  dataStruct.msg1Line2[20] = '\0';
  strcpy(dataStruct.msg2Line1, "                    ");
  dataStruct.msg2Line1[20] = '\0';
  strcpy(dataStruct.msg2Line2, "                    ");
  dataStruct.msg2Line2[20] = '\0';
  strcpy(dataStruct.msg3Line1, "                    ");
  dataStruct.msg3Line1[20] = '\0';
  strcpy(dataStruct.msg3Line2, "                    ");
  dataStruct.msg3Line2[20] = '\0';

  dataStruct.statusLed = LED_NONE;
  
  dataStruct.lbutton_status = LBUTTON_DISABLED;
  dataStruct.rbutton_status = RBUTTON_DISABLED;
}

void DownstreamData::parseAndUpdate(char* packet) {
  memcpy(&dataStruct, packet, sizeof(DownstreamDataStruct));
}

char* DownstreamData::getRoomName() {
  return dataStruct.roomName;
}

DownstreamDataStruct* DownstreamData::getCurrentReservation() {
  return &dataStruct;
}

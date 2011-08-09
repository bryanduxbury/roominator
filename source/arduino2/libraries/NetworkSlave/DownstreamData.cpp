#include "WProgram.h"
#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {
  strcpy(roomName,                     "  waiting to sync   ");
  strcpy(currentReservation.msg1Line1, "                    ");
  currentReservation.msg1Line1[20] = '\0';
  strcpy(currentReservation.msg1Line2, "                    ");
  currentReservation.msg1Line2[20] = '\0';
  strcpy(currentReservation.msg2Line1, "                    ");
  currentReservation.msg2Line1[20] = '\0';
  strcpy(currentReservation.msg2Line2, "                    ");
  currentReservation.msg2Line2[20] = '\0';
  strcpy(currentReservation.msg3Line1, "                    ");
  currentReservation.msg3Line1[20] = '\0';
  strcpy(currentReservation.msg3Line2, "                    ");
  currentReservation.msg3Line2[20] = '\0';

  currentReservation.secs = 0;
}

void DownstreamData::parseAndUpdate(char* packet) {
  memcpy(roomName, packet, 20);
  packet+=21;

  memcpy(&currentReservation, packet, sizeof(Reservation));
}

char* DownstreamData::getRoomName() {
  return roomName;
}

Reservation* DownstreamData::getCurrentReservation() {
  return &currentReservation;
}

#include "WProgram.h"
#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {
  strcpy(roomName,                     "  waiting to sync   ");
  strcpy(currentReservation.textLine1, "                    ");
  currentReservation.textLine1[20] = '\0';
  strcpy(currentReservation.textLine2, "                    ");
  currentReservation.textLine2[20] = '\0';
  strcpy(currentReservation.altTextLine1, "                    ");
  currentReservation.altTextLine1[20] = '\0';
  strcpy(currentReservation.altTextLine2, "                    ");
  currentReservation.altTextLine2[20] = '\0';
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

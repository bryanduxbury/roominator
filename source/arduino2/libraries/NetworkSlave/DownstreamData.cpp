#include "WProgram.h"
#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {
  strcpy(roomName,                     "  waiting to sync   ");
  strcpy(currentReservation.textLine1, "some content        ");
  currentReservation.textLine1[20] = '\0';
  strcpy(currentReservation.textLine2, "                    ");
  currentReservation.secs = 0;
  strcpy(nextReservation.textLine1,    "                    ");
  strcpy(nextReservation.textLine2,    "                    ");
  nextReservation.secs = 0;
}

void DownstreamData::parseAndUpdate(char* packet) {
  memcpy(roomName, packet, 20);
  packet+=21;

  memcpy(currentReservation.textLine1, packet, 20);
  packet+=21;
  memcpy(currentReservation.textLine2, packet, 20);
  // memcpy(nextReservation.textLine12, packet+20 + sizeof(Reservation), sizeof(Reservation));
}

char* DownstreamData::getRoomName() {
  return roomName;
}

Reservation* DownstreamData::getCurrentReservation() {
  return &currentReservation;
}

Reservation* DownstreamData::getNextReservation() {
  return &nextReservation;
}
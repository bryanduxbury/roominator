#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {
  strcpy(roomName, "  waiting to sync   ");
  strcpy(currentReservation.textLine1, "                    ");
  strcpy(currentReservation.textLine2, "                    ");
  currentReservation.secs = 0;
  strcpy(nextReservation.textLine1, "                    ");
  strcpy(nextReservation.textLine2, "                    ");
  nextReservation.secs = 0;
}

void DownstreamData::parseAndUpdate(char* packet) {
  memcpy(roomName, packet, 20);
  memcpy(&currentReservation, packet+20, sizeof(Reservation));
  memcpy(&nextReservation, packet+20 + sizeof(Reservation), sizeof(Reservation));
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
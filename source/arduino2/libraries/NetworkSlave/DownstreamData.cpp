#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {}

void DownstreamData::parseAndUpdate(char* packet) {
  memcpy(roomName, packet, 20);
  memcpy(&currentReservation, packet+20, sizeof(Reservation));
  memcpy(&pendingReservation, packet+20 + sizeof(Reservation), sizeof(Reservation));
}

char* DownstreamData::getRoomName() {
  return roomName;
}

Reservation* DownstreamData::getCurrentReservation() {
  return &currentReservation;
}

Reservation* DownstreamData::getNextReservation() {
  return &pendingReservation;
}
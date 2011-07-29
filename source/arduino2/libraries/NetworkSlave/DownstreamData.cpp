#include <DownstreamData.h>
#include <string.h>
#include <stdlib.h>

DownstreamData::DownstreamData() {}

bool DownstreamData::getCurrentReservation() {
  return currentReservation;
}

void DownstreamData::setCurrentReservation(bool value) {
  currentReservation = value;
}

bool DownstreamData::getPendingReservation() {
  return pendingReservation;
}

void DownstreamData::setPendingReservation(bool value) {
  pendingReservation = value;
}

char* DownstreamData::getDisplayString() {
  return displayString;
}

void DownstreamData::setDisplayString(char *value) {
  //Make sure it is large enough
  displayString = (char*) realloc(displayString, strlen(value));
  strcpy(displayString, value);
}

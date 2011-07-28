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

void setDisplayString(char *value) {
  strcpy(displayString, value);
}

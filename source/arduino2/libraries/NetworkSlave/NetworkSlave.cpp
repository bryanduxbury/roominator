#include "NetworkSlave.h"
#include "WProgram.h"
#include "Wire.h"

NetworkSlave::NetworkSlave() {
  ud = UpstreamData();
  ud.setCancel(false);
  ud.setReserve(0);

  dd = DownstreamData();
}

void NetworkSlave::readFully(char* buf) {
  while (Wire.available()) {
    *buf = Wire.receive();
    buf++;
  }
}

void NetworkSlave::handleReceive(int numBytes) {
  char packet[numBytes];
  if (numBytes != 0) {
    readFully(packet);
  }

  // if cancel or reserve have been pressed but not reported yet, then we want 
  // to ignore the upstream message.
  if (getCancel() || getReserve()) {
    return;
  }

  Serial.print("Number of bytes is: ");
  Serial.println(numBytes);
  setDownstreamData(packet);
}

int NetworkSlave::getCancel() {
  return ud.getCancel();
}

int NetworkSlave::getReserve() {
  return ud.getReserve();
}

void NetworkSlave::setDownstreamData(char* received) {
  dd.parseAndUpdate(received);
}

void NetworkSlave::reserve() {
  ud.setCancel(false);
  ud.setReserve(ud.getReserve()+1);
}

void NetworkSlave::cancel() {
  if (dd.getCurrentReservation()) {
    ud.setReserve(0);
    ud.setCancel(true);
  }
}

Reservation* NetworkSlave::getCurrentReservation() {
  return dd.getCurrentReservation();
}

Reservation* NetworkSlave::getNextReservation() {
  return dd.getNextReservation();
}

void NetworkSlave::clearCounts() {
  ud.setReserve(0);
  ud.setCancel(false);
}

char* NetworkSlave::getRoomName() {
  return dd.getRoomName();
}
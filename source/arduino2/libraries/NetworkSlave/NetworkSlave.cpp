#include "NetworkSlave.h"
#include "WProgram.h"
#include "Wire.h"
#include "DownstreamDataParser.h"

NetworkSlave::NetworkSlave() {
  ud = UpstreamData();
  ud.setCancel(false);
  ud.setReserve(0);

  dd = DownstreamData();
  dd.setCurrentReservation(true);
  dd.setPendingReservation(false);
  dd.setDisplayString("Starting up...");
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
  DownstreamDataParser::parseAndUpdateDownstreamData(received, &dd);
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

void NetworkSlave::setDisplayString(char *displayString) {
  dd.setDisplayString(displayString);
}

char* NetworkSlave::getDisplayString() {
	return dd.getDisplayString();
}

bool NetworkSlave::getCurrentReservation() {
  return dd.getCurrentReservation();
}

bool NetworkSlave::getPendingReservation() {
  return dd.getPendingReservation();
}

void NetworkSlave::clearCounts() {
  ud.setReserve(0);
  ud.setCancel(false);
}

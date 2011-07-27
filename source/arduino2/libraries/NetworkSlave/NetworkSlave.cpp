#include "NetworkSlave.cpp"
#include "WProgram.h"
#include "Wire.h"

#define UPSTREAM_MESSAGE_SIZE 2

NetworkSlave::NetworkSlave() {
  ud.setCancel(false);
  ud.setReserve(0);
  dd.setCurrentReservations(false);
  dd.setPendingReservations(false);
  dd.setDisplayString(NULL);
}

byte* NetworkSlave::getUpstreamData() {
  byte message[UPSTREAM_MESSAGE_SIZE];
  message[0] = (byte) ud.getCancel();
  message[1] = (byte) ud.getReserve();
  return &message;
}

void NetworkSlave::setDownstreamData(byte *received) {
  dd = DownstreamDataParser::parseDownstreamData(received);
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

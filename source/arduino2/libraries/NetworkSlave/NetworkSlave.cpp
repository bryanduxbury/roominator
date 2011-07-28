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
  dd.setDisplayString("Gareth");
}

int NetworkSlave::getCancel() {
  return ud.getCancel();
}

int NetworkSlave::getReserve() {
  return ud.getReserve();
}

void NetworkSlave::setDownstreamData(char *received) {
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

char* NetworkSlave::getDisplayString() {
	return dd.getDisplayString();
}

bool NetworkSlave::getCurrentReservation() {
  return dd.getCurrentReservation();
}

bool NetworkSlave::getPendingReservation() {
  return dd.getPendingReservation();
}

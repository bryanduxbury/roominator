#include "NetworkSlave.h"
#include "Wire.h"
#include "WProgram.h"

NetworkSlave::NetworkSlave() {
  name = 0;
  reserveCount = 0;
  cancelCount = 0;
  reserveCountAck = 0;
  cancelCountAck = 0;
  currentReservation = Reservation();
  nextReservation = Reservation();
}

void NetworkSlave::parseData(int numBytes) {  
  //First byte will be 0 (hopefully)
  if (Wire.receive() != 0)
  {
    return;  
  }
  
  byte nameLength = Wire.receive();
  char name_data[nameLength];
  
  for(int i = 0; i < nameLength; i++)
  {
    name_data[i] = Wire.receive();
  }
  this->name = name_data; 
}

char* NetworkSlave::getName() {
  return name;
}

void NetworkSlave::incrementReservePressed() {
  reserveCount++;
}

void NetworkSlave::incrementCancelPressed() {
  cancelCount++;
}

int NetworkSlave::getAcknowledgedReservePresses() {
  return reserveCountAck;
}

int NetworkSlave::getAcknowledgedCancelPresses() {
  return cancelCountAck;
}

Reservation NetworkSlave::getCurrentReservation() {
  return currentReservation;
}
Reservation NetworkSlave::getNextReservation() {
  return nextReservation;
}

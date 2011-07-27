#include "NetworkMaster.h"
#include "Wire.h"
#include "string.h"
#include "stdlib.h"

NetworkMaster::NetworkMaster() {
  name = "Unintialized";
  reserveCount = 0;
  cancelCount = 0;
  reserveCountAck = 0;
  cancelCountAck = 0;
  currentReservation = Reservation();
  nextReservation = Reservation();
}

void NetworkMaster::sendData(int address) {
  Wire.beginTransmission(address);
  Wire.send(0);
  sendName();
  sendReservation(currentReservation);    
  sendReservation(nextReservation);
  Wire.endTransmission();
}

void NetworkMaster::sendName() {
  int nameLength = strlen(name);
  Wire.send(nameLength);
  Wire.send(name);  
}

void NetworkMaster::setName(char* name) {
  free(this->name);
  this->name = name;  
}

void NetworkMaster::incrementReserveAcknowledged() {
  reserveCountAck++;
}

void NetworkMaster::incrementCancelAcknowledged() {
  cancelCountAck++;
}

int NetworkMaster::getReservePresses() {
  return reserveCount;
}

int NetworkMaster::getCancelPresses() {
  return cancelCount;
}

void NetworkMaster::setCurrentReservation(Reservation reservation) {
  currentReservation = reservation;
}
void NetworkMaster::setNextReservation(Reservation reservation) {
  nextReservation = reservation;
}

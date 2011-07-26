#include "NetworkMaster.h"

NetworkMaster::NetworkMaster() {
  name = 0;
  reserveCount = 0;
  cancelCount = 0;
  reserveCountAck = 0;
  cancelCountAck = 0;
  currentReservation = Reservation();
  nextReservation = Reservation();
}

void NetworkMaster::setName(char* name) {
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

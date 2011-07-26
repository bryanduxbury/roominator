#include "NetworkMaster.h"

NetworkMaster::NetworkMaster() {
  name = 0;
  reserve_count = 0;
  cancel_count = 0;
  reserve_count_ack = 0;
  cancel_count_ack = 0;
  current_reservation = Reservation();
  next_reservation = Reservation();
}

void NetworkMaster::set_name(char* name) {
  this->name = name;
}

void NetworkMaster::increment_reserve_acknowledged() {
  reserve_count_ack++;
}

void NetworkMaster::increment_cancel_acknowledged() {
  cancel_count_ack++;
}

int NetworkMaster::get_reserve_presses() {
  return reserve_count;
}

int NetworkMaster::get_cancel_presses() {
  return cancel_count;
}

void NetworkMaster::set_current_reservation(Reservation reservation) {
  current_reservation = reservation;
}
void NetworkMaster::set_next_reservation(Reservation reservation) {
  next_reservation = reservation;
}

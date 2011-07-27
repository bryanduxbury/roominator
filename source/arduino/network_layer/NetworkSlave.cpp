#include "NetworkSlave.h"

NetworkSlave::NetworkSlave() {
  name = 0;
  reserve_count = 0;
  cancel_count = 0;
  reserve_count_ack = 0;
  cancel_count_ack = 0;
  current_reservation = Reservation();
  next_reservation = Reservation();
}

char* NetworkSlave::get_name() {
  return name;
}

void NetworkSlave::increment_reserve_pressed() {
  reserve_count++;
}

void NetworkSlave::increment_cancel_pressed() {
  cancel_count++;
}

int NetworkSlave::get_acknowledged_reserve_presses() {
  return reserve_count_ack;
}

int NetworkSlave::get_acknowledged_cancel_presses() {
  return cancel_count_ack;
}

Reservation NetworkSlave::get_current_reservation() {
  return current_reservation;
}
Reservation NetworkSlave::get_next_reservation() {
  return next_reservation;
}

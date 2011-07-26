#include "NetworkSlave.h"
#include "Wire.h"

NetworkSlave::NetworkSlave() {
  name = 0;
  reserve_count = 0;
  cancel_count = 0;
  reserve_count_ack = 0;
  cancel_count_ack = 0;
  current_reservation = Reservation();
  next_reservation = Reservation();
}

void parse_data(int num_bytes {  
  //First byte will be 0 (hopefully)
  if (Wire.receive() != 0)
  {
    return;  
  }
  
  byte name_length = Wire.receive();
  char name[name_length];
  
  for(int i = 0; i < name_length; i++)
  {
    name[i] = Wire.receive();
  }
  this->name = name; 
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

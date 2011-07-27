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
  int firstByte = (int)Wire.receive();
    if (firstByte != 0)
    {
      Serial.print("Exiting, first byte was not 0");
      return;
    }
    parseName();        
    int nameLength = Wire.receive();
    char name_data[nameLength];
        
    for(int i = 0; i < nameLength; i++)
    {
      name_data[i] = Wire.receive();
    }
    this->name = name_data;
    while(Wire.available())
    {
      Serial.println("Should not enter this, miscalculated number of bytes in string");
      Wire.receive();
    }   
}

void NetworkSlave::parseName() {
  int nameLength = Wire.receive();
  char name_data[nameLength];
      
  for(int i = 0; i < nameLength; i++)
  {
    name_data[i] = Wire.receive();
  }
  
  this->name = name_data;
  
  //Free the temp string we were using
  free(name_data);
}

char* NetworkSlave::getName() {
  return name;
}

//Remove this!! for testing only
void NetworkSlave::setName(char* name) {
  this->name = name;
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

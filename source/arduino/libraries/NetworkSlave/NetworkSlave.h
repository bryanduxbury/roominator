#ifndef NetworkSlave_h
#define NetworkSlave_h
#include "Reservation.h"

class NetworkSlave {
  public:
    NetworkSlave();
    void parseData(int numBytes);
    char* getName();
    void incrementReservePressed();
    void incrementCancelPressed();
  
    int getAcknowledgedReservePresses();
    int getAcknowledgedCancelPresses();
  
    Reservation getCurrentReservation();
    Reservation getNextReservation();
    
  private:
    char * name;
    int reserveCount;
    int cancelCount;
    int reserveCountAck;
    int cancelCountAck;
    Reservation currentReservation;
    Reservation nextReservation;
};

#endif

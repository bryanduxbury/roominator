#ifndef NetworkSlave_h
#define NetworkSlave_h
#include "Reservation.h"

class NetworkSlave {
  public:
    NetworkSlave();
    char* getName();
    void incrementReservePressed();
    void incrementCancelPressed();
  
    int get_acknowledgedReservePresses();
    int get_acknowledgedCancelPresses();
  
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

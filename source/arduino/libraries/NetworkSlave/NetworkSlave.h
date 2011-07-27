#ifndef NetworkSlave_h
#define NetworkSlave_h
#include "Reservation.h"

class NetworkSlave {
  public:
    NetworkSlave();
    void parseData(int numBytes);
    char* getName();
    //Remove this, for testing only!
    void setName(char* name);
    void incrementReservePressed();
    void incrementCancelPressed();
    int getReserveCount();
    int getCancelCount();
  
    int getAcknowledgedReservePresses();
    int getAcknowledgedCancelPresses();
  
    Reservation getCurrentReservation();
    Reservation getNextReservation();
    
  private:
    void parseName();
    char * name;
    int reserveCount;
    int cancelCount;
    int reserveCountAck;
    int cancelCountAck;
    Reservation currentReservation;
    Reservation nextReservation;
};

#endif

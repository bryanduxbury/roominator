#ifndef NetworkMaster_h
#define NetworkMaster_h

#include "Reservation.h"

class NetworkMaster {
  public:
    NetworkMaster();
    void sendData(int address);
    void sendName();
    void setName(char * name);
    void incrementReserveAcknowledged();
    void incrementCancelAcknowledged();
  
    int getReservePresses();
    int getCancelPresses();
  
    void setCurrentReservation(Reservation cur);
    void setNextReservation(Reservation next);
  
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


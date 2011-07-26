#ifndef NetworkSlave_h
#define NetworkSlave_h
#include "Reservation.h"

class NetworkSlave {
  public:
    NetworkSlave();
    char* get_name();
    void increment_reserve_pressed();
    void increment_cancel_pressed();
  
    int get_acknowledged_reserve_presses();
    int get_acknowledged_cancel_presses();
  
    Reservation get_current_reservation();
    Reservation get_next_reservation();
    
  private:
    char * name;
    int reserve_count;
    int cancel_count;
    int reserve_count_ack;
    int cancel_count_ack;
    Reservation current_reservation;
    Reservation next_reservation;
};

#endif

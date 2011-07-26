#ifndef NetworkMaster_h
#define NetworkMaster_h

#include "Reservation.h"

class NetworkMaster {
  public:
    NetworkMaster();
    void set_name(char * name);
    void increment_reserve_acknowledged();
    void increment_cancel_acknowledged();
  
    int get_reserve_presses();
    int get_cancel_presses();
  
    void set_current_reservation(Reservation cur);
    void set_next_reservation(Reservation next);
  
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


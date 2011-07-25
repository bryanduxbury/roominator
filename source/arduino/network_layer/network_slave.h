#import "Reservation.h"

class NetworkSlave {
public:
  char * get_name();
  void increment_reserve_pressed();
  void increment_cancel_pressed();

  int get_acknowledged_reserve_presses();
  int get_acknowledged_cancel_presses();

  Reservation get_current_reservation();
  Reservation get_next_reservation();
}
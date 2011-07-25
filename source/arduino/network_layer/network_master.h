#import "Reservation.h"

class NetworkMaster {
public:
  void set_name(char * name);
  void increment_reserve_acknowledged();
  void increment_cancel_acknowledged();

  int get_reserve_presses();
  int get_cancel_presses();

  void set_current_reservation(Reservation cur);
  void set_next_reservation(Reservation next);
}
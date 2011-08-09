#ifndef DownstreamData_h
#define DownstreamData_h

struct Reservation {
  char msg1Line1[21];
  char msg1Line2[21];
  char msg2Line1[21];
  char msg2Line2[21];
  char msg3Line1[21];
  char msg3Line2[21];
  short secs;
};

class DownstreamData {
  public:
    DownstreamData();

    void parseAndUpdate(char* packet);

    char* getRoomName();
    Reservation* getCurrentReservation();

  private:
    char roomName[21];
    Reservation currentReservation;
};

#endif

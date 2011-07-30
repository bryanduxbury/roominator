#ifndef DownstreamData_h
#define DownstreamData_h

struct Reservation {
  char textLine1[21] = "                    ";
  char textLine2[21] = "                    ";
  short secs;
};

class DownstreamData {
  public:
    DownstreamData();

    void parseAndUpdate(char* packet);

    char* getRoomName();
    Reservation* getCurrentReservation();
    Reservation* getNextReservation();

  private:
    char roomName[21] = "  waiting to sync   ";
    Reservation currentReservation;
    Reservation pendingReservation;
};

#endif

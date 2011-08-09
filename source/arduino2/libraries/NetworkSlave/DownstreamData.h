#ifndef DownstreamData_h
#define DownstreamData_h

struct Reservation {
  char textLine1[21];
  char textLine2[21];
  char altTextLine1[21];
  char altTextLine2[21];
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

#ifndef DownstreamData_h
#define DownstreamData_h

#include "WProgram.h"

#define LED_NONE 0
#define LED_RED 1
#define LED_YELLOW 2
#define LED_GREEN 3

#define LBUTTON_DISABLED 1
#define LBUTTON_RESERVE 2
#define LBUTTON_EXTEND 3

#define RBUTTON_ENABLED 1
#define RBUTTON_DISABLED 2

struct DownstreamDataStruct {
  char roomName[21];
  char msg1Line1[21];
  char msg1Line2[21];
  char msg2Line1[21];
  char msg2Line2[21];
  char msg3Line1[21];
  char msg3Line2[21];
  byte lbutton_status;
  byte rbutton_status;
  byte statusLed;
};

class DownstreamData {
  public:
    DownstreamData();

    void parseAndUpdate(char* packet);

    char* getRoomName();
    DownstreamDataStruct* getCurrentReservation();

  private:
    DownstreamDataStruct dataStruct;
};

#endif

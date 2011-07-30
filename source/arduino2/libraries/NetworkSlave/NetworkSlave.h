#ifndef NetworkSlave_h
#define NetworkSlave_h

#include <UpstreamData.h>
#include <DownstreamData.h>

class NetworkSlave {
  public:
    NetworkSlave();
    void setDownstreamData(char*);
    void reserve();
    void cancel();
    int getReserve();
    int getCancel();
    bool getCurrentReservation();
    bool getPendingReservation();
    void setDisplayString(char *displayString);
    char* getDisplayString();
    void clearCounts();

    void handleReceive(int numBytes);

  private:
    UpstreamData ud;
    DownstreamData dd;

    void readFully(char* buf);
};

#endif

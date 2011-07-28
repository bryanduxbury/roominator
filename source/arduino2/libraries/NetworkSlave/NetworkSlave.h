#ifndef NetworkSlave_h
#define NetworkSlave_h

#include <UpstreamData.h>
#include <DownstreamData.h>

class NetworkSlave {
  public:
    NetworkSlave();
    char* getUpstreamData();
    void setDownstreamData(char*);
    void reserve();
    void cancel();
    char* getDisplayString();
  
  private:
    UpstreamData *ud;
    DownstreamData *dd;
};

#endif

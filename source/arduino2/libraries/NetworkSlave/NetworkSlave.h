#ifndef NetworkSlave_h
#define NetworkSlave_h

class NetworkSlave {
  public:
    NetworkSlave();
    byte* getUpstreamData();
    void processDownstreamData(byte *);
    void reserve();
    void cancel();
    char* getDisplayString();
  
  private:
    UpstreamData *ud
    DownstreamData *dd;
};

#endif

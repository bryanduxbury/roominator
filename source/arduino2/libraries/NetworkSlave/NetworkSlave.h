#ifndef NetworkSlave_h
#define NetworkSlave_h

class NetworkSlave {
  public:
    NetworkSlave();
    void onRequest();
    void onReceive();
  
  private:
    int reserve;
    bool cancel;
    bool currentReservation;
    bool pendingReservation;
    
    UpstreamData getUpstreamData();
    DownstreamData getDownstreamData();
};

#endif


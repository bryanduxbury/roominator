#ifndef UpstreamData_h
#define UpstreamData_h

class UpstreamData {
  public:
    UpstreamData();
    void setReserve(int value);
    int getReserve();  
    void setCancel(bool value);
    bool getCancel();

  private:
    int reserve;
    bool cancel;
};

#endif

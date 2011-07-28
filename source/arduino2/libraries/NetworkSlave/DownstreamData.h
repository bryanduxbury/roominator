#ifndef DownstreamData_h
#define DownstreamData_h

class DownstreamData {
  public:
    DownstreamData();
    bool getCurrentReservation();
    void setCurrentReservation(bool value);
    bool getPendingReservation();
    void setPendingReservation(bool value);
    char* getDisplayString();
    void setDisplayString(char value[]);
    
  private:
    bool currentReservation;
    bool pendingReservation;
    char displayString[80];
};

#endif
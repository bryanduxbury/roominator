class UpstreamData {
  public:
    void setReserve(int value);
    int getReserve();  
    void setCancel(bool value);
    bool getCancel();
  
  private:
    int reserve;
    bool cancel;
}

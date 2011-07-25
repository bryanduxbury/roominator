// DisplayController.h

class DisplayController {
public:
  DisplayController(char[] name);
  DisplayColor getDisplayColor();
  void setDisplayColor();
  
  void onPressReserveOrExtend();
  void onPressCancel();

private:
  char[] name;
  DisplayColor displayColor;
};

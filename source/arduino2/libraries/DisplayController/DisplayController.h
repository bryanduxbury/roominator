// DisplayController.h

#include "WProgram.h"
#include "NetworkSlave.h"

enum DisplayColor {
  GREEN,
  YELLOW,
  RED
};

class DisplayController {
public:
  DisplayController(LiquidCrystal* lcd, NetworkSlave* slave, int redPin, int yellowPin, int greenPin);

  void onPressReserveOrExtend();
  void onPressCancel();

  void begin();

  // Do all the actual display logic.
  void draw();

private:
  LiquidCrystal* lcd;
  NetworkSlave* slave;

  char _displayName[21];

  int redPin;
  int yellowPin;
  int greenPin;

  unsigned long lastStateChangeMillis;
  int msgNum;

  void setHigh(int displayColor);
};

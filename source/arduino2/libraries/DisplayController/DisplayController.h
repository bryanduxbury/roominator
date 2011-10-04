// DisplayController.h

#include "WProgram.h"
#include "NetworkSlave.h"
#include <BounceButton.h>

class DisplayController {
public:
  DisplayController(LiquidCrystal* lcd, NetworkSlave* slave, int redPin, int yellowPin, int greenPin, BounceButton* reserveButton, BounceButton* cancelButton);

  void onPressReserveOrExtend();
  void onPressCancel();

  void begin();

  // Do all the actual display logic.
  void draw();

private:
  LiquidCrystal* lcd;
  NetworkSlave* slave;
  BounceButton* reserveButton;
  BounceButton* cancelButton;

  char _displayName[21];

  int redPin;
  int yellowPin;
  int greenPin;

  unsigned long lastStateChangeMillis;
  int msgNum;

  void setHigh(int displayColor);
  void setOrResetDeviceId();
  int getId();
};

// DisplayController.h

#include "WProgram.h"

enum DisplayColor {
	GREEN,
	YELLOW,
	RED
};

class DisplayController {
public:
  DisplayController(char displayName[], int redPin, int yellowPin, int greenPin);
  void setDisplayColor(DisplayColor displayColor);
  void onPressReserveOrExtend();
  void onPressCancel();

private:
  char _displayName[];
  DisplayColor _displayColor;
  int redPin;
  int yellowPin;
  int greenPin;
  
  void setHigh(DisplayColor displayColor);
};

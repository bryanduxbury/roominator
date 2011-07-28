// DisplayController.h

#include "WProgram.h"

enum DisplayColor {
	GREEN,
	YELLOW,
	RED
};

class DisplayController {
public:
  DisplayController(char displayName[]);
  void setDisplayColor(DisplayColor displayColor);
  void onPressReserveOrExtend();
  void onPressCancel();

private:
  char _displayName[];
  DisplayColor _displayColor;
  
  void setHigh(DisplayColor displayColor);
};

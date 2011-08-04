#ifndef LONG_WIRE_SLAVE_H_
#define LONG_WIRE_SLAVE_H_

#include <inttypes.h>
#include <Wire.h>
#include "WProgram.h"

class LongWireSlave {
public:
  LongWireSlave(int address, int bufferSize, void (*onReceiveHandler)(int), void (*onRequestHandler)(void));

  void onRequest();
  void onReceive(int numBytes);

  int available();
  int receive();

private:

  void readFully(byte* buf);
  void skip();

  void (*user_onReceive)(int);
  void (*user_onRequest)(void);
  byte* buffer;
  int off;
  int limit;
  int capa;
  int lastFrame;

};

#endif
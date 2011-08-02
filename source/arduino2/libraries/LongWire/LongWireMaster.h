#ifndef LONG_WIRE_MASTER_H_
#define LONG_WIRE_MASTER_H_

#include <inttypes.h>
#include <Wire.h>

class LongWireMaster {
public:
  LongWireMaster(size_t bufferSize);
  void beginTransmission(int address);
  void send(byte b);
  void send(char* str);
  void send(byte* data, size_t size);
  int endTransmission();

private:
  byte* sendBuffer;
  int off;
  int limit;
  int capa;
};

#endif
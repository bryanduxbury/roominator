#ifndef LONG_WIRE_MASTER_H_
#define LONG_WIRE_MASTER_H_

#include <inttypes.h>
#include <Wire.h>

class LongWireMaster {
public:
  LongWireMaster(int bufferSize);
  void begin();

  void beginTransmission(int address);
  void send(uint8_t b);
  void send(char* str);
  void send(uint8_t* data, int size);
  int endTransmission();

private:
  uint8_t* buffer;
  int address;
  int off;
  int limit;
  int capa;
};

#endif
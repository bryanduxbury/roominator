#include "LongWireMaster.h"
#include "WProgram.h"

LongWireMaster::LongWireMaster(int bufferSize) {
  this->buffer = (uint8_t*)malloc(bufferSize);
  this->capa = bufferSize;
  this->off = 0;
  this->limit = 0;
}

void LongWireMaster::begin() {
  Wire.begin();
}

void LongWireMaster::beginTransmission(int address) {
  this->address = address;
}

void LongWireMaster::send(byte b) {
  this->buffer[off++] = b;
  limit = off;
}

void LongWireMaster::send(char* str) {
  while (*str != '\0') {
    send((byte)*(str++));
  }
}

void LongWireMaster::send(uint8_t* data, int size) {
  for (int i = 0; i < size; i++) {
    send(*(data++));
  }
}

int LongWireMaster::endTransmission() {
  off = 0;
  uint8_t* tmpBuffer = buffer;

  int frameNum = 0;
  while (off < limit) {
    int toWrite = min(30, limit - off);
    Wire.beginTransmission(address);
    Wire.send((byte)frameNum);
    Wire.send((byte)toWrite);
    Wire.send(buffer, toWrite);
    int result = Wire.endTransmission();
    if (result != 0) {
      return result;
    }
    buffer+=toWrite;
    off+=toWrite;
  }
}
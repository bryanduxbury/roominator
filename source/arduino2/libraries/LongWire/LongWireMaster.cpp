#include "LongWireMaster.h"

LongWireMaster::LongWireMaster(size_t bufferSize) {
  this->buffer = (byte*)malloc(bufferSize + 2) + 2;
  this->capa = bufferSize;
  this->off = 0;
  this->limit = 0;
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

void LongWireMaster::send(byte* data, size_t size) {
  for (int i = 0; i < size; i++) {
    send(*(data++));
  }
}

int LongWireMaster::endTransmission() {
  this->off = -2;
  buffer[-1] = this->limit & 0xFF;
  buffer[-2] = (this->limit >> 8) & 0xFF;
  

  Wire.send(frameSize, 2);
  
  int availSpace = 30;
  
  while (off < limit) {
    Wire.beginTransmission(address);
    Wire.send
    availSpace = 32;
  }
}
#include "LongWireMaster.h"
#include "Arduino.h"

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
  // Serial.print("off: ");
  // Serial.print(off);
  // Serial.print("lim: ");
  // Serial.print(limit);
  // Serial.println();
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
  // special hack here: if the message size just happens to be an integral 
  // number of packets, we have to send a final packet of size zero to cap
  // things off.
  // TODO: this could definitely be better. redo this at some point.
  while (off < limit+1) {
    int toWrite = min(30, limit - off);
    Wire.beginTransmission(address);
    Wire.write((byte)frameNum);
    Wire.write((byte)toWrite);
    Wire.write(buffer, toWrite);
    int result = Wire.endTransmission();
    if (result != 0) {
      return result;
    }
    buffer+=toWrite;
    off+=toWrite;
    frameNum++;
  }
  off = 0;
  limit = 0;
}

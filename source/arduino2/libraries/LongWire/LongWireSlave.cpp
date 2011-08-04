#include "LongWireSlave.h"

LongWireSlave::LongWireSlave(int address, int bufferSize, void (*onReceiveHandler)(int), void (*onRequestHandler)(void)) {
  this->buffer = (byte*) malloc(bufferSize);
  this->user_onReceive = onReceiveHandler;
  this->user_onRequest = onRequestHandler;
  capa = bufferSize;
  off = 0;
  limit = 0;
  lastFrame = -1;

  // Wire.begin(address);
}

void LongWireSlave::onRequest() {
  
}

void LongWireSlave::onReceive(int numBytes) {
  int frameNum = -1;
  if (Wire.available()) {
    frameNum = Wire.receive();
  } else {
    // this is a garbage message of some sort.
    Serial.println("Couldn't read a frame num. aborting message.");
    return;
  }
  Serial.print("Received frame ");
  Serial.println(frameNum);

  int frameSize = 0;
  if (Wire.available()) {
    frameSize = Wire.receive();
  } else {
    // this is a garbage message
    Serial.println("Couldn't read a frame size. aborting message.");
    return;
  }
  Serial.print("Read frame size ");
  Serial.println(frameSize);

  if (frameNum == 0) {
    // hard to say what happened to to the end of the last message, but we're
    // just going to start over since this is the beginning of a new message.
    Serial.println("Read frame 0 of a message, so resetting to the begginning of message");
    limit = 0;
    off = 0;
    lastFrame = -1;
  }

  // now check if this frame is in sequence
  if (frameNum == lastFrame + 1) {
    // the frame is in sequence, so read the rest of the available bytes into the buffer
    readFully(buffer+limit);
    // increment the limit
    limit += frameSize;
    // if the frame was smaller than 30 bytes, that signals the end of the message.
    if (frameSize < 30) {
      Serial.println("message end reached, trigger handler");
      // trigger the onReceive handler
      user_onReceive(limit);
      // reset all our variables for the next message
      lastFrame = -1;
      limit = 0;
      off = 0;
      return;
    } else {
      // there are more frames to come, so just update our lastFrame
      Serial.print("Read ");
      Serial.print(frameSize);
      Serial.println(" bytes of frame, waiting for more frames to complete message");
      lastFrame = frameNum;
    }
  } else {
    // the frame we just got was out of sequence for some reason, so let's skip it.
    Serial.println("skipping out-of-sequence frame");
    skip();
  }
}

void LongWireSlave::readFully(byte* buf) {
  while (Wire.available()) {
    *buf = Wire.receive();
    buf++;
  }
}

void LongWireSlave::skip() {
  while (Wire.available()) {
    Wire.receive();
  }
}

int LongWireSlave::available() {
  return limit - off;
}

int LongWireSlave::receive() {
  return buffer[off++];
}
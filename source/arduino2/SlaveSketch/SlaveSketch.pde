#include <LongWireMaster.h>
#include <LongWireSlave.h>

#include <Wire.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>

#include <NetworkSlave.h>

#include <DisplayController.h>
#include <BounceButton.h>
#include <string.h>

// [GreenPin, YellowPin, RedPin, ResPin, CancelPin, LCD1, LCD2, LCD3, LCD4, LCD5, LCD6, I2CAddress]
//Junior
//int fig[] = {4,3,2,6,5,8,9,10,11,12,13,1};

//Senior 
//int fig[] = {4,3,2,6,5,8,9,10,11,12,13,2};

//Nuevo
int fig[] = {6,5,4,3,2,13,12,11,10,9,8,3};


NetworkSlave slave;
BounceButton reserve(fig[3]);
BounceButton cancel(fig[4]);

LiquidCrystal lcd(fig[5], fig[6], fig[7], fig[8], fig[9], fig[10]);
DisplayController dc(&lcd, &slave, fig[2], fig[1], fig[0], &reserve, &cancel);


LongWireSlave wireSlave(fig[11], sizeof(DownstreamDataStruct), handleFullReceive, handleFullRequest);

void setup() {
  Serial.begin(115200);
  dc.begin();
  reserve.initialize();
  cancel.initialize();
  
//  Wire.begin(fig[11]);
  Wire.onReceive(handleReceive);
  Wire.onRequest(handleRequest);
}

void loop() {
  if (reserve.check()) {
    slave.reserve();
  }

  if (cancel.check()) {
    slave.cancel();
  }

  dc.draw();
  delay(50);
}

void handleRequest() {
  Serial.println("in request");
  Wire.send((slave.getCancel()) ? 0xFF : slave.getReserve());
  slave.clearCounts();
}

void handleFullRequest() {
}


void handleReceive(int numBytes) {
  Serial.println("in handleReceive");
  Serial.print("num bytes: ");
  Serial.println(numBytes);
  wireSlave.onReceive(numBytes);
}

void handleFullReceive(int numBytes) {
  Serial.print("handleFullReceive with ");
  Serial.println(numBytes);
  char buf[sizeof(DownstreamDataStruct)];
  char* ptr = buf;
  int i = 0;
  while (wireSlave.available()) {
    (*ptr++) = (char)wireSlave.receive();
    i++;
  }
  Serial.print("read a total of ");
  Serial.println(i);
  slave.setDownstreamData(buf);
}

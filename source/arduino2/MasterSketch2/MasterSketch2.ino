#include <Wire.h>
#include "Messages.h"
#include <Ethernet.h>
#include <SPI.h>

char* failedLine1   = "       master       ";
char* failedLine2   = "  failed to connect ";
char* failedLine3   = "    to app server!  ";
char* failedLine4   = "                    ";

EthernetClient client;

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
//byte ip[] = { 10, 99, 33, 128 };
//byte gateway[] = { 10, 99, 33, 254 };
//byte mask[] = { 255, 255, 254, 0 }; 

byte ip[] = { 10, 0, 0, 2 };
byte gateway[] = { 10, 0, 0, 1 };
byte mask[] = { 255, 255, 255, 0 }; 

//byte appServerAddr[] = {10,99,32,69};
byte appServerAddr[] = {10,0,0,1};

void setup() {
  Ethernet.begin(mac, ip, gateway, mask);
  Wire.begin();
  Serial.begin(9600);
  
  delay(1000);
}

void loop() {
  for (int i = 0; i < 5; i++) {
    Wire.requestFrom(i, 1);
    int statusCode = -1;
    while (Wire.available()) {
      if (statusCode == -1) statusCode = Wire.read();
      Wire.read();
    }
    Serial.print("Node ");
    Serial.print(i);
    if (statusCode == -1) {
      Serial.println(" is unreachable");
    } else {
      Serial.print(" is online with status code: ");
      Serial.println(statusCode);
      
      if (client.connect(appServerAddr, 80)) {
        client.print("GET /room/report?id=");
        client.print(i);
        client.println(" HTTP/1.0");
        client.println();
        
        // wait until *something* is available
        while (client.available() == 0) {delay(10);}
        
        // skip the header
        boolean inHeader = true;
        char lastChar = 0;
        char lastLastChar = 0;
        char lastLastLastChar = 0;
        while (client.available() > 0) {
          char c = client.read();
          if (c == '\n' && lastChar == '\r' && lastLastChar == '\n' && lastLastLastChar == '\r') {
            inHeader = false;
            break;
          }
          lastLastLastChar = lastLastChar;
          lastLastChar = lastChar;
          lastChar = c;
        }
        
        char blob[85];
        int idx = 0;
        while (client.available() > 0) {
          blob[idx++] = client.read();
        }
        if (idx != 85) {
          Serial.println("Malformed message!");
          // todo: send malformed message notification
        } else {
          // send server's message to display
          sendString(i, 1, blob);
          sendString(i, 2, blob + 21);
          sendString(i, 3, blob + 42);
          sendString(i, 4, blob + 63);
          sendFlags(i, (int)(blob[84]));
        }
      } else {
        Serial.println("Couldn't connect to app server.");
        sendString(i, 1, failedLine1);
        delay(50);
        sendString(i, 2, failedLine2);
        delay(50);
        sendString(i, 3, failedLine3);
        delay(50);
        sendString(i, 4, failedLine4);
        delay(50);
        sendFlags(i, 0);
      }
      client.stop();
    }
  }
  delay(1000);
}

void sendString(int addr, int messageCode, char* str) {
  Wire.beginTransmission(addr);
  Wire.write(messageCode);
  Wire.write(str);
  Wire.endTransmission();
}

void sendFlags(int addr, int ledNum) {
  Wire.beginTransmission(addr);
  Wire.write(7);
  Wire.write(ledNum);
  Wire.endTransmission();
}

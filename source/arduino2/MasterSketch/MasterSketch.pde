#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <SPI.h>
#include <Wire.h>
#include <Ethernet.h>
#include <EEPROM.h>

#include "LongWireMaster.h"
#include "DownstreamData.h"

// byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; //mac address of master arduino
// byte ip[] = { 10, 99, 33, 128 }; 
// byte gateway[] = { 10, 99, 33, 1 }; 
// byte subnet[] = { 255, 255, 254, 0 };

// byte server[] = {10, 99, 32, 33}; //Gabe's comp
byte app_server[4];

#define MAC 0
#define IP_ADDR 6
#define GATEWAY 10
#define SUBNET 14
#define APP_SERVER 18

Client *client;

LongWireMaster wireMaster(sizeof(DownstreamDataStruct));

void setup() {
  Serial.begin(9600);  //For debugging, take out eventually

  byte mac[] = {EEPROM.read(MAC), EEPROM.read(MAC+1), EEPROM.read(MAC+2), EEPROM.read(MAC+3), EEPROM.read(MAC+4), EEPROM.read(MAC+5)};
  byte ip[] = {EEPROM.read(IP_ADDR), EEPROM.read(IP_ADDR+1), EEPROM.read(IP_ADDR+2), EEPROM.read(IP_ADDR+3)};
  byte gateway[] = {EEPROM.read(GATEWAY), EEPROM.read(GATEWAY+1), EEPROM.read(GATEWAY+2), EEPROM.read(GATEWAY+3)};
  byte subnet[] = {EEPROM.read(SUBNET), EEPROM.read(SUBNET+1), EEPROM.read(SUBNET+2), EEPROM.read(SUBNET+3)};

  app_server[0] = EEPROM.read(APP_SERVER);
  app_server[1] = EEPROM.read(APP_SERVER+1);
  app_server[2] = EEPROM.read(APP_SERVER+2);
  app_server[3] = EEPROM.read(APP_SERVER+3);

  wireMaster.begin();
  Ethernet.begin(mac, ip, gateway, subnet);
}

void loop()
{
  if (client == NULL) {
    client = &Client(app_server, 80);
  }

  int payload;
  int cancel;
  int reserveCount;

  //Loop over addresses 1 thru 9
  for(int i = 1; i < 10; i++) {
    Serial.println("before");
    Wire.requestFrom(i, 1); //request 1 bytes from slave
    Serial.println("after");

    //if the slave is responsive...
    if (Wire.available()) {
      Serial.print("Got response from slave: ");
      Serial.println(i);
      payload = (int) Wire.receive();
      if (payload == 255) {
        cancel = 1;
        reserveCount = 0;
      } else {
        cancel = 0;
        reserveCount = payload;
      }

      char message[100];
      generatePostRequest(i, reserveCount, cancel, message);
 
      while(!client->connect()) {
        Serial.println("Could not connect, trying again");
      }
      Serial.println("Connected to server, sending request");
      //Send request
      client->println(message);
      client->println();

      Serial.println("Waiting for server response");
      while(!client->available()) {delay(10);}

      Serial.println("Got response from server");

      char response[sizeof(DownstreamDataStruct)];
      parseHttpResponse(response);
//      for (int i = 0; i < 109; i++) {
//        Serial.println((int)response[i]);
//      }
      sendDownstreamPacket(i, response);

      client->stop();
      Serial.println("Disconnected from server");
    } else {
      Serial.print("Slave was not responsive: ");
      Serial.println(i);
    }
  }
}

void sendDownstreamPacket(int id, char* message) {
  //Construct a one payload message.
//  Serial.println("Sending response to slave");
  wireMaster.beginTransmission(id);
  wireMaster.send((byte*)message, sizeof(DownstreamDataStruct));
  wireMaster.endTransmission();
}

//Parses http response and stores downstreampacket in message
void parseHttpResponse(char* message) {
  throwAwayHeader();
  for (int i = 0; i < sizeof(DownstreamDataStruct) && client->available(); i++) {
    *message = (char) client->read();
    message++;
  }
  while (client->available()) {
    client->read();
  }
}

void throwAwayHeader() {
  while(client->available()) {
   byte c = (byte) client->read();
   if(c == 200) {
     //Return with next digit to be the message
     return;
   }
 }
}

void generatePostRequest(int id, int reservationCount, int cancelCount, char* message) {
  sprintf(message, "GET /room/report?id=%u&rsv=%u&cancel=%u HTTP/1.0", id, reservationCount, cancelCount);
}


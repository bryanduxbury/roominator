#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <SPI.h>
#include <Wire.h>
#include <Ethernet.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; //mac address of master arduino
byte ip[] = { 10, 0, 0, 2 }; //IP address of arduino
byte gateway[] = { 10, 0, 0, 1 }; //IP address of router in office
byte subnet[] = { 255, 255, 255, 0 }; //subnet mask of office network

byte server[] = {10, 0, 0, 3 }; //Gabe's comp

Client client(server, 3000);

void setup()
{
//  Serial.begin(9600);  //For debugging, take out eventually
  Wire.begin(); //join bus as master
  Ethernet.begin(mac, ip, gateway, subnet);
  delay(1000);
}

void loop()
{
  int payload;
  int cancel;
  int reserveCount;

  delay(1000);

  //Loop over addresses 1 thru 9
  for(int i = 1; i < 9; i++) {
//    Serial.println("before");
    Wire.requestFrom(i, 1); //request 1 bytes from slave
//    Serial.println("after");

    //if the slave is responsive...
    if (Wire.available()) {
//      Serial.print("Got response from slave: ");
//      Serial.println(i);
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
 
      while(!client.connect()) {
//        Serial.println("Could not connect, trying again");
      }
//      Serial.println("Connected to server, sending request");
      //Send request
      client.println(message);
      client.println();

//      Serial.println("Waiting for server response");
      while(!client.available()) {delay(10);}

//      Serial.println("Got response from server");

      char response[109];
      parseHttpResponse(response);
//      for (int i = 0; i < 109; i++) {
//        Serial.println((int)response[i]);
//      }
      sendDownstreamPacket(i, response);

      client.stop();
//      Serial.println("Disconnected from server");
    } else {
//      Serial.print("Slave was not responsive: ");
//      Serial.println(i);
    }
  }
}

void sendDownstreamPacket(int id, char* message) {
  //Construct a one payload message.
//  Serial.println("Sending response to slave");
  Wire.beginTransmission(id);
  Wire.send((byte*)message, 109);
  Wire.endTransmission();
}

//Parses http response and stores downstreampacket in message
void parseHttpResponse(char* message) {
  throwAwayHeader();
  for (int i = 0; i < 109 && client.available(); i++) {
    *message = (char) client.read();
    message++;
  }
  while (client.available()) {
    client.read();
  }
}

void throwAwayHeader() {
  while(client.available()) {
   byte c = (byte) client.read();
   if(c == 200) {
     //Return with next digit to be the message
     return;
   }
 }
}

void generatePostRequest(int id, int reservationCount, int cancelCount, char* message) {
  sprintf(message, "GET /room/report?id=%u&rsv=%u&cancel=%u HTTP/1.0", id, reservationCount, cancelCount);
}


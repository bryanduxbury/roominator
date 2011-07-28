#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <SPI.h>
#include <Wire.h>
#include <Ethernet.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; //mac address of master arduino
byte ip[] = { 10, 99, 33, 128 }; //IP address of arduino
byte gateway[] = { 10, 99, 33, 254 };
byte subnet[] = { 255, 255, 254, 0 };

byte server[] = {10, 99, 32, 130 }; //My comp

int slaves[] = { 1 }; //Put addresses for slaves here

Client client(server, 3000);

void setup()
{
  Wire.begin();
  Ethernet.begin(mac, ip, gateway, subnet);
  Serial.begin(9600); 
  delay(1000);
}

void loop()
{
  Wire.requestFrom(1,2); //request 2 bytes from slave 1
  int cancel = Wire.receive();
  Serial.print("Cancel byte is: ");
  Serial.println(cancel);
  int reserveCount = Wire.receive();
  
  Serial.print("rsv byte is: ");
  Serial.println(reserveCount);
  
  if (client.connect()) 
  {
    Serial.println("connected");
    client.println(generatePostRequest(1, reserveCount, cancel));
    client.println();
  } 
  else
  {
    Serial.println("connection failed");
  }
  
  while(!client.available())
  {
    //nop
  }
  
  while(client.available())
  {
      char c = client.read();
      Serial.print(c);  
  }
}

//void setup()
//{
//  Ethernet.begin(mac, ip, gateway, subnet);
//  Serial.begin(9600);
//
//  delay(1000);
//
//  Serial.println("connecting...");
//  
//  if (client.connect()) 
//  {
//    Serial.println("connected");
//    Serial.print("String generated from function is: ");
//    Serial.println(generatePostRequest(1,2,3));
//    client.println(generatePostRequest(1,2,3));
//    client.println();
//  } 
//  else
//  {
//    Serial.println("connection failed");
//  }
//}
//
//void loop()
//{
//  if (client.available()) {
//    char c = client.read();
//    Serial.print(c);
//  }
//
//  if (!client.connected()) 
//  {
//    Serial.println();
//    Serial.println("disconnecting.");
//    client.stop();
//    for(;;)
//      ;
//  }
//}

char* generatePostRequest(int id, int reservationCount, int cancelCount)
{
  char string[100];
  char temp[100];
  
  strcpy(string, "GET /room/report?id=");
  sprintf(temp, "%u", id);
  strcat(string, temp); 
  
  strcat(string, "&rsv=");
  sprintf(temp, "%u", reservationCount);
  strcat(string, temp);

  strcat(string, "&cancel=");  
  sprintf(temp, "%u", cancelCount);
  strcat(string, temp);
  
  strcat(string, " HTTP/1.0");
  
  free(temp);
  return string;
}


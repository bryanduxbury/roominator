#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include <SPI.h>
#include <Wire.h>
#include <Ethernet.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; //mac address of master arduino
byte ip[] = { 10, 99, 33, 128 }; //IP address of arduino
byte gateway[] = { 10, 99, 33, 254 }; //IP address of router in office
byte subnet[] = { 255, 255, 254, 0 }; //subnet mask of office network

byte server[] = {10, 99, 32, 39 }; //My comp

int slaves[] = { 1 }; //Put addresses for slaves here

Client client(server, 3000);

void setup()
{
  Serial.begin(9600);  //For debugging, take out eventually
  Wire.begin(); //join bus as master
  Ethernet.begin(mac, ip, gateway, subnet);
  delay(1000);  
}

void loop()
{
  int payload;
  int cancel;
  int reserveCount;
  
  //Loop over addresses 1 thru 9
  for(int i = 1; i < 9; i++)
  {
    Serial.println("Before request");
    Serial.print(i);
    Wire.requestFrom(i, 1); //request 1 bytes from slave
    Serial.println("After request");
    if (Wire.available()) //if the slave is responsive
    {  
      Serial.print("Got data from slave: ");
      Serial.println(i);  
      payload = (int) Wire.receive();
    
      if (payload == 255)
      {
        cancel = 1;
        reserveCount = 0;
      }
      else 
      {
        cancel = 0;
        reserveCount = payload;
      }      
      
      Serial.print("Cancel byte is: ");
      Serial.println(cancel);
      Serial.print("rsv byte is: ");
      Serial.println(reserveCount);
      
      char* message = (char*) malloc(100);
      generatePostRequest(1, reserveCount, cancel, message);
 
      while(!client.connect())
      {
        Serial.println("Could not connect, trying again");
      }
      Serial.println("Connected to server");
      //Send request
      client.println(message);
      client.println();
      free(message);
      
      Serial.println("Waiting for server response");
      while(!client.available())
      {
        Serial.println("server response not available yet");
      }
      
      char* response = (char*) malloc(500);
      int lightNumber = parseHttpResponse(response);
      sendDownstreamPacket(i, lightNumber, response);
      free(response);

      client.stop();
      Serial.println("Disconnected from server");
    }
    else
    {
      Serial.print("Slave was not responsive: ");
      Serial.println(i);
    }
  }
}


void sendDownstreamPacket(int id, int lightNumber, char* message)
{
  
  Serial.print("Light number is: ");
  Serial.println(lightNumber);
  Serial.print("In send Downstream packet, the packet I would have sent is: ");
  Serial.print(message);
  Serial.print(" to id:");
  Serial.println(id);
  
  char string[80];
  string[0] = (char) lightNumber;
  string[1] = (char) strlen(message);
  strcat(string, message);
  
  Serial.print("String: "); 
  Serial.println(string);
  
  Wire.beginTransmission(id);
  Wire.send(string);
  Wire.endTransmission();

}

//Parses http response and stores downstreampacket in message
int parseHttpResponse(char* message)
{
  throwAwayHeader();
  int lightNumber = (int) client.read();
  int count = 0;
  char c;
  byte b;
  while(client.available())
  {
    c = client.read();
    b = (byte) c;
    //Got ending char
    if(b == 200)
    {
      message[count] = '\0';
      client.flush();
      return lightNumber;
    }
    message[count] = c;
    count++;
  }
}

void throwAwayHeader()
{
  while(client.available())
 {
   byte c = (byte) client.read();
   if(c == 200) 
   {
     //Return with next digit to be the message
     return;  
   }
 } 
}

void generatePostRequest(int id, int reservationCount, int cancelCount, char* message)
{
  char temp[5];
  
  strcpy(message, "GET /room/report?id=");
  sprintf(temp, "%u", id);
  strcat(message, temp); 
  
  strcat(message, "&rsv=");
  sprintf(temp, "%u", reservationCount);
  strcat(message, temp);

  strcat(message, "&cancel=");
  sprintf(temp, "%u", cancelCount);
  strcat(message, temp);
  
  strcat(message, " HTTP/1.0");
}


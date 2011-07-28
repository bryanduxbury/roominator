#include <string.h>

#include <SPI.h>
#include <Wire.h>
#include <Ethernet.h>


byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED }; //mac address of master arduino
byte ip[] = { 10, 99, 33, 128 }; //IP address of arduino
byte gateway[] = { 10, 99, 33, 254 };
byte subnet[] = { 255, 255, 254, 0 };

byte server[] = {10, 99, 32, 130 }; //My comp
//byte server[] = { 72, 125, 93, 99 }; //Google.com

Client client(server, 3000);

void setup()
{
  Ethernet.begin(mac, ip, gateway, subnet);
  Serial.begin(9600);

  delay(1000);

  Serial.println("connecting...");
  
  if (client.connect()) 
  {
    Serial.println("connected");
    client.println("GET /search?q=arduino HTTP/1.0");
    client.println();
  } 
  else
  {
    Serial.println("connection failed");
  }
}

void loop()
{
  if (client.available()) {
    char c = client.read();
    Serial.print(c);
  }

  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    for(;;)
      ;
  }
}


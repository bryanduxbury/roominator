#include <Wire.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>
#include <BounceButton.h>

#define L1 1
#define L2 2
#define L3 3
#define L4 4

char * line1 = "                    ";
char * line2 = "   waiting to sync  ";
char * line3 = "     with master    ";
char line4[21];

#define FLAGS 7

#define LED_NONE 0
#define LED_RED 1
#define LED_YELLOW 2
#define LED_GREEN 3

volatile int statusLed = LED_NONE;

unsigned int counter = 0;

LiquidCrystal lcd(13,12,11,10,9,8);

#define RED_PIN 4
#define YELLOW_PIN 5
#define GREEN_PIN 6

#define LBUTTON_PIN 2
#define RBUTTON_PIN 3
BounceButton lButton(LBUTTON_PIN);
BounceButton rButton(RBUTTON_PIN);

volatile unsigned int lButtonCounter = 0;
volatile unsigned int rButtonCounter = 0;

void setup() {
  strcpy(line4, line1);
  
//  Serial.begin(9600);
  lButton.initialize();
  rButton.initialize();
  
  pinMode(RED_PIN, OUTPUT);
  pinMode(YELLOW_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  digitalWrite(RED_PIN, HIGH);
  digitalWrite(YELLOW_PIN, HIGH);
  digitalWrite(GREEN_PIN, HIGH);

  lcd.begin(20,4);
  post();
  
  setOrResetDeviceId();
  
  Wire.begin(EEPROM.read(0));
//  Wire.begin(1);
  Wire.onRequest(requestHandler);
  Wire.onReceive(receiveHandler);
}

void post() {
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("####################");
  lcd.setCursor(0,1);
  lcd.print("#     SELF TEST    #");
  lcd.setCursor(0,2);
  lcd.print("#                  #");
  lcd.setCursor(0,3);
  lcd.print("####################");

  digitalWrite(RED_PIN, LOW);
  delay(750);
  digitalWrite(YELLOW_PIN, LOW);
  delay(750);
  digitalWrite(GREEN_PIN, LOW);

  lcd.setCursor(0,2);
  lcd.print("#     COMPLETE!    #");

  delay(2000);

  digitalWrite(RED_PIN, HIGH);
  digitalWrite(YELLOW_PIN, HIGH);
  digitalWrite(GREEN_PIN, HIGH);
  lcd.clear();
}

void setOrResetDeviceId() {
  int deviceId = EEPROM.read(0);
  lcd.setCursor(0,0);

  if (deviceId == 0) {
    lcd.print("No Display ID set.");
    delay(2000);
    deviceId = getId();
  } else {
    long startMillis = millis();
    
    while(true) {
      long curMillis = millis();
      if (curMillis - startMillis > 6000) {
        break;
      }

      lcd.setCursor(0,0);
      lcd.print("Current ID: ");
      lcd.print(deviceId);
      lcd.setCursor(0,1);
      lcd.print("Press and hold both ");
      lcd.setCursor(0,2);
      lcd.print("buttons in the next ");
      lcd.setCursor(0,3);
      lcd.print((5000 - (curMillis-startMillis)) / 1000);
      lcd.print(" secs to change");
      
      
      bool res = lButton.check();
      bool can = rButton.check();
      if (res && can) {
        deviceId = getId();
        break;
      }
      delay(10);
    }
  }

  // store the device id back into the eeprom
  EEPROM.write(0, deviceId);

  // boot up the i2c interface with the provided device ID
  Wire.begin(deviceId);

  lcd.clear();
}

int getId() {
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Current value:");
  lcd.setCursor(0,3);
  lcd.print("Increment     Accept");
  while(lButton.check() || rButton.check()){delay(100);}

  int deviceId = 1;
  int i = 0;
  while (true) {
    i++;
    if (lButton.check()) {
      deviceId++;
      if (deviceId == 33) {
        deviceId = 1;
      }
      while(lButton.check()){}
    }
    if (rButton.check()) {
      break;
    }
    lcd.setCursor(0,1);
    lcd.print(deviceId);
    delay(10);
  }
  lcd.setCursor(0,2);
  lcd.print("      Accepted!     ");
  lcd.setCursor(0,3);
  lcd.print("                    ");
  delay(2000);
  
  return deviceId;
}

void loop() {
  if (lButton.check()) {
    lButtonCounter++;
  }

  if (rButton.check()) {
    rButtonCounter++;
  }
  
//  noInterrupts();
  lcd.setCursor(0, 0);
  lcd.print(line1);
  lcd.setCursor(0, 1);
  lcd.print(line2);
  lcd.setCursor(0, 2);
  lcd.print(line3);
  lcd.setCursor(0, 3);
  lcd.print(line4);
  
  // toggle all leds off
  digitalWrite(RED_PIN, HIGH);
  digitalWrite(YELLOW_PIN, HIGH);
  digitalWrite(GREEN_PIN, HIGH);
  
  // turn on the selected one, if any
  if (statusLed == LED_RED) {
    digitalWrite(RED_PIN, LOW);
  } else if (statusLed == LED_GREEN) {
    digitalWrite(GREEN_PIN, LOW);
  } else if (statusLed == LED_YELLOW) {
    digitalWrite(YELLOW_PIN, LOW);
  }

//  interrupts();

  delay(25);
}

void requestHandler() {
  Wire.write(lButtonCounter | (rButtonCounter << 4));
  lButtonCounter = 0;
  rButtonCounter = 0;
}

void receiveHandler(int numBytes) {
  int messageType = Wire.read();
//  Serial.print("Reading message type ");
//  Serial.print(messageType);

  switch(messageType) {
    case L1:
      readString(line1, numBytes - 1);
//      Serial.println(line1);
      break;
    case L2:
      readString(line2, numBytes - 1);
//      Serial.println(line2);
      break;
    case L3:
      readString(line3, numBytes - 1);
//      Serial.println(line3);
      break;
    case L4:
      readString(line4, numBytes - 1);
//      Serial.println(line4);
      break;      
    case FLAGS:
      statusLed = Wire.read();
//      Serial.println();
      break;
  }
}

void readString(char* dest, int len) {
  for (int i = 0; i < len; i++) {
    dest[i] = Wire.read();
  }
}

#include <EEPROM.h>

void setup() {
  Serial.begin(9600);
}

void loop() {
  char conv[4];
  Serial.println("Current configuration:");
  Serial.print("Green LED Pin: ");
  Serial.println(itoa(EEPROM.read(0), conv, 10));
  Serial.print("Yellow LED Pin: ");
  Serial.println(itoa(EEPROM.read(1), conv, 10));  
  Serial.print("Red LED Pin: ");
  Serial.println(itoa(EEPROM.read(2), conv, 10));
  
  Serial.print("Reserve button Pin: ");
  Serial.println(itoa(EEPROM.read(3), conv, 10));
  Serial.print("Cancel button Pin: ");
  Serial.println(itoa(EEPROM.read(4), conv, 10));  
  
  Serial.print("LCD Display Pin 1: ");
  Serial.println(itoa(EEPROM.read(5), conv, 10));    
  Serial.print("LCD Display Pin 2: ");
  Serial.println(itoa(EEPROM.read(6), conv, 10));    
  Serial.print("LCD Display Pin 3: ");
  Serial.println(itoa(EEPROM.read(7), conv, 10));  
  Serial.print("LCD Display Pin 4: ");
  Serial.println(itoa(EEPROM.read(8), conv, 10));    
  Serial.print("LCD Display Pin 5: ");
  Serial.println(itoa(EEPROM.read(9), conv, 10));    
  Serial.print("LCD Display Pin 6: ");
  Serial.println(itoa(EEPROM.read(10), conv, 10));    
  
  Serial.print("I2C Slave Address: ");
  Serial.println(itoa(EEPROM.read(11), conv, 10));
  
  Serial.println();
  Serial.println("Type in numeric values that are a fixed 3-digits wide, IE 003 == 3");
  
  Serial.println("Enter new value for Green LED Pin: ");
  EEPROM.write(0, readByteFromText());
  Serial.println("Enter new value for Yellow LED Pin: ");
  EEPROM.write(1, readByteFromText());
  Serial.println("Enter new value for Red LED Pin: ");
  EEPROM.write(2, readByteFromText());
  
  Serial.println("Enter new value for Reserve button Pin: ");
  EEPROM.write(3, readByteFromText());  
  Serial.println("Enter new value for Cancel button Pin: ");
  EEPROM.write(4, readByteFromText());  

  Serial.println("Enter new value for LCD Display Pin 1: ");
  EEPROM.write(5, readByteFromText());
  Serial.println("Enter new value for LCD Display Pin 2: ");
  EEPROM.write(6, readByteFromText());
  Serial.println("Enter new value for LCD Display Pin 3: ");
  EEPROM.write(7, readByteFromText());
  Serial.println("Enter new value for LCD Display Pin 4: ");
  EEPROM.write(8, readByteFromText());
  Serial.println("Enter new value for LCD Display Pin 5: ");
  EEPROM.write(9, readByteFromText());
  Serial.println("Enter new value for LCD Display Pin 6: ");
  EEPROM.write(10, readByteFromText());
    
  Serial.println("Enter new value for I2C Slave Address: ");
  EEPROM.write(11, readByteFromText());
}

byte readByteFromText() {
  char bytes[4];
  int ptr = 0;
  while (true) {
    if (Serial.available()) {
      char c = Serial.read();
      if (c == '\n') {
        break;
      }
      bytes[ptr++] = c;
      if (ptr == 3) {
        break;
      }
    }
  }
  Serial.print("You entered: ");
  for (int i = 0; i < ptr; i++) {
    Serial.print(bytes[i]);
  }
  Serial.println(); 
  return atoi(bytes);
}

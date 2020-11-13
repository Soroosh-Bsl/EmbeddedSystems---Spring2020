/*
  LiquidCrystal Library - Hello World

 Demonstrates the use a 16x2 LCD display.  The LiquidCrystal
 library works with all LCD displays that are compatible with the
 Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.

 This sketch prints "Hello World!" to the LCD
 and shows the time.

  The circuit:
 * LCD RS pin to digital pin 12
 * LCD Enable pin to digital pin 11
 * LCD D4 pin to digital pin 5
 * LCD D5 pin to digital pin 4
 * LCD D6 pin to digital pin 3
 * LCD D7 pin to digital pin 2
 * LCD R/W pin to ground
 * LCD VSS pin to ground
 * LCD VCC pin to 5V
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)

 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/LiquidCrystal
 */

// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

char freq[4];
char readValue[4];
char stringFreq[6];
int i;
char stringVoltage[5];

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.setCursor(0, 0);
  Serial.begin(9600);
}

void loop() {
  
  if (Serial.available() > 0){
    delay(100);
    i = 0;
    while (i < 4){
   		freq[i++] = Serial.read(); 
    }
    i = 0;
    while (i < 4){
   		readValue[i++] = Serial.read(); 
    }
    if (freq[0] < 10){
    	stringFreq[0] = '0'+freq[0];
    	stringFreq[1] = '.';
      	stringFreq[2] = '0'+freq[1];
      	stringFreq[3] = '0'+freq[2];
      	stringFreq[4] = '0'+freq[3];
      	stringFreq[5] = ' ';
    }
    else{
     	stringFreq[0] = '0'+((int) freq[0]/10);
      	stringFreq[1] = '0'+((int) freq[0]%10);
    	stringFreq[2] = '.';
      	stringFreq[3] = '0'+freq[1];
      	stringFreq[4] = '0'+freq[2];
      	stringFreq[5] = '0'+freq[3];
    }
    stringVoltage[0] = '0'+readValue[0];
    stringVoltage[1] = '.';
    stringVoltage[2] = '0'+readValue[1];
    stringVoltage[3] = '0'+readValue[2];
    stringVoltage[4] = '0'+readValue[3];
    
    lcd.clear();
  	lcd.setCursor(0, 0);
    for (i=0; i < 5; i++)
  		lcd.print(stringVoltage[i]);
    lcd.setCursor(0, 01);
    for (i=0; i < 6; i++)
    	lcd.print(stringFreq[i]);
  }
  //Serial.print(string);
  
}
 
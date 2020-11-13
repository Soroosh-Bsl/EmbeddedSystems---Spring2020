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

int startPin = 10;
int stopPin = 13;
int memoryPin = A0;
int nextPin = A1;
int editPin = A2;
int newPin = A3;
int deletePin = A4;
int doorPin = 6;
int lampPort = 7;
int heaterPort = 8;
int beepPort = 9;

int startVal = 0;
int stopVal = 1;
int memoryVal = A0;
int nextVal = A1;
int editVal = A2;
int newVal = A3;
int deleteVal = A4;
int doorVal = 6;

int light = 0;
int heater = 0;
int beep = 0;

int state = 'idle';
int nextState = 'idle';
int cookingTime = 0;
int beepTime = 0;
int savedTimes[100];
int savedTimeIdx = 0;
int numberOfSavedTimes = 0;


ISR(TIMER1_COMPA_vect){
  if (state=='cooking'){
  	cookingTime -= 1;
  }
  if (state=='beep'){
  	beepTime -= 1;
  }
}


void setup() {
  pinMode(lampPort, OUTPUT);
  pinMode(heaterPort, OUTPUT);
  pinMode(beepPort, OUTPUT);
  
  pinMode(startPin, INPUT);
  pinMode(stopPin, INPUT);
  pinMode(memoryPin, INPUT);
  pinMode(nextPin, INPUT);
  pinMode(editPin, INPUT);
  pinMode(newPin, INPUT);
  pinMode(deletePin, INPUT);
  pinMode(doorPin, INPUT);
  
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("00:00");
  Serial.begin(9600);
}

void loop() {
  startVal = digitalRead(startPin);
  stopVal = digitalRead(stopPin);
  memoryVal = digitalRead(memoryPin);
  nextVal = digitalRead(nextPin);
  editVal = digitalRead(editPin);
  newVal = digitalRead(newPin);
  deleteVal = digitalRead(deletePin);
  doorVal = digitalRead(doorPin);
  Serial.println(cookingTime);
  
  switch(state){
    case 'idle':{
    	cookingTime = 0;
    	lcd.print("00:00");
    	if (startVal==HIGH && doorVal==LOW){
    		cookingTime += 30;
          	activateTimer1();
      		nextState = 'cooking';
    	}
    	if (memoryVal == HIGH){
      		if (numberOfSavedTimes==0){
      			nextState = 'error';
      		}
      		else if (numberOfSavedTimes>0){
        		savedTimeIdx = 0;
        		nextState = 'memory';
      		}
    	}
        break;
    }
    
    case 'cooking':{
      	light = 1;
      	heater = 1;
    	if (cookingTime==0){
          	light=0;
          	heater=0;
      		beep = 1;
      		beepTime = 3;
    		nextState = 'beep';  
    	}
      	if (startVal==HIGH && doorVal==LOW){
    		cookingTime += 30;
      		nextState = 'cooking';
    	}
      	if (doorVal==HIGH || stopVal==HIGH){
          	light = 0;
          	heater = 0;
            stopTimer1();
        	nextState = 'pause';
      	}
      	break;
    }
    
    case 'pause':{
    	 if (startVal==HIGH && doorVal==LOW){
    		activateTimer1();
      		nextState = 'cooking';
    	} 
      	if (stopVal==HIGH){
        	nextState = 'idle';
      	}
      	break;
    }
    
    case 'beep':{  
    	if (beepTime==0 || doorVal==HIGH){
          	stopTimer1();
          	beep = 0;
          	nextState = 'idle';
    	}
      	if (startVal==HIGH && doorVal==LOW){
    		cookingTime += 30;
          	activateTimer1();
          	beep = 0;
      		nextState = 'cooking';
    	}
      	break;
    }
    
    case 'memory':{
      	if (deleteVal==HIGH){
          if (savedTimeIdx < numberOfSavedTimes-1){
           	deleteItem(); 
            nextState = 'memory';
          }
          
          else if (savedTimeIdx >= numberOfSavedTimes-1 && numberOfSavedTimes>1){
           	deleteItem();
            savedTimeIdx = numberOfSavedTimes-1;
            nextState = 'memory';
          }
          else if (savedTimeIdx >= numberOfSavedTimes-1 && numberOfSavedTimes<=1){
           	deleteItem(); 
            nextState = 'error';
          }
      	}
      	if (memoryVal==HIGH){
        	nextState = 'idle';
      	}
      	if (newVal==HIGH){
        	numberOfSavedTimes += 1;
          	savedTimeIdx = numberOfSavedTimes-1;
          	nextState = 'edit_min';
      	}
      	if (editVal==HIGH){
          	nextState = 'edit_min';
      	}
      	if (nextVal==HIGH){
          	savedTimeIdx = (savedTimeIdx+1)%numberOfSavedTimes;
          	nextState = 'memory';
      	}
      	if (startVal==HIGH && doorVal==LOW){
        	cookingTime = savedTimes[savedTimeIdx];
          	activateTimer1();
      		nextState = 'cooking';
      	}
      	break;
    }
    
    case 'edit_min':{
      	if (nextVal==HIGH){
        	savedTimes[savedTimeIdx] += 60;
          	nextState = 'edit_min';
      	}
      	if (editVal==HIGH){
        	nextState = 'edit_sec';
      	}
      	break;
    }
    
    case 'edit_sec':{
      	if (nextVal==HIGH){
        	savedTimes[savedTimeIdx] += 1;
          	nextState = 'edit_sec';
      	}
      	if (editVal==HIGH){
        	nextState = 'memory';
      	}
      	break;
    }
    
    case 'error':{
     	if (newVal==HIGH){
        	numberOfSavedTimes += 1;
          	savedTimeIdx = numberOfSavedTimes-1;
          	nextState = 'edit_min';
      	}
      
      	if (memoryVal==HIGH){
        	nextState = 'idle';
      	}
      	break;
    }
  }
  
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  lcd.setCursor(0, 0);
  state = nextState;
  display();
  buzz();
  lightning();
  heat();
  delay(400);
}
 
void activateTimer1(){
   //set timer1 interrupt at 1Hz
  TCCR1A = 0;// set entire TCCR1A register to 0
  TCCR1B = 0;// same for TCCR1B
  TCNT1  = 0;//initialize counter value to 0
  // set compare match register for 1hz increments
  OCR1A = 15624;// = (16*10^6) / (1*1024) - 1 (must be <65536)
  // turn on CTC mode
  TCCR1B |= (1 << WGM12);
  // Set CS12 and CS10 bits for 1024 prescaler
  TCCR1B |= (1 << CS12) | (1 << CS10);  
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE1A); 
}


void stopTimer1(){
   
  // enable timer compare interrupt
  TIMSK1 |= (0 << OCIE1A); 
}

void deleteItem(){
	int i = 0;
  	for (i=savedTimeIdx; i<numberOfSavedTimes-1; i--){
    	savedTimes[i] = savedTimes[i+1];
  	}
  	savedTimes[numberOfSavedTimes-1] = 0;
  	numberOfSavedTimes -= 1;
}

void display(){
  lcd.clear();
  char string[5];
  int mins;
  int seconds;
  if (state == 'idle'){
   	lcd.print("00:00"); 
  }
  else if (state == 'memory' || state == 'edit_min' || state == 'edit_sec'){
    mins = (savedTimes[savedTimeIdx]/60);
    seconds = (savedTimes[savedTimeIdx]%60);
    string[0] = '0'+((char) mins/10);
    string[1] = '0'+((char) mins%10);
    string[2] = ':';
    string[3] = '0'+((char) seconds/10);
    string[4] = '0'+((char) seconds%10);
   	for (int i=0; i<5; i++)
    	lcd.print(string[i]); 
  }
  else if (state == 'error'){
   	lcd.print("No Saved Time!"); 
  }
  else if (state == 'cooking' || state == 'pause'){
    mins = (cookingTime/60);
    seconds = (cookingTime%60);
    string[0] = '0'+((char) mins/10);
    string[1] = '0'+((char) mins%10);
    string[2] = ':';
    string[3] = '0'+((char) seconds/10);
    string[4] = '0'+((char) seconds%10);
    for (int i=0; i<5; i++)
    	lcd.print(string[i]); 
  }
  lcd.setCursor(0, 1);
  lcd.print(state);
}

void buzz(){
  if (beep==1){
   	digitalWrite(beepPort, HIGH); 
  }
  else{
   	digitalWrite(beepPort, LOW); 
  }
}

void lightning(){
  if (light==1 || doorVal==HIGH){
   	digitalWrite(lampPort, HIGH); 
  }
  else{
   	digitalWrite(lampPort, LOW); 
  }
}

void heat(){
  if (heater==1){
   	digitalWrite(heaterPort, HIGH); 
  }
  else{
   	digitalWrite(heaterPort, LOW); 
  }
}
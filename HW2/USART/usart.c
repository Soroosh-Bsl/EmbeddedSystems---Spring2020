/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/6/2020
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>
#include <io.h>

#define lcd_ddr DDRB
#define lcd_port PORTB
#define lcd_control_ddr DDRA
#define lcd_control_port PORTA
#define RS 6
#define RW 1
#define EN 7
#define KEYPAD_DDR DDRC
#define KEYPAD_PORT PORTC
#define KEYPAD_PIN PINC

// Declare your global variables here
unsigned char received_string[40];
unsigned char sending_string[40];
unsigned char message_string[17];
unsigned char i = 0;
unsigned char j = 0;
unsigned char sending = 0;
unsigned char sender_set = 0;
unsigned char MY_ID;

#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)

// USART Receiver buffer
#define RX_BUFFER_SIZE 16
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index=0,rx_rd_index=0;
#else
unsigned int rx_wr_index=0,rx_rd_index=0;
#endif

#if RX_BUFFER_SIZE < 256
unsigned char rx_counter=0;
#else
unsigned int rx_counter=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0) rx_buffer_overflow=1;
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{                                                   
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 16
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index=0,tx_rd_index=0;
#else
unsigned int tx_wr_index=0,tx_rd_index=0;
#endif

#if TX_BUFFER_SIZE < 256
unsigned char tx_counter=0;
#else
unsigned int tx_counter=0;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

void lcd_send_cmd(unsigned char cmd);          
void lcd_send_char(unsigned char sentCharacter);
void lcd_clear();             
void lcd_send_string(char sentString[]);

void lcd_init(){
    lcd_ddr = 0xff;
    lcd_control_ddr |= (1<<RS) | (1<<RW) | (1<<EN);
	lcd_send_cmd(0x0E);
	lcd_send_cmd(0x38);
	lcd_clear();
	delay_ms(50);
	lcd_clear();
}

void lcd_send_cmd(unsigned char cmd){
	lcd_port = cmd;
	lcd_control_port &= ~(1<<RS);
	lcd_control_port &= ~(1<<RW);
	lcd_control_port |=  (1<<EN);
	delay_us(700);
	lcd_control_port &= ~(1<<EN);
}

void lcd_send_char(unsigned char sentCharacter){
	lcd_port = sentCharacter;
	lcd_control_port |=  (1<<RS);
	lcd_control_port &= ~(1<<RW);
	lcd_control_port |=  (1<<EN);
	delay_us(700);
	lcd_control_port &= ~(1<<EN);
}

void lcd_send_string(char sentString[]){
	unsigned char  i = 0;
	while (sentString[i]!='\0')
	{
		lcd_send_char(sentString[i]);
		i++;
	}
}

void lcd_clear(){
	lcd_send_cmd(0x01);
}

void lcd_go_to_xy(unsigned char x,unsigned char y){
	if(x == 0){
		lcd_send_cmd(0x80+y);
	}
    else if (x == 1){
		lcd_send_cmd(0xC0+y);
	}
}

void show_message(unsigned char* string){
    lcd_clear();
    message_string[0] = 'S';
    message_string[1] = 'n';
    message_string[2] = 'd';
    message_string[3] = 'r';
    message_string[4] = ':';
    message_string[5] = '\0'; 
    lcd_send_string(message_string);
    lcd_send_char(string[0]);
    message_string[0] = ' ';
    message_string[1] = ' ';
    message_string[2] = '\0';        
    lcd_send_string(message_string);
    message_string[0] = 'R';
    message_string[1] = 'c';
    message_string[2] = 'v';
    message_string[3] = 'r';
    message_string[4] = ':';
    message_string[5] = '\0';       
    lcd_send_string(message_string);
    lcd_send_char(string[1]);
    lcd_go_to_xy(1, 0);             
    lcd_send_char('M');             
    lcd_send_char('=');
    lcd_send_string(string+2);
}

void show_sending(){
    unsigned char string[17];
    lcd_clear();
    string[0] = 'S';         
    string[1] = 'e';
    string[2] = 'n';
    string[3] = 'd';
    string[4] = 'i';
    string[5] = 'n';
    string[6] = 'g';
    string[7] = ' ';
    string[8] = 'M';
    string[9] = 'e';
    string[10] = 's';
    string[11] = 's';
    string[12] = 'a';
    string[13] = 'g';
    string[14] = 'e';
    string[15] = '!';
    string[16] = '\0';
    lcd_go_to_xy(0, 0);
    lcd_send_string(string);
    delay_ms(100);
    lcd_clear();
}

void send(unsigned char* string){
    unsigned char k=0; 
    while (string[k] != '#'){
        putchar(string[k]);
        k += 1;
    }   
    putchar(string[k]);
    //putchar('\0');        
}

void process(unsigned char* string){
    if (string[1] == ('0' + MY_ID)){
        show_message(string);
    }
    else{
        show_sending();
        send(string);
    }
}

void receive(){
    unsigned char d;
    if (rx_counter == 0){
        return;
    }
    d = getchar();        
    if (d == '#'){
        received_string[i] = d;
        i += 1;
        received_string[i] = '\0';
        i = 0;
        process(received_string);
        
    }
    else{
        received_string[i] = d;
        i += 1;
    }      
}

unsigned char GetKeyPressed(){
    unsigned char r,c;
    KEYPAD_PORT |= 0X0F;
    for(c=0;c<3;c++){
        KEYPAD_DDR &= ~(0X7F);
        KEYPAD_DDR |= (0X40>>c);
        for(r=0;r<4;r++){
            if(!(KEYPAD_PIN & (0X08>>r))){
                return (r*3+c);
            }
        }
    }
    return 0XFF;//Indicate No key pressed
}

void receive_command(){
  unsigned char keypressed = GetKeyPressed();
  delay_ms(30);
  if (keypressed==0){
    if (sending == 2){
    sending_string[j] = '1';
    j++;
    lcd_send_char('1');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '1';
            j++;       
            lcd_send_char('1');
            sender_set = 1;
        }
    }
  }
  if (keypressed==3){    
    if (sending == 2){
        sending_string[j] = '4';
        j++;
        lcd_send_char('4');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '4';
            j++;
            lcd_send_char('4');
            sender_set = 1;
        }
    }
  }
  if (keypressed==6){
    if (sending == 2){
        sending_string[j] = '7';
        j++;
        lcd_send_char('7');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '7';
            j++;
            lcd_send_char('7');
            sender_set = 1;
        }
    }
  }
  if (keypressed==9){ 
    if (sending == 2){
        sending_string[j] = '*';
        j++;
        lcd_send_char('*');
    }
    else if (sending == 0){
        sending = 1;
        sending_string[0] = '0' + MY_ID;
        j = 1;         
        lcd_clear();
        lcd_send_char('=');
    }
    else{
        if (sender_set == 1){
            sending = 2;
            lcd_send_char('*');
        }
    }
  }    
  if (keypressed==1){
    if (sending == 2){
        sending_string[j] = '2';
        j++;
        lcd_send_char('2');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '2';
            j++;
            lcd_send_char('2');
            sender_set = 1;
        }
    }
  }
  if (keypressed==4){
    if (sending == 2){
        sending_string[j] = '5';
        j++;
        lcd_send_char('5');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '5';
            j++;
            lcd_send_char('5');
            sender_set = 1;
        }
    }
  }
  if (keypressed==7){
    if (sending == 2){
        sending_string[j] = '8';
        j++;                   
        lcd_send_char('8');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '8';
            j++;
            lcd_send_char('8');
            sender_set = 1;
        }
    }
  }
  if (keypressed==10){
    if (sending == 2){
        sending_string[j] = '0';
        j++;                   
        lcd_send_char('0');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '0';
            j++;
            lcd_send_char('0');
            sender_set = 1;
        }
    }
  }
  if (keypressed==2){
    if (sending == 2){
        sending_string[j] = '3';
        j++;                   
        lcd_send_char('3');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '3';
            j++;
            lcd_send_char('3');
            sender_set = 1;
        }
    }
  }
  if (keypressed==5){ 
    if (sending == 2){
        sending_string[j] = '6';
        j++;                   
        lcd_send_char('6');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '6';
            j++;
            lcd_send_char('6');
            sender_set = 1;
        }
    }
  }
  if (keypressed==8){
    if (sending == 2){
        sending_string[j] = '9';
        j++;                   
        lcd_send_char('9');
    }
    if (sending == 1){
        if (sender_set == 0){
            sending_string[j] = '9';
            j++;
            lcd_send_char('9');
            sender_set = 1;
        }
    }
  }
  if (keypressed==11){
    if (sending == 2){
        sending_string[j] = '#';
        j++;
        sending_string[j] == '\0';
        j++;
        sending = 0;
        sender_set = 0;
        process(sending_string);
    }          
  }        
}

void set_my_id(){
    unsigned char keypressed;
    lcd_clear();   
    message_string[0] = 'E';
    message_string[1] = 'n';
    message_string[2] = 't';
    message_string[3] = 'e';
    message_string[4] = 'r';
    message_string[5] = ' ';
    message_string[6] = 'M';
    message_string[7] = 'Y';
    message_string[8] = ' ';
    message_string[9] = 'I';
    message_string[10] = 'D';
    message_string[11] = ':';
    message_string[12] = '\0';
    lcd_go_to_xy(0, 2); 
    lcd_send_string(message_string);
    do  {
        keypressed = GetKeyPressed();
    }
    while (keypressed==0xFF || keypressed==9 || keypressed==11);
    switch (keypressed) {
    case 0:{
        keypressed=1;
        break;
    }
    case 1:{
        keypressed=2;
        break;
    }case 2:{
        keypressed=3;
        break;
    }case 3:{
        keypressed=4;
        break;
    }case 4:{
        keypressed=5;
        break;
    }case 5:{
        keypressed=6;
        break;
    }case 6:{
        keypressed=7;
        break;
    }case 7:{
        keypressed=8;
        break;
    }case 8:{
        keypressed=9;
        break;
    }case 10:{
        keypressed=0;
        break;
    }
    };
    MY_ID = keypressed; 
    message_string[0] = 'I';
    message_string[1] = 'D';
    message_string[2] = ' ';
    message_string[3] = 's';
    message_string[4] = 'e';
    message_string[5] = 't';
    message_string[6] = ' ';
    message_string[7] = 't';
    message_string[8] = 'o';
    message_string[9] = ':';
    message_string[10] = ' ';
    message_string[11] = '\0';
    lcd_go_to_xy(1, 0);
    lcd_send_string(message_string);
    lcd_send_char('0'+keypressed);
    delay_ms(100);
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")
lcd_init();
set_my_id();
while (1)
      {      
        //lcd_send_char('A');
      // Place your code here
        receive();
        receive_command();
      }
}

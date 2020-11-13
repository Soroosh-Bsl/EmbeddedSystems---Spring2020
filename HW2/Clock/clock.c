/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Clock -Embedded Course
Version : 
Date    : 3/28/2020
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


// Declare your global variables here
unsigned char counter = 0;
unsigned char seconds = 0;
unsigned char minutes = 0;
unsigned char hours = 0;

unsigned char stop_watch_counter = 0;
unsigned char stop_watch_seconds = 0;
unsigned char stop_watch_minutes = 0;
unsigned char stop_watch_hours = 0;

unsigned char alarm_minutes = 0;
unsigned char alarm_hours = 0;

unsigned char time_string[17];
unsigned char state = 0;

unsigned char ALARM = 0;
unsigned char string[17];
void lcd_go_to_xy(unsigned char x,unsigned char y);
void lcd_send_char(unsigned char sentCharacter);

#define lcd_ddr DDRA
#define lcd_port PORTA
#define lcd_control_ddr DDRD
#define lcd_control_port PORTD
#define RS 6
#define RW 1
#define EN 7
#define clocks_per_a_sec 30
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x83;
// Place your code here
    counter += 1;
    if (counter == clocks_per_a_sec){
        counter = 0;
        seconds += 1;
        if (seconds == 60){
            minutes += 1;
            seconds = 0;
            if (minutes == 60){
                hours += 1;
                minutes = 0;
                if (hours == 24){
                    hours = 0;
                }
            }
        }                
        
        if ((alarm_hours == hours) && (alarm_minutes == minutes) && (ALARM == 1) & (seconds < 10)){
            //PORTD = PORTD | (1<<4) ;
            lcd_go_to_xy(0, 15);
            lcd_send_char('*');    
        }
        else{
            //PORTD = PORTD & ~(1<<4);
            lcd_go_to_xy(0, 15);
            lcd_send_char('\0');
        }
    }
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer 2 value
TCNT2=0x83;
// Place your code here
    stop_watch_counter += 1;
    if (stop_watch_counter == clocks_per_a_sec){
        stop_watch_counter = 0;
        stop_watch_seconds += 1;
        if (stop_watch_seconds == 60){
            stop_watch_minutes += 1;
            stop_watch_seconds = 0;
            if (stop_watch_minutes == 60){
                stop_watch_hours += 1;
                stop_watch_minutes = 0;
                if (stop_watch_hours == 24){
                    stop_watch_hours = 0;
                }
            }
        }
    }
}

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
    lcd_send_string(time_string);
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

void updateTimeString(unsigned char hour,unsigned char minute,unsigned char second,char timeString[17]){
    timeString[0] = '0' + hour/10;
    timeString[1] = '0' + hour%10;
    timeString[2] = ':';
    timeString[3] = '0' + minute/10;
    timeString[4] = '0' + minute%10;
    timeString[5] = ':';
    timeString[6] = '0' + second/10;
    timeString[7] = '0' + second%10;
    timeString[8] = ' '; 
    timeString[9] = ' ';            
    timeString[10] = ' '; 
    timeString[11] = ' ';
    if (ALARM == 1){
        timeString[12] = 'A';
    }                      
    else{
        timeString[12] = ' ';
    }                 
    
    timeString[13] = ' ';
    timeString[14] = ' ';
    timeString[15] = ' ';
    timeString[16] = '\0';
}

void check_push_buttons(){
    switch (state) {
        case 0:{
            if (PINC & (1<<5))
                state = 1; // setting new time (seconds)
            else if (PIND & (1<<5))
                state = 2; // alarm and stop watch (stop watch)
            //delay_ms(500);
            break;
        }
        case 1:{
            if (PIND & (1<<5)){
                seconds = (seconds + 1) % 60;
                state = 1;    
            }
            if (PINC & (1<<5)){
                state = 3; // setting minutes
            }
            //delay_ms(300);
            break;
        }
        case 2:{
            if (PIND & (1<<5)){
                // start stop watch 
                stop_watch_counter = 0;
                stop_watch_seconds = 0;
                stop_watch_minutes = 0;
                stop_watch_hours = 0; 
                      
                TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
                TCNT2=0x83;
                
                state = 4; //stop watch running    
            }
            if (PINC & (1<<5)){
                state = 5; // alarm setting
            }                             
            //delay_ms(300);
            break;
        }
        case 3:{
            if (PIND & (1<<5)){
                minutes = (minutes + 1) % 60;
                state = 3;    
            }
            if (PINC & (1<<5)){
                state = 7; // setting hours
            }
            //delay_ms(300);
            break;
        }                                      
        case 4:{
            if (PIND & (1<<5)){ 
                if (TCNT2 == 0x00){
                    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
                    TCNT2=0x83;
                }       
                else{
                    TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
                    TCNT2=0x00;
                }
                state = 4;
            }              
            if (PINC & (1<<5)){  
                TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
                TCNT2=0x00;
                state = 5; // alarm setting
            }              
            //delay_ms(300);
            break;
        }                  
        case 5:{
            if (PIND & (1<<5)){
                state = 6; // setting alarm's minutes   
            }
            if (PINC & (1<<5)){
                state = 0; 
            }
            //delay_ms(300);
            break;
        }                  
        case 6:{
            if (PIND & (1<<5)){
                alarm_minutes = (alarm_minutes + 1) % 60;
                state = 6;    
            }
            if (PINC & (1<<5)){
                state = 8; // setting alarm's hour
            }
            //delay_ms(300);
            break;
        }                                  
        case 7:{
            if (PIND & (1<<5)){
                hours = (hours + 1) % 24;
                state = 7;    
            }
            if (PINC & (1<<5)){
                state = 0;
            }
            //delay_ms(300);
            break;
        }                                     
        case 8:{
            if (PIND & (1<<5)){
                alarm_hours = (alarm_hours + 1) % 24;
                state = 8;    
            }
            if (PINC & (1<<5)){
                state = 9;
            }
            //delay_ms(300);
            break;
        }                     
        case 9:{
            if (PIND & (1<<5)){
                //lcd_send_string("Alarm Set");
                ALARM = 1;
                state = 0;    
            }
            if (PINC & (1<<5)){
                ALARM = 0;
                state = 0;
            }
            //delay_ms(300);
            break;
        }                                                  
    };

}

void update_lcd(){ 
    lcd_go_to_xy(0, 0);  
    switch (state) {
    case 0:{  
        updateTimeString(hours, minutes, seconds, time_string);
        lcd_send_string(time_string);
        string[0] = 'C';
        string[1] = ':';
        string[2] = 'T';
        string[3] = 'i';
        string[4] = 'm';
        string[5] = 'e';
        string[6] = 'S';
        string[7] = 'e';
        string[8] = 't';
        string[9] = '-';
        string[10] = 'D';
        string[11] = ':';
        string[12] = 'A';
        string[13] = '/';
        string[14] = 'S';
        string[15] = 'W';
        string[16] = '\0';      
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    case 1:{  
        updateTimeString(hours, minutes, seconds, time_string); 
        lcd_send_string(time_string);  
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'C';
        string[3] = 'h';
        string[4] = 'g';
        string[5] = 'S';
        string[6] = 'e';
        string[7] = 'c';
        string[8] = '-';
        string[9] = 'C';
        string[10] = ':';
        string[11] = 'G';
        string[12] = 'o';
        string[13] = 'M';
        string[14] = 'i';
        string[15] = 'n';
        string[16] = '\0';      
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    case 2:{  
        updateTimeString(stop_watch_hours, stop_watch_minutes, stop_watch_seconds, time_string);
        lcd_send_string(time_string);
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'S';
        string[3] = 't';
        string[4] = 'a';
        string[5] = 'r';
        string[6] = 't';
        string[7] = '-';
        string[8] = 'C';
        string[9] = ':';
        string[10] = 'A';
        string[11] = 'l';
        string[12] = 'a';
        string[13] = 'r';
        string[14] = 'm';
        string[15] = ' ';
        string[16] = '\0';      
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    case 3:{  
        updateTimeString(hours, minutes, seconds, time_string);
        lcd_send_string(time_string);
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'C';
        string[3] = 'h';
        string[4] = 'g';
        string[5] = 'M';
        string[6] = 'i';
        string[7] = 'n';
        string[8] = '-';
        string[9] = 'C';
        string[10] = ':';
        string[11] = 'G';
        string[12] = 'o';
        string[13] = 'H';
        string[14] = 'r';
        string[15] = ' ';
        string[16] = '\0';      
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    case 4:{  
        updateTimeString(stop_watch_hours, stop_watch_minutes, stop_watch_seconds, time_string);
        lcd_send_string(time_string);
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'S';
        string[3] = 't';
        string[4] = 'p';
        string[5] = '/';
        string[6] = 'R';
        string[7] = 'e';
        string[8] = 's';
        string[9] = '-';
        string[10] = 'C';
        string[11] = ':';
        string[12] = 'A';
        string[13] = 'l';
        string[14] = 'r';
        string[15] = 'm';
        string[16] = '\0';    
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    case 5:{  
        time_string[0] = 'C';
        time_string[1] = ':';
        time_string[2] = 'T';
        time_string[3] = 'o';
        time_string[4] = ' ';
        time_string[5] = 'M';
        time_string[6] = 'a';
        time_string[7] = 'i';
        time_string[8] = 'n';
        time_string[9] = ' ';
        time_string[10] = ' ';
        time_string[11] = ' ';
        time_string[12] = ' '; 
        time_string[13] = ' ';
        time_string[14] = ' ';
        time_string[15] = ' ';
        time_string[16] = '\0';
        lcd_send_string(time_string);
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'A';
        string[3] = 'l';
        string[4] = 'a';
        string[5] = 'r';
        string[6] = 'm';
        string[7] = ' ';
        string[8] = ' ';
        string[9] = ' ';
        string[10] = ' ';
        string[11] = ' ';
        string[12] = ' ';
        string[13] = ' ';
        string[14] = ' ';
        string[15] = ' ';
        string[16] = '\0'; 
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    case 6:{  
        updateTimeString(alarm_hours, alarm_minutes, 0, time_string);
        lcd_send_string(time_string);           
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'S';
        string[3] = 'e';
        string[4] = 't';
        string[5] = 'M';
        string[6] = 'i';
        string[7] = 'n';
        string[8] = '-';
        string[9] = 'C';
        string[10] = ':';
        string[11] = 'G';
        string[12] = 'o';
        string[13] = 'H';
        string[14] = 'r';
        string[15] = ' ';
        string[16] = '\0';    
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }               
    case 7:{  
        updateTimeString(hours, minutes, seconds, time_string);
        lcd_send_string(time_string);
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'C';
        string[3] = 'h';
        string[4] = 'g';
        string[5] = 'H';
        string[6] = 'r';
        string[7] = '-';
        string[8] = 'C';
        string[9] = ':';
        string[10] = 'F';
        string[11] = 'i';
        string[12] = 'n';
        string[13] = 'i';
        string[14] = 's';
        string[15] = 'h';
        string[16] = '\0';      
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }  
    case 8:{  
        updateTimeString(alarm_hours, alarm_minutes, 0, time_string);
        lcd_send_string(time_string);           
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'S';
        string[3] = 'e';
        string[4] = 't';
        string[5] = 'H';
        string[6] = 'r';
        string[7] = '-';
        string[8] = 'C';
        string[9] = ':';
        string[10] = 'F';
        string[11] = 'i';
        string[12] = 'n';
        string[13] = 'i';
        string[14] = 's';
        string[15] = 'h';
        string[16] = '\0';    
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }  
    case 9:{  
        time_string[0] = 'C';
        time_string[1] = ':';
        time_string[2] = 'C';
        time_string[3] = 'a';
        time_string[4] = 'n';
        time_string[5] = 'c';
        time_string[6] = 'e';
        time_string[7] = 'l';
        time_string[8] = ' ';
        time_string[9] = ' ';
        time_string[10] = ' ';
        time_string[11] = ' ';
        time_string[12] = ' ';
        time_string[13] = ' ';
        time_string[14] = ' ';
        time_string[15] = ' ';
        time_string[16] = '\0';
        
        lcd_send_string(time_string);           
        string[0] = 'D';
        string[1] = ':';
        string[2] = 'C';
        string[3] = 'o';
        string[4] = 'n';
        string[5] = 'f';
        string[6] = 'i';
        string[7] = 'r';
        string[8] = 'm';
        string[9] = ' ';
        string[10] = 'A';
        string[11] = 'l';
        string[12] = 'a';
        string[13] = 'r';
        string[14] = 'm';
        string[15] = ' ';
        string[16] = '\0';    
        lcd_go_to_xy(1, 0);
        lcd_send_string(string);
        lcd_go_to_xy(0, 0);
        break;
    }
    };

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
// Clock value: 31.250 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 4 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x83;
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
TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

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

DDRC = DDRC & ~(1<<5);
DDRD = DDRD & ~(1<<5);
//DDRD = DDRD | ( 1<<4);
lcd_init();
while (1)
      {
      // Place your code here
        check_push_buttons(); 
                             
        update_lcd();
        lcd_send_cmd(0x0c);
        delay_us(500);
      }
}

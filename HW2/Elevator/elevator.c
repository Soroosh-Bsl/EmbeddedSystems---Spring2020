/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Elevator -Embedded Course
Version : 
Date    : 3/29/2020
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
#include <io.h>>
// Declare your global variables here
#define LCD_Dir  DDRA            /* Define LCD data port direction */
#define LCD_Port PORTA            /* Define LCD data port */
#define RS PORTA2                /* Define Register Select pin */
#define EN PORTA3                 /* Define Enable signal pin */

unsigned char cabins_states[2];

void LCD_Char( unsigned char data );             
void LCD_String_xy (char row, char pos, char *str);
void off_LED(char floor, char dir);
unsigned char cabins_floors[2];
unsigned char cabins_up_stops[2][5];
unsigned char cabins_down_stops[2][5];
unsigned char counter0 = 0;
unsigned char counter1 = 0;
unsigned char seconds0 = 0; 
unsigned char seconds1 = 0;
unsigned char threshold[2];
unsigned char flag[2];

#define clocks_per_a_sec 30

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    unsigned char i = 0;
    // Reinitialize Timer 0 value
    TCNT0=0x83;
    // Place your code here  
    counter0 += 1;
    if (counter0 == clocks_per_a_sec){
        counter0 = 0;
        seconds0 += 1;       
        if (seconds0 == threshold[0]){
            seconds0 = 0;
            flag[0] = 0;
            if (threshold[0] == 3 || threshold[0] == 0){
                if (cabins_states[0] == 'u'){
                    cabins_up_stops[0][cabins_floors[0]] = 0;
                    off_LED(cabins_floors[0], 'u');
                    for (i = cabins_floors[0]; i < 5; i++){
                        if (cabins_up_stops[0][i] == 1){
                            flag[0] = 1;
                            cabins_floors[0] += 1;
                            if (cabins_floors[0] == i){
                                off_LED(i, 'u');
                                cabins_up_stops[0][i] = 0;
                                threshold[0] = 10;
                            }
                            else
                                threshold[0] = 3;
                            break;                      
                        }
                    }
                    if (flag[0] == 0){
                        for (i = 5; i >= cabins_floors[0] && i < 255; i--){
                            if (cabins_down_stops[0][i] == 1){
                                flag[0] = 1;
                                cabins_floors[0] += 1;
                                if (cabins_floors[0] == i){     
                                    off_LED(i, 'd');
                                    cabins_down_stops[0][i] = 0;
                                    threshold[0] = 10;
                                }
                                else
                                    threshold[0] = 3;
                                break;
                            }                      
                        }    
                    }
                    if (flag[0] == 0){
                        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
                        TCNT0=0x00;
                        cabins_states[0] = 's';
                    }
                }
                else if (cabins_states[0] == 'd'){
                    cabins_down_stops[0][cabins_floors[0]] = 0;
                    off_LED(cabins_floors[0], 'd');
                    for (i = cabins_floors[0]; i < 255; i--)
                        if (cabins_down_stops[0][i] == 1){
                            flag[0] = 1;
                            cabins_floors[0] -= 1;
                            if (cabins_floors[0] == i){     
                                off_LED(i, 'd');
                                cabins_down_stops[0][i] = 0;
                                threshold[0] = 10;
                            }
                            else
                                threshold[0] = 3;
                            break;                      
                        }
                    if (flag[0] == 0){
                        for (i = 0; i <= cabins_floors[0]; i++){
                            if (cabins_up_stops[0][i] == 1){
                                flag[0] = 1;
                                cabins_floors[0] -= 1;
                                if (cabins_floors[0] == i){
                                    off_LED(i, 'u');
                                    cabins_up_stops[0][i] = 0;
                                    threshold[0] = 10;
                                }
                                else
                                    threshold[0] = 3;
                                break;
                            }                      
                        }    
                    }
                    if (flag[0] == 0){
                        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
                        TCNT0=0x00;
                        cabins_states[0] = 's';
                    }
                }
            }
            else{ 
                if (cabins_states[0] == 'u'){
                    for (i = cabins_floors[0]; i < 5; i++){
                        if (cabins_up_stops[0][i] == 1){
                            threshold[0] = 3;
                            flag[0] = 1;
                            break;                      
                        }                                    
                    }
                    if (flag[0] == 0){
                        for (i = cabins_floors[0]; i < 255; i--){
                            if (cabins_down_stops[0][i] == 1){
                                cabins_states[0] = 'd';
                                threshold[0] = 3;
                                flag[0] = 1;           
                                break;                        
                            }
                        }
                    }
                    if (flag[0] == 0){
                        //stop timer         
                        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
                        TCNT0=0x00;
                        cabins_states[0] = 's';
                    }    
                } 
                else if (cabins_states[0] == 'd'){        
                    for (i = cabins_floors[0]; i < 255; i--)
                        if (cabins_down_stops[0][i] == 1){
                            threshold[0] = 3;
                            flag[0] = 1;
                            break;                      
                        }
                    if (flag[0] == 0){
                        for (i = cabins_floors[0]; i < 5 ; i++)
                            if (cabins_up_stops[0][i] == 1){
                                cabins_states[0] = 'u';
                                threshold[0] = 3;
                                flag[0] = 1;           
                                break;                        
                            }
                    }
                    if (flag[0] == 0){
                        //stop timer
                        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
                        TCNT0=0x00;
                        cabins_states[0] = 's';
                    }    
                }
            }
        }       
    }
}

interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
    unsigned char i = 0;
    // Reinitialize Timer 2 value
    TCNT2=0x83;
    // Place your code here  
    counter1 += 1;
    if (counter1 == clocks_per_a_sec){
        counter1 = 0;
        seconds1 += 1;  
        if (seconds1 == threshold[1]){
            seconds1 = 0;
            flag[1] = 0;
            if (threshold[1] == 3 || threshold[1] == 0){
                if (cabins_states[1] == 'u'){
                    cabins_up_stops[1][cabins_floors[1]] = 0;
                    off_LED(cabins_floors[1], 'u');
                    for (i = cabins_floors[1]; i < 5; i++){
                        if (cabins_up_stops[1][i] == 1){   
                            flag[1] = 1;
                            cabins_floors[1] += 1;
                            if (cabins_floors[1] == i){
                                off_LED(i, 'u');
                                cabins_up_stops[1][i] = 0;
                                threshold[1] = 10;
                            }
                            else
                                threshold[1] = 3;
                            break;                      
                        }                    
                    }
                    if (flag[1] == 0){   
                        for (i = 5; i >= cabins_floors[1] && i < 255; i--){
                            if (cabins_down_stops[1][i] == 1){
                                flag[1] = 1;
                                cabins_floors[1] += 1;
                                if (cabins_floors[1] == i){
                                    off_LED(i, 'd');
                                    cabins_down_stops[1][i] = 0;
                                    threshold[1] = 10;
                                }
                                else
                                    threshold[1] = 3;
                                break;
                            }                      
                        }    
                    }
                    if (flag[1] == 0){
                        //stop timer 
                        TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
                        TCNT2=0x00;
                        cabins_states[1] = 's';
                    }
                }
                else if (cabins_states[1] == 'd'){           
                    cabins_down_stops[1][cabins_floors[1]] = 0;
                    off_LED(cabins_floors[1], 'd');
                    for (i = cabins_floors[1]; i < 255; i--){
                        if (cabins_down_stops[1][i] == 1){
                            cabins_floors[1] -= 1;
                            if (cabins_floors[1] == i){
                                cabins_down_stops[1][i] = 0;
                                off_LED(i, 'd');
                                threshold[1] = 10;
                            }
                            else
                                threshold[1] = 3;
                            break;                      
                        }
                    }
                    if (flag[1] == 0){
                        for (i = 0; i <= cabins_floors[1]; i++){
                            if (cabins_up_stops[1][i] == 1){
                                flag[1] = 1;
                                cabins_floors[1] -= 1;
                                if (cabins_floors[1] == i){
                                    cabins_up_stops[1][i] = 0;
                                    off_LED(i, 'u');
                                    threshold[1] = 10;
                                }
                                else
                                    threshold[1] = 3;
                                break;
                            }                      
                        }    
                    }
                    if (flag[1] == 0){
                        //stop timer 
                        TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
                        TCNT2=0x00;
                        cabins_states[1] = 's';
                    }
                }
            }
            else{ 
                if (cabins_states[1] == 'u'){
                    for (i = cabins_floors[1]; i < 5; i++){
                        if (cabins_up_stops[1][i] == 1){
                            threshold[1] = 3;
                            flag[1] = 1;
                            break;                      
                        }                                    
                    }
                    if (flag[1] == 0){
                        for (i = cabins_floors[1]; i < 255; i--){
                            if (cabins_down_stops[1][i] == 1){
                                cabins_states[1] = 'd';
                                threshold[1] = 3;
                                flag[1] = 1;           
                                break;                        
                            }
                        }
                    }
                    if (flag[1] == 0){
                        //stop timer 
                        TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
                        TCNT2=0x00;
                        cabins_states[1] = 's';
                    }    
                } 
                else if (cabins_states[1] == 'd'){
                    for (i = cabins_floors[1]; i < 255; i--)
                        if (cabins_down_stops[1][i] == 1){
                            threshold[1] = 3;
                            flag[1] = 1;
                            break;                      
                        }
                    if (flag[1] == 0){
                        for (i = cabins_floors[1]; i < 5 ; i++)
                            if (cabins_up_stops[1][i] == 1){
                                cabins_states[1] = 'u';
                                threshold[1] = 3;
                                flag[1] = 1;           
                                break;                        
                            }
                    }
                    if (flag[0] == 0){
                        //stop timer
                            TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
                            TCNT2=0x00;                  
                            cabins_states[1] = 's';
                    }    
                }
            }
        }       
    }
}

void LCD_Command( unsigned char cmnd )
{
    LCD_Port = (LCD_Port & 0x0F) | (cmnd & 0xF0); /* sending upper nibble */
    LCD_Port &= ~ (1<<RS);        /* RS=0, command reg. */
    LCD_Port |= (1<<EN);        /* Enable pulse */
    delay_us(1);
    LCD_Port &= ~ (1<<EN);

    delay_us(200);

    LCD_Port = (LCD_Port & 0x0F) | (cmnd << 4);  /* sending lower nibble */
    LCD_Port |= (1<<EN);
    delay_us(1);
    LCD_Port &= ~ (1<<EN);
    delay_ms(2);
}


void LCD_Char( unsigned char data )
{
    LCD_Port = (LCD_Port & 0x0F) | (data & 0xF0); /* sending upper nibble */
    LCD_Port |= (1<<RS);        /* RS=1, data reg. */
    LCD_Port|= (1<<EN);
    delay_us(1);
    LCD_Port &= ~ (1<<EN);

    delay_us(200);

    LCD_Port = (LCD_Port & 0x0F) | (data << 4); /* sending lower nibble */
    LCD_Port |= (1<<EN);
    delay_us(1);
    LCD_Port &= ~ (1<<EN);
    delay_ms(2);
}

void LCD_Init (void)            /* LCD Initialize function */
{
    LCD_Dir = 0xFF;            /* Make LCD port direction as o/p */
    delay_ms(20);            /* LCD Power ON delay always >15ms */
    
    LCD_Command(0x02);        /* send for 4 bit initialization of LCD  */
    LCD_Command(0x28);              /* 2 line, 5*7 matrix in 4-bit mode */
    LCD_Command(0x0c);              /* Display on cursor off*/
    LCD_Command(0x06);              /* Increment cursor (shift cursor to right)*/
    LCD_Command(0x01);              /* Clear display screen*/
    delay_ms(2);
}


void LCD_String (char *str)		/* Send string to LCD function */
{
	int i;
	for(i=0;str[i]!=0;i++)		/* Send each char of string till the NULL */
	{
		LCD_Char (str[i]);
	}
}

void LCD_String_xy (char row, char pos, char *str)	/* Send string to LCD with xy position */
{
	if (row == 0 && pos<16)
	LCD_Command((pos & 0x0F)|0x80);	/* Command of first row and required position<16 */
	else if (row == 1 && pos<16)
	LCD_Command((pos & 0x0F)|0xC0);	/* Command of first row and required position<16 */
	LCD_String(str);		/* Call LCD string function */
}

void LCD_Clear()
{
	LCD_Command (0x01);		/* Clear display */
	delay_ms(2);
	LCD_Command (0x80);		/* Cursor at home position */
}


void off_LED(char floor, char dir){
    switch (floor) {
        case 0:{
            PORTD &= ~(1<<0);
            break;
        }
        case 1:{
            if (dir == 'u')
                PORTD &= ~(1<<1);
            else
                PORTD &= ~(1<<2);
            break;
        }
        case 2:{
            if (dir == 'u')
                PORTD &= ~(1<<3);
            else
                PORTD &= ~(1<<4);
            break;
        }
        case 3:{
            if (dir == 'u')
                PORTD &= ~(1<<5);
            else
                PORTD &= ~(1<<6);
            break;
        }
        case 4:{
            PORTD &= ~(1<<7);
            break;
        }
    }; 
}

unsigned char calc_distance_time(unsigned char cabin_number, unsigned char floor, unsigned char direction){
    unsigned char distance = 0;  
    unsigned char i = 0;
    unsigned char limit_up = 4;
    unsigned char limit_down = 0;          
    if (direction == 'u'){
        if (cabins_states[cabin_number]=='u'){
            if (floor >= cabins_floors[cabin_number]){
                distance = 3*(floor-cabins_floors[cabin_number]);
                for (i = cabins_floors[cabin_number]+1; i <= floor; i++){
                    if (cabins_up_stops[i] == 1)
                        distance += 10;
                }
            }                                                  
            else{
                for (i = cabins_floors[cabin_number]; i < 5; i++){
                    if (cabins_up_stops[i] == 1)
                        limit_up = i;
                }
                for (i = cabins_floors[cabin_number]+1; i <= limit_up; i++){
                    if (cabins_up_stops[i] == 1)
                        distance += 10;
                    distance += 3;
                }
                for (i = limit_up; i < 255; i--){
                    if (cabins_down_stops[i] == 1)
                        limit_down = i;
                }
                for (i = limit_up-1; i >= limit_down && i < 255; i--){
                    if (cabins_down_stops[i] == 1)
                        distance += 10;
                    distance += 3;
                }
                distance += 3*(floor-limit_down)?limit_down<=floor:3*(limit_down-floor);
                distance += 10;
            }
        }
        else if (cabins_states[cabin_number]=='d'){
            for (i = cabins_floors[cabin_number]; i < 255; i--){
                if (cabins_down_stops[i] == 1)
                    limit_down = i;
            }
            for (i = cabins_floors[cabin_number]-1; i >= limit_down && i < 255; i--){
                if (cabins_down_stops[i] == 1)
                    distance += 10;
                distance += 3;
            }
            if (floor >= limit_down){
                distance = 3*(floor-limit_down)+10;                   
                for (i = limit_down; i <= floor; i++){
                    if (cabins_up_stops[i] == 1)
                        distance += 10;
                }
            }
            else{
                distance = 3*(limit_down-floor)+10;
            }
        }                        
        else{
            if (cabins_floors[cabin_number]<=floor){
                distance += 3*(floor-cabins_floors[cabin_number]);
            }
            else{
                distance += 3*(cabins_floors[cabin_number]-floor);
            }
            distance += 10;
        }    
    }
    else{
        if (cabins_states[cabin_number]=='d'){
            if (floor <= cabins_floors[cabin_number]){
                distance = 3*(cabins_floors[cabin_number]-floor);
                for (i = cabins_floors[cabin_number]-1; i >= floor && i < 255; i--){
                    if (cabins_down_stops[i] == 1)
                        distance += 10;
                }
            }                                                  
            else{
                for (i = cabins_floors[cabin_number]; i < 255; i--){
                    if (cabins_down_stops[i] == 1)
                        limit_down = i;
                }
                for (i = cabins_floors[cabin_number]-1; i >= limit_down && i < 255; i--){
                    if (cabins_down_stops[i] == 1)
                        distance += 10;
                    distance += 3;
                }
                for (i = limit_down; i < 5; i++){
                    if (cabins_up_stops[i] == 1)
                        limit_up = i;
                }
                for (i = limit_down+1; i <= limit_up; i++){
                    if (cabins_up_stops[i] == 1)
                        distance += 10;
                    distance += 3;
                }
                distance += 3*(floor-limit_up)?limit_up<=floor:3*(limit_up-floor);
                distance += 10;
            }
        }
        else if (cabins_states[cabin_number]=='u'){
            for (i = cabins_floors[cabin_number]; i < 5; i++){
                if (cabins_up_stops[i] == 1)
                    limit_up = i;
            }
            for (i = cabins_floors[cabin_number]+1; i <= limit_up; i++){
                if (cabins_down_stops[i] == 1)
                    distance += 10;
                distance += 3;
            }
            if (floor <= limit_up){
                distance = 3*(limit_up-floor)+10;
                for (i = limit_up; i >= floor && i < 255; i--){
                    if (cabins_down_stops[i] == 1)
                        distance += 10;
                }
            }
            else{
                distance = 3*(floor-limit_up)+10;
            }
        }                        
        else{
            if (cabins_floors[cabin_number]<=floor){
                distance += 3*(floor-cabins_floors[cabin_number]);
            }
            else{
                distance += 3*(cabins_floors[cabin_number]-floor);
            }
            distance += 10;
            
        }                  
    }             
    //LCD_Char(cabin_number);
    //LCD_Char(' ');
    //LCD_Char('0'+distance);
    return distance;
}


void check_out_buttons(){
    unsigned char cabin0_dist = 0;
    unsigned char cabin1_dist = 0;
    if (PINC & (1<<0)){
        // up for zero
        cabin0_dist = calc_distance_time(0, 0, 'u');
        cabin1_dist = calc_distance_time(1, 0, 'u');
        if (cabin1_dist < cabin0_dist){
            cabins_up_stops[1][0] = 1;
        }
        else{                          
            cabins_up_stops[0][0] = 1;
        }
        PORTD = PORTD | (1<<0);                        
    }
    if (PINC & (1<<1)){
        // up for one
        cabin0_dist = calc_distance_time(0, 1, 'u');
        cabin1_dist = calc_distance_time(1, 1, 'u');
        if (cabin1_dist < cabin0_dist){
            cabins_up_stops[1][1] = 1;
        }
        else{
            cabins_up_stops[0][1] = 1;
        }                      
        PORTD = PORTD | (1<<1);
    }
    if (PINC & (1<<2)){        
        // down for one
        cabin0_dist = calc_distance_time(0, 1, 'd');
        cabin1_dist = calc_distance_time(1, 1, 'd');
        if (cabin1_dist < cabin0_dist){
            cabins_down_stops[1][1] = 1;
        }
        else{
            cabins_down_stops[0][1] = 1;
        }                    
        PORTD = PORTD | (1<<2);
    }
    if (PINC & (1<<3)){
        // up for two
        cabin0_dist = calc_distance_time(0, 2, 'u');
        cabin1_dist = calc_distance_time(1, 2, 'u');
        if (cabin1_dist < cabin0_dist){
            cabins_up_stops[1][2] = 1;
        }
        else{
            cabins_up_stops[0][2] = 1;
        }                    
        PORTD = PORTD | (1<<3);
    }
    if (PINC & (1<<4)){
        // down for two
        cabin0_dist = calc_distance_time(0, 2, 'd');
        cabin1_dist = calc_distance_time(1, 2, 'd');
        if (cabin1_dist < cabin0_dist){
            cabins_down_stops[1][2] = 1;                          
        }
        else{
            cabins_down_stops[0][2] = 1;   
        }                    
        PORTD = PORTD | (1<<4);
    }
    if (PINC & (1<<5)){
        // up for three
        cabin0_dist = calc_distance_time(0, 3, 'u');
        cabin1_dist = calc_distance_time(1, 3, 'u');
        if (cabin1_dist < cabin0_dist){
            cabins_up_stops[1][3] = 1;
        }
        else{
            cabins_up_stops[0][3] = 1;
        }              
        PORTD = PORTD | (1<<5);    
    }
    if (PINC & (1<<6)){
        // down for three
        cabin0_dist = calc_distance_time(0, 3, 'd');
        cabin1_dist = calc_distance_time(1, 3, 'd');
        if (cabin1_dist < cabin0_dist){
            cabins_down_stops[1][3] = 1;
        }
        else{
            cabins_down_stops[0][3] = 1;
        }                    
        PORTD = PORTD | (1<<6);
    }
    if (PINC & (1<<7)){
        // down for four
        cabin0_dist = calc_distance_time(0, 4, 'd');
        cabin1_dist = calc_distance_time(1, 4, 'd');
        if (cabin1_dist < cabin0_dist){
            cabins_down_stops[1][4] = 1;
        }
        else{
            cabins_down_stops[0][4] = 1;
        }                    
        PORTD = PORTD | (1<<7);
    }

}

void check_in_buttons(){
    if (PINB & (1<<0)){
        cabins_down_stops[0][0] = 1;    
    }
    if (PINB & (1<<1)){
        if (cabins_floors[0] > 1)
            cabins_down_stops[0][1] = 1;
        else
            cabins_up_stops[0][1] = 1;
    }                           
    if (PINB & (1<<2)){
        if (cabins_floors[0] > 2)
            cabins_down_stops[0][2] = 1;
        else
            cabins_up_stops[0][2] = 1;
    }                           
    if (PINB & (1<<3)){
        if (cabins_floors[0] > 3)
            cabins_down_stops[0][3] = 1;
        else
            cabins_up_stops[0][3] = 1;
    }                           
    if (PINB & (1<<4)){
        cabins_down_stops[0][4] = 1;    
    }                         
    if (PINB & (1<<5)){
        cabins_down_stops[1][0] = 1;    
    }                      
    if (PINB & (1<<6)){
        if (cabins_floors[1] > 1)
            cabins_down_stops[1][1] = 1;
        else
            cabins_up_stops[1][1] = 1;
    }                           
    if (PINB & (1<<7)){
        if (cabins_floors[1] > 2)
            cabins_down_stops[1][2] = 1;
        else
            cabins_up_stops[1][2] = 1;
    }                           
    if (PINA & (1<<0)){
        if (cabins_floors[1] > 3)
            cabins_down_stops[1][3] = 1;
        else
            cabins_up_stops[1][3] = 1;
    }                           
    if (PINA & (1<<1)){
        cabins_down_stops[1][4] = 1;    
    }                      
}

void update_lcd(){
    unsigned char string[2][17];
    string[0][0] = 'F';         
    string[0][1] = 'l';
    string[0][2] = 'o';
    string[0][3] = 'o';
    string[0][4] = 'r';
    string[0][5] = ':';
    string[0][6] = '0'+cabins_floors[0];
    string[0][7] = ' ';
    string[0][8] = ' ';
    string[0][9] = ' ';
    string[0][10] = 'D';
    string[0][11] = 'i';
    string[0][12] = 'r';
    string[0][13] = ':';
    if (cabins_states[0]=='u')
        string[0][14] = 'U';
    else if (cabins_states[0]=='d')
        string[0][14] = 'D';
    else
        string[0][14] = 'S';  
    if (threshold[0] == 10 && cabins_states[0] != 's'){
        string[0][15] = '*';
    }
    else{
        string[0][15] = ' '; 
    }
    string[0][16] = '\0';
    
           
    string[1][0] = 'F';         
    string[1][1] = 'l';
    string[1][2] = 'o';
    string[1][3] = 'o';
    string[1][4] = 'r';
    string[1][5] = ':';
    string[1][6] = '0'+cabins_floors[1];
    string[1][7] = ' ';
    string[1][8] = ' ';
    string[1][9] = ' ';
    string[1][10] = 'D';
    string[1][11] = 'i';
    string[1][12] = 'r';
    string[1][13] = ':';
    if (cabins_states[1]=='u')
        string[1][14] = 'U';
    else if (cabins_states[1]=='d')
        string[1][14] = 'D';
    else
        string[1][14] = 'S';
    if (threshold[1] == 10 && cabins_states[1] != 's'){
        string[1][15] = '*';
    }
    else{
        string[1][15] = ' '; 
    }string[1][16] = '\0';
    
    LCD_String_xy(0, 0, string[0]);
    LCD_String_xy(1, 0, string[1]);
}


void move_cabin_states(){
    unsigned char i = 0; 
    unsigned char j = 0;
    for (i=0; i<2; i++){
        if (cabins_states[i] == 's'){
            for (j = 0; j < 5; j++){
                if (cabins_up_stops[i][j] == 1 | cabins_down_stops[i][j] == 1){
                    if (j > cabins_floors[i]) {
                        cabins_states[i] = 'u';
                        threshold[i] = 3;
                    }
                    else if (j < cabins_floors[i]){
                        cabins_states[i] = 'd';      
                        threshold[i] = 3;
                    }             
                    else{                    
                        threshold[i] = 10;
                        if (cabins_up_stops[i][j] == 1){
                            cabins_states[i] = 'u';
                        }
                        else{  
                            cabins_states[i] = 'd';
                        }
                    }
                    //TODO timer 3 seconds
                    if (i == 0){
                        //timer0               
                        //PORTD = PORTD | (1<<0);
                        //threshold[0] = 3;
                        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
                        TCNT0=0x83;
                    }
                    else{
                        //timer2                 
                        //threshold[1] = 3;
                        TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (1<<CS22) | (1<<CS21) | (0<<CS20);
                        TCNT2=0x83;
                    }
                }    
            }
        }
    }
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

// PortD: LEDs for up and down
// up for 0
DDRD = DDRD | ( 1<<0);
// up for 1
DDRD = DDRD | ( 1<<1);
// down for 1
DDRD = DDRD | ( 1<<2);
// up for 2
DDRD = DDRD | ( 1<<3);
// down for 2
DDRD = DDRD | ( 1<<4);
// up for 3
DDRD = DDRD | ( 1<<5);
// down for 3
DDRD = DDRD | ( 1<<6);
// up for 4
DDRD = DDRD | ( 1<<7);

// PortC: Buttons for up and down
// up for 0 
DDRC = DDRC & ~(1<<0);
// up for 1           
DDRC = DDRC & ~(1<<1);
// down for 1
DDRC = DDRC & ~(1<<2);
// up for 2
DDRC = DDRC & ~(1<<3);
// down for 2  
DDRC = DDRC & ~(1<<4);
// up for 3
DDRC = DDRC & ~(1<<5);
// down for 3
DDRC = DDRC & ~(1<<6);
// down for 4
DDRC = DDRC & ~(1<<7);

// PortB and PortA: Buttons in Cabins
// Cab1, Floor0
DDRB = DDRB & ~(1<<0);     
// Cab1, Floor1
DDRB = DDRB & ~(1<<1);
// Cab1, Floor2
DDRB = DDRB & ~(1<<2);
// Cab1, Floor3
DDRB = DDRB & ~(1<<3);
// Cab1, Floor4
DDRB = DDRB & ~(1<<4);

// Cab2, Floor0
DDRB = DDRB & ~(1<<5);     
// Cab2, Floor1
DDRB = DDRB & ~(1<<6);
// Cab2, Floor2
DDRB = DDRB & ~(1<<7);
// Cab2, Floor3
DDRA = DDRA & ~(1<<0);
// Cab2, Floor4
DDRA = DDRA & ~(1<<1);

LCD_Init();
LCD_Clear(); 
cabins_states[0] = 's';
cabins_states[1] = 's';
while (1)
      {
      // Place your code here 
       check_out_buttons();
       check_in_buttons();
       move_cabin_states();
       update_lcd(); 
      }
}

#define MAX_VOLTAGE 4

#ifndef F_CPU
#define F_CPU 16000000UL // 16 MHz clock speed
#endif


#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <avr/io.h>
#include <util/delay.h>

#include "lcd.h"

#include <stdlib.h>
#include <math.h>


int main(void)
{
	DDRD = 0xFF;
	DDRC = 0xFF;
	
	ADMUX	= 0b00100001; // AVCC-LeftRes-ADC0
	ADCSRA	= 0b10000001; // EN-NOT_START-DIS_AUTO_TRIG-INT_FLG_0-INT_EN_0-PreScaler2
	
	unsigned int value = 0;
	float result=0.0;
	
	Lcd4_Init();
	
	while(1)
	{
		ADCSRA |= (1<<ADSC);// start conversion
		while(ADCSRA&(1<<ADSC)); // wait until finished
		value = (ADCL>>6)|(ADCH<<2);
		result = MAX_VOLTAGE*value/1024.0;
		
		Lcd4_Clear();

		char num[15];

		dtostrf(result , 3 , 2 , num);// pls visit https://stackoverflow.com/questions/48170408/confused-about-dtostrf-function 
		
		Lcd4_Set_Cursor(1,0);
		Lcd4_Write_String("Voltage : ");
		Lcd4_Write_String(num);
		_delay_ms(500);
	}

}

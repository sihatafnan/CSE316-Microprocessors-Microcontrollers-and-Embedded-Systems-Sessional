/*
 * GccApplication1.c
 *
 * Created: 4/8/2021 11:35:26 AM
 * Author : Sihat Afnan
 */ 


#include <avr/io.h>
#define F_CPU 1000000
#include "util/delay.h"
#include <avr/interrupt.h> 


int is_static = 1;


void rotate_display(int P[8][8] ){
	for(int k=0;k<8;k++){ 
		if(is_static)break;    //reduce delay if mode changed to static
		for(int l=0;l<50;l++){   //speed control 
			if(is_static)break;
			for(int i=0;i<8;i++){
				for(int j=0;j<8;j++){
					if(P[j][i]){
						PORTA=1<<i;
						int m;
						m=(j+k)%8;
						PORTB=~(1<<(m));
						_delay_ms(.5);
					}
				}
			}
		}
	}
	//Shifting matrix
	
	int tmp[8];
	for(int i=0;i<8;i++){
		tmp[i] = P[0][i];
	}
	for(int i=0;i<8;i++){
		P[0][i] = P[7][i];
	}
	for(int i=6;i>0;i--){
		for(int j=1;j<7;j++){
			P[i+1][j] = P[i][j];
		}
	}
	for(int i=0;i<8;i++){
		P[1][i] = tmp[i];
	}
}

void static_display(int P[8][8]){
	
	for(int i=0;i<8;i++){
		for(int j=0;j<8;j++){
			if(P[j][i]){
				
				PORTA=1<<i;
				PORTB=~(1<<j);
				_delay_ms(.5);
			}
		}
	}
}


ISR(INT0_vect)
{
	is_static ^= 1;
}

int main(void)
{
	
    /* I am displaying 8.You can modify according to your own */
	
	int Pattern[8][8]={
		{0,0,1,1,1,1,0,0},
		{0,1,0,0,0,0,1,0},
		{0,1,0,0,0,0,1,0},
		{0,0,1,1,1,1,0,0},
		{0,0,1,1,1,1,0,0},
		{0,1,0,0,0,0,1,0},
		{0,1,0,0,0,0,1,0},
		{0,0,1,1,1,1,0,0}
	};

	
	DDRA = 0xFF;
	DDRD = 0x00;
	DDRB = 0xFF;
	DDRC = 0xFF;

	
	GICR = (1<<INT0); //STEP3
	MCUCR = MCUCR & 0b00000011;//STEP4
	sei();//STEP5
	
	is_static = 1;
    while (1) 
    {	
		if(is_static){
			static_display(Pattern);
		}
		else{
			rotate_display(Pattern);
		}
    }
}


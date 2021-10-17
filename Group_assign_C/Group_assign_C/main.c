/*
 * Group_1_assign_C.c
 *
 * Created: 10/17/2021 9:22:58 PM
 * Author : GROUP_1
 */ 
/*C language for continuously transferring the data
 12 H, 22 H, 32 H, 42H, 52 H, 52H,42H, 32H,22H, 12H,22H,32H,42H,52H,12H…and so on in a serial manner (one bit at a time) 
 through the pin PC3. Send the MSB of each byte first. 
 Note that after end of every transmission of 52H data there should be a delay of 1.5 seconds and the Port C.6 bit is to be toggled once.
 
 Three loops are used for printing the above pattern. Each loop prints 12H-52H, 52H-12H, 22H-52H respectively. For each byte, one for loop is used which send one bit at a time 8times.
*/
#define F_CPU 8000000
#include<avr/io.h>
#include<util/delay.h>
#define sp 3
int main(void)
{

	unsigned char x;
	DDRC |= (1 << sp);
	
	while(1) //infinite loop
	{	
	
	unsigned char conbyte = 0x12; 
	unsigned char aa = 0x10;
	unsigned char regALSB;
	while(1)     //first loop for sending 12H-52H(running 5 times)
	{
		regALSB = conbyte;
		
		for(x=0;x<8;x++)		//for loop for sending one bit at a time
		{
			if(regALSB & 0x80){
				PORTC |=(1<<sp);
			}
			else{
				PORTC &= ~(1<<sp);
			}
			regALSB = regALSB<<1;
			
		}
		conbyte += aa;
		if(conbyte==0x62){
					PORTC ^= (1<<PORTC6);  //to toggle PORTC_6
					_delay_ms(1500);       // delay of 1.5 sec
					break;
				}
	}
	while(1)			//second loop for sending 52H-12H
	{
				conbyte -= aa;
				regALSB = conbyte;
				for(x=0;x<8;x++)  // for loop for sending one bit at a time
				{
					if(regALSB & 0x80){
						PORTC |=(1<<sp);
					}
					else{
						PORTC &= ~(1<<sp);
					}
					regALSB = regALSB<<1;
					
				}
				if(conbyte==0x52){
					PORTC ^= (1<<PORTC6); // to toggle PORTC_6 and delay
					_delay_ms(1500);
				}
				if(conbyte==0x12){
					break;
				}
			}
	while(1)   // third loop for sending 22H-52H(running 4 times)
	{
		conbyte += aa;
				regALSB = conbyte;
				for(x=0;x<8;x++){
					if(regALSB & 0x80){
						PORTC |=(1<<sp);
					}
					else{
						PORTC &= ~(1<<sp);
					}
					regALSB = regALSB<<1;
					
				}
				
			if(conbyte==0x52)
			{
					PORTC ^= (1<<PORTC6);
					_delay_ms(1500);
					break;
			}
	}
	
}
	return 0;

}

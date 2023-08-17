#include <at89c5131.h>
#include "lcd.h"				//Header file with LCD interfacing functions
#include "MorseCode.h"	//Header file for Morse Code

sbit LED=P1^7;
//sbit P1_0=P1^0;
//sbit P1_1=P1^1;
//sbit P1_2=P1^2;
//sbit P1_3=P1^3;


/*
Port P0.7 is used for the audio signal output
*/
//Main function

void main(void)
{

	//Call initialization functions
	lcd_init();
	/*unsigned char a="a";
	unsigned char b="b";
	unsigned char c="c";
	unsigned char d="d";
	unsigned char e="e";*/

    P1=0xFF; //configured to take input
		msdelay(2000);
    if(P1_0){
			  lcd_write_string("a");
        morsea();

    }
    else if(P1_1){
      lcd_write_string("b");  
			morseb(); 
    }
    else if(P1_2){ 
      lcd_write_string("c");
			morsec();
    }
    else if(P1_3){        
			lcd_write_string("d");
        morsed();

    }
    else{ 
			lcd_write_string("e");
        morsee();   
    }
		
		while(1){} //To stop playing

	// Read input nibble here



	// Insert Priority Logic
	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h
	// Write to LCD using function lcd_write_string() in side the condition as well


	//
}

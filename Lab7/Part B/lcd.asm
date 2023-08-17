; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
LJMP MAIN

//-----------TIMER 0 INTERRUPT-----------
ORG 001BH
	INC R2
	ACALL DELAY_25MS
	RETI
	
	
org 030h  
MAIN:	

      acall delay
	  acall delay
	  acall lcd_init     ;initialise LCD

//-------FIRST-------
	  acall delay
	  acall delay
	  acall delay
	  mov a,#82h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  START:
	  MOV R2, #0
      ACALL DELAY_25MS
	  ACALL N1
	  ;ACALL SIL_1
	  ACALL N2
	  ;ACALL SIL_1
	  ACALL N3
	  ;ACALL SIL_1
	  ACALL N2
	  ;ACALL SIL_1
	  ACALL N4
	  ACALL SIL
	  ACALL N4
	  ;ACALL SIL_1
	  ACALL N5
	  ;ACALL SIL_1
	  LJMP START
	  
	  
	  
	  N1:
	  MOV R2, #0
	  N1_0:
	  MOV R1, #1
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0EEH
	  MOV TL0, #03FH 
	  SETB TR0 //START THE TIMER  
	  SETB P0.7
	  AGAIN10: JNB TF0, AGAIN10
	  
	  N1_1:
	  CPL P0.7
	  CLR TR0
	  CLR TF0
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0EEH
	  MOV TL0, #3FH 
	  SETB TR0 //START THE TIMER  
	  AGAIN11: JNB TF0, AGAIN11
	  CLR TR0
	  CLR TF0
	  CJNE R2, #30, N1_0
	  RET
	  
	  N2:
	  MOV R2, #0
	  N2_0:
	  MOV R1, #2
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F0H
	  MOV TL0, #30H 
	  SETB TR0 //START THE TIMER  
	  SETB P0.7//START THE 
	  AGAIN20: JNB TF0, AGAIN20
	  CPL P0.7
	  CLR TR0
	  CLR TF0
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F0H
	  MOV TL0, #30H  
	  SETB TR0 //START THE TIMER  
	  AGAIN21: JNB TF0, AGAIN21
	  CLR TR0
	  CLR TF0
	  CJNE R2, #30, N2_0
	  RET
	  
	  
	  N3:
	  MOV R2, #0
	  N3_0:
	  MOV R1, #3
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F2H
	  MOV TL0, #0B7H 
	  SETB TR0 //START THE TIMER  
	  SETB P0.7//START THE 
	  AGAIN30: JNB TF0, AGAIN30
	  CPL P0.7
	  CLR TR0
	  CLR TF0
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F2H
	  MOV TL0, #0B7H 
	  SETB TR0 //START THE TIMER  
	  AGAIN31: JNB TF0, AGAIN31
	  CLR TR0
	  CLR TF0
	  CJNE R2, #30, N3_0
	  RET

	  N4:
	  MOV R2, #0
	  N4_0:
	  MOV R1, #4
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F5H
	  MOV TL0, #72H 
	  SETB TR0 //START THE TIMER  
	  SETB P0.7//START THE 
	  AGAIN40: JNB TF0, AGAIN40
	  CPL P0.7
	  CLR TR0
	  CLR TF0
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F5H
	  MOV TL0, #72H 
	  SETB TR0 //START THE TIMER  
	  AGAIN41: JNB TF0, AGAIN41
	  CLR TR0
	  CLR TF0
	  CJNE R2, #40, N4_0
	  RET

	  N5:
	  MOV R2, #0
	  N5_0:
	  MOV R1, #5
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F4H
	  MOV TL0, #2AH 
	  SETB TR0 //START THE TIMER  
	  SETB P0.7//START THE 
	  AGAIN50: JNB TF0, AGAIN50
	  CPL P0.7
	  CLR TR0
	  CLR TF0
	  MOV TMOD, #11H //TIMER 0 MODE 1
	  MOV TH0, #0F4H
	  MOV TL0, #2AH 
	  SETB TR0 //START THE TIMER  
	  AGAIN51: JNB TF0, AGAIN51
	  CLR TR0
	  CLR TF0
	  CJNE R2, #40, N5_0
	  RET
	  
	  SIL:
	  MOV R2, #0
	  SIL_0:
	  CLR P0.7
	  CJNE R2, #20, SIL_0

//FOR DEBUGGING----------
	  SIL_1:
	  MOV R2, #0
	  SIL_10:
	  CLR P0.7
	  CJNE R2, #2, SIL_10
	  
	  



DELAY_25MS:
MOV TMOD, #11H //TIMER 1 MODE 1
MOV TL1, #0B0H
MOV TH1, #3CH
MOV IE, #88H //TIMER 1 INTERRUPT
SETB TR1
RET


;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register //1- da
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
	delay:	 push 0
			push 1
			 mov r0,#1
	loop2:	 mov r1,#255
		 loop1:	 djnz r1, loop1
		 djnz r0, loop2
		 pop 1
		 pop 0 
		 ret
		 
/*DELAY_250:
MOV R3, #10
LOOP: ACALL DELAY_25MS
C_14: DJNZ R3, LOOP

RET*/

/*DELAY_33920:
MOV TMOD, #00000001B //TIMER 0 MODE 1
MOV TL0, #0FFH
MOV TH0, #0FFH
SETB TR0
AGAIN: JNB TF0, AGAIN
CLR TR0
CLR TF0
RET*/

//--------------ASCII---------------------------
ASCII:
	
	MOV R2, #2
	MOV A, @R0
	ANL A, #240 //AND WITH 11110000
	SWAP A
	MOV R1, 03H //R3
	CJNE A, #10, NUMB //IF <=9, C=1
	CJNE A, #9, NUMB
	
	HERE1:
	INC R1
	MOV A, @R0
	ANL A, #15 //AND WITH 00001111
	CJNE A, #10, NUMB //IF <=9, C=1
		
		NUMB:
		JNC LETTER
		ADD A,#30H
		MOV @R1,A
		DJNZ R2, HERE1
		RET
		
		LETTER:
		ADD A, #37H
		MOV @R1,A
		DJNZ R2, HERE1
		RET


;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "ROLLING TIME", 00H	 

end


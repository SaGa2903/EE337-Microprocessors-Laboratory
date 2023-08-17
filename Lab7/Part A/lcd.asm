; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
LJMP MAIN

//-----------TIMER 0 INTERRUPT-----------
ORG 000BH
	INC R4
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
	  mov a,#83h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  mov a,#0C2h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  MOV P1, #00001111B
	  ACALL DELAY_1
	  ACALL DELAY_1
	  
	  SETB P1.4 //led 4 glows
	  
	  
	  MOV R4, #0H //COUNTS THE NUMBER OF OVERFLOWS
	  
	  TIMER:
	  //TIMER 0 INTERRUPT
	  MOV TMOD, #01H //TIMER 0 MODE 1
	  MOV TH0, #00H
	  MOV TL0, #00H 
	  MOV IE, #10000010B
	  SETB TR0 //START THE TIMER
	  
	  HERE:
	  JNB P1.0, DISPLAY //IF SWITCH TOGGLED 
	  SJMP HERE //SORT OF POLLING
	  
DISPLAY:
	  CLR TR0
	  CLR P1.4
	  MOV 60H, R4 //NO OF OVERFLOWS
	  MOV 62H, TH0 //TH0
	  MOV 64H, TL0 //TL0
	  
	  MOV R0, #60H
	  MOV R3, #70H
	  CALL ASCII
	  
	  MOV R0, #62H
	  MOV R3, #72H
	  CALL ASCII
	  
	  MOV R0, #64H
	  MOV R3, #74H
	  CALL ASCII
	  
	  acall delay
	  acall lcd_init 
	  acall delay
	  acall delay
	  acall delay
	  mov a,#81h		 ;Put cursor on first row,2nd column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  
	  mov a,#0C0h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string4
	  acall lcd_sendstring
	  acall delay
      mov   a,70H
	  acall lcd_senddata
      mov   a,71H
	  acall lcd_senddata
	  acall delay
	  
	  mov   dptr,#my_string5   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay	  
	  //mov a,#0C9h		  
	  //acall lcd_command
	  //acall delay
	  
      mov   a,72H
	  acall lcd_senddata
	  acall delay
      mov   a,73H
	  acall lcd_senddata
	  acall delay
	  mov   a,74H
	  acall lcd_senddata
	  acall delay
      mov   a,75H
	  acall lcd_senddata
	  acall delay	
	  
	  ACALL DELAY_1
	  ACALL DELAY_1
	  ACALL DELAY_1
	  ACALL DELAY_1
	  ACALL DELAY_1

	  
	    
JMP MAIN
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
		 
DELAY_1:
MOV R3, #30
LOOP: ACALL DELAY_30
C_14: DJNZ R3, LOOP
//ACALL DELAY_33920
RET

/*DELAY_33920:
MOV TMOD, #00000001B //TIMER 0 MODE 1
MOV TL0, #0FFH
MOV TH0, #0FFH
SETB TR0
AGAIN: JNB TF0, AGAIN
CLR TR0
CLR TF0
RET*/

DELAY_30:
MOV TMOD, #10H //TIMER 0 MODE 1
MOV TL1, #0
MOV TH1, #0
SETB TR1
AGAIN1: JNB TF1, AGAIN1
CLR TR1
CLR TF1
RET

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
         DB   "Toggle SW1", 00H
my_string2:
         DB   "if LED glows", 00H
my_string3:
         DB   "Reaction Time", 00H
my_string4:
         DB   "Count is ", 00H
my_string5:
         DB   " ", 00H			 

end


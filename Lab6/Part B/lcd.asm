; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 100h
start:

      ;mov P1,#00h
	  //f 3 b 1
	  MOV 70H, #0F3H
	  MOV 71H, #0B1H
	  
	  ;initial delay for lcd power up
	  
DISPLAY:	

      acall delay
	  acall delay
	  acall lcd_init     ;initialise LCD

//-------LEVEL 1-------
	  MOV R3, #1H
	  acall delay
	  acall delay
	  acall delay
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  MOV A, 70H
	  ANL A, #00001111B
	  SWAP A
	  MOV P1, A
	  LJMP FIND
	  
	  LVL1:	  
	  mov a,#0C2h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  acall lcd_sendstring
	  ACALL DELAY_1
	  
//--------LEVEL 2----------
	  acall delay
	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay
	  
	  MOV R3, #2H
	  acall delay
	  acall delay
	  acall delay
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string2   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  MOV A, 70H
	  ANL A, #11110000B
	  MOV P1, A
	  LJMP FIND
	  
	  LVL2:	 
	  mov a,#0C2h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  acall lcd_sendstring
	  ACALL DELAY_1
	  
//--------LEVEL 3----------
	  acall delay
	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay
	  
	  MOV R3, #3H
	  acall delay
	  acall delay
	  acall delay
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  MOV A, 71H
	  ANL A, #00001111B
	  SWAP A
	  MOV P1, A
	  LJMP FIND	

	  LVL3:	  
	  mov a,#0C2h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  acall lcd_sendstring
	  ACALL DELAY_1
	
//--------LEVEL 4----------
	  acall delay
	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay
	  
	  MOV R3, #4H
	  acall delay
	  acall delay
	  acall delay
	  mov a,#84h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string4   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  MOV A, 71H
	  ANL A, #11110000B
	  MOV P1, A
	  LJMP FIND

	  LVL4:	  	 
	  mov a,#0C2h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay

	  acall lcd_sendstring
	  ACALL DELAY_1
	  
JMP DISPLAY
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
MOV TMOD, #00000001B //TIMER 0 MODE 1
MOV TL0, #0
MOV TH0, #0
SETB TR0
AGAIN1: JNB TF0, AGAIN1
CLR TR0
CLR TF0
RET

//--------------------------FIND--------------------------
FIND:
CJNE A, #00H, B1
MOV DPTR, #BIN0
LJMP LVL

B1:
CJNE A, #10H, B2
MOV DPTR, #BIN1
LJMP LVL

B2:
CJNE A, #20H, B3
MOV DPTR, #BIN2
LJMP LVL

B3:
CJNE A, #30H, B4
MOV DPTR, #BIN3
LJMP LVL

B4:
CJNE A, #40H, B5
MOV DPTR, #BIN4
LJMP LVL

B5:
CJNE A, #50H, B6
MOV DPTR, #BIN5
LJMP LVL

B6:
CJNE A, #60H, B7
MOV DPTR, #BIN6
LJMP LVL

B7:
CJNE A, #70H, B8
MOV DPTR, #BIN7
LJMP LVL

B8:
CJNE A, #80H, B9
MOV DPTR, #BIN8
LJMP LVL

B9:
CJNE A, #90H, B10
MOV DPTR, #BIN9
LJMP LVL

B10:
CJNE A, #0A0H, B11
MOV DPTR, #BIN10
LJMP LVL

B11:
CJNE A, #0B0H, B12
MOV DPTR, #BIN11
LJMP LVL

B12:
CJNE A, #0C0H, B13
MOV DPTR, #BIN12
LJMP LVL

B13:
CJNE A, #0D0H, B14
MOV DPTR, #BIN13
LJMP LVL

B14:
CJNE A, #0E0H, B15
MOV DPTR, #BIN14
LJMP LVL

B15:
MOV DPTR, #BIN15

LVL:
CJNE R3, #1, NEXT2
LJMP LVL1

NEXT2:
CJNE R3, #2, NEXT3
LJMP LVL2

NEXT3:
CJNE R3, #3, NEXT4
LJMP LVL3

NEXT4:
LJMP LVL4
;------------- ROM text strings---------------------------------------------------------------
org 500h
my_string1:
         DB   "Level-1", 00H
my_string2:
         DB   "Level-2", 00H
my_string3:
         DB   "Level-3", 00H
my_string4:
         DB   "Level-4", 00H

bin0:
		 DB "VALUE : 0000", 00H
bin1:
		 DB "VALUE : 0001", 00H
bin2:
		 DB "VALUE : 0010", 00H		
bin3:
		 DB "VALUE : 0011", 00H		
bin4:
		 DB "VALUE : 0100", 00H	
bin5:
		 DB "VALUE : 0101", 00H
bin6:
		 DB "VALUE : 0110", 00H
bin7:
		 DB "VALUE : 0111", 00H
bin8:
		 DB "VALUE : 1000", 00H
bin9:
		 DB "VALUE : 1001", 00H
bin10:
		 DB "VALUE : 1010", 00H
bin11:
		 DB "VALUE : 1011", 00H
bin12:
		 DB "VALUE : 1100", 00H
bin13:
		 DB "VALUE : 1101", 00H
bin14:
		 DB "VALUE : 1110", 00H
bin15:
		 DB "VALUE : 1111", 00H			 

end


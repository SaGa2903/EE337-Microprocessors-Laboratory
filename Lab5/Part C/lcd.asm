; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 30h
start:
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay

//------------state 0----------
	  mov a,#82h		 ;Put cursor on first row,3 column //80h start
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3h		  ;Put cursor on second row,3 column //0c1 start
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring

	  acall delay_1s
 //------------state 1----------------
	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay
	//ACALL DELAY_2S
	
	MOV P1, #143 //1000 1111
	 
	  mov a,#81h		 ;Put cursor on first row,3 column //80h start
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string3   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3h		  ;Put cursor on second row,3 column //0c1 start
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring

	
	ACALL DELAY_2S
	MOV A, P1
	ANL A, #15 //0000 1111
	SWAP A
	MOV 30H, A

 //------------state 2----------------

	MOV P1, #79 //0100 1111	
	ACALL DELAY_2S
	MOV A, P1
	ANL A, #15 //0000 1111
	ADD A, 30H
	MOV 30H, A

 //------------state 3----------------
	
	MOV P1, #47 //0010 1111
	ACALL DELAY_2S
	MOV A, P1
	ANL A, #15 //0000 1111
	SWAP A
	MOV 31H, A
	
 //------------state 4----------------
	
	MOV P1, #31 //0001 1111
	ACALL DELAY_2S
	MOV A, P1
	ANL A, #15 //0000 1111
	ADD A, 31H
	MOV 31H, A
	
 //-----------INTER----------------
	MOV R0, #30H
	MOV R3, #60H
	CALL ASCII
	MOV R0, #31H
	MOV R3, #62H
	CALL ASCII
	//60H, 61H -> N1
	//62H, 63H -> N2
 //------------state 5----------------
	  acall delay
	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay
	
	MOV P1, #15 //0000 1111
	
	  mov a,#80h		 ;Put cursor on first row,3 column //80h start
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string4   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C0h		  ;Put cursor on second row,3 column //0c0 start
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string5
	  acall lcd_sendstring
	  acall delay
	  mov   a,60H
	  acall lcd_senddata
	  acall delay
	  mov   a,61H
	  acall lcd_senddata
	  acall delay
	  mov   dptr,#my_string6
	  acall lcd_sendstring
	  acall delay
	  mov   a,62H
	  acall lcd_senddata
	  acall delay
      mov   a,63H
	  acall lcd_senddata
	
	ACALL DELAY_2S
  
 //------MUL-------
	MOV A, 30H
	MOV B, 31H
	MUL AB
	MOV 50H, A
	MOV 51H, B
	
	MOV R0, #50H//LSB
	MOV R3, #66H
	CALL ASCII
	MOV R0, #51H//MSB
	MOV R3, #64H
	CALL ASCII
	
 //------------state 6----------------
 	  acall delay
	  acall lcd_init      ;initialise LCD
		
	  acall delay
	  acall delay
	  acall delay
	  
	MOV P1, #15
	
	  mov a,#81h		 ;Put cursor on first row,3 column //80h start
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string7   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
      mov   a,64H
	  acall lcd_senddata
      mov   a,65H
	  acall lcd_senddata
      mov   a,66H
	  acall lcd_senddata
	  acall delay
      mov   a,67H
	  acall lcd_senddata
	  acall delay	  

	  mov a,#0C0h		  ;Put cursor on second row,3 column //0c0 start
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string5
	  acall lcd_sendstring
	  acall delay
	  mov   a,60H
	  acall lcd_senddata
	  acall delay
	  mov   a,61H
	  acall lcd_senddata
	  acall delay
	  mov   dptr,#my_string6
	  acall lcd_sendstring
	  acall delay
	  mov   a,62H
	  acall lcd_senddata
	  acall delay
      mov   a,63H
	  acall lcd_senddata
	
	  
here: sjmp here				//stay here 

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
         setb  LCD_rs         ;Selected data register
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
		 
	delay_2s:
		push 00h
		mov r0, #2
		h5: acall delay_1s
		djnz r0, h5
		pop 00h
		ret
	
	delay_1s:
		push 00h
		mov r0, #5
		h4: acall delay_200ms
		djnz r0, h4
		pop 00h
		ret
		
	delay_200ms:
		push 00h
		mov r0, #200
		h3: acall delay_1ms
		djnz r0, h3
		pop 00h
		ret
	
	delay_1ms:
	//DELAY = C*12D/24MHz
	//DELAY FOR 1 CYCLE = 0.5us
		push 00h //2
		mov r0, #4 //1
		h2: acall delay_250us //2
		djnz r0, h2//2
		pop 00h//2
		ret//2
		
	delay_250us:
		push 00h//2
		mov r0, #244//1
		h1: djnz r0, h1//2
		pop 00h//2
		ret//2
	//2+1+244*2+2+2=495 //247.5us

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
         DB   "Enter Inputs", 00H
my_string2:
		 DB   "EE337-2022", 00H
my_string3:
		 DB   "Reading Inputs", 00H
my_string4:
		 DB   "Computing Result", 00H
my_string5:
		 DB   "Num1:", 00H
my_string6:
		 DB   ", Num2:", 00H
my_string7:
		 DB   "Result = ", 00H			 
end


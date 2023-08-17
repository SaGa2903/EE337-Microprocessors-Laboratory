ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL DATE
//HERE: SJMP HERE
ORG 130H
	DATE:
		MOV 50H, #25H
		MOV 51H, #06H
		MOV 52H, #19H
		MOV 53H, #83H
		
		MOV R1, #50H
		ACALL LOOP1
		ACALL DISPLAY_1111
		ACALL LOOP1
		ACALL DISPLAY_1111
		ACALL LOOP1
		ACALL LOOP1
		ACALL DISPLAY_1111
		
	LJMP DATE
	DISPLAY_1111:
		MOV P1, #255
		DELAY1: ACALL DELAY_1S
		RET
		
	LOOP1:
		MOV A, @R1
		ACALL LOOP
		INC R1
		RET
			
	LOOP:
		PUSH 02H
		MOV R2, #2
		DISPLAY: MOV P1, A
		DELAY: ACALL DELAY_1S
		SWAP A
		DJNZ R2, DISPLAY
		POP 02H
		RET
		
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
	RET
END
	
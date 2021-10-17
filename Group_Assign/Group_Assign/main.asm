;
; Group_1_Assign.asm
;
; Created: 10/14/2021 6:57:59 PM
; Author : Group_1
;Assembly language for continuously transferring the data 12 H, 22 H, 32 H, 42H, 52 H, 52H,42H, 32H,22H, 12H,22H,32H,42H,52H,12H…
;and so on in a serial manner (one bit at a time) through the pin PC3. 
;Send the MSB of each byte first. Note that after end of every transmission of 52H data there should be a delay of 1.5 seconds and the Port C.6 bit is to be toggled once.
;

; Replace with your application code
	.ORG 0
	LDI R27,HIGH(RAMEND) ;initialize SP
	OUT SPH,R27
	LDI R27,LOW(RAMEND)
	OUT SPL,R27
	
	SBI PORTC, 3	
	LDI R27, 64
	OUT PORTC, R27
start:
	LDI R16, 0x0
	LDI R17, 0x10
	LDI R18, 0X5
	LDI R21, 0x2
	;start sending 12H - 52H to PORTC- var11 
	;loop(running 5 times one for each number variable R18 branch_name-var11)
var11:
	ADD R21, R17
	ADD R16, R21	;increment R21 by 0x10 and copied to R16 for further operation
	LDI R19, 0X8
var21:		;start sending each bit of the data-
	; var21 (running 8 times one for each bit variable R19 branch_name-var21)
	LSL R16		; left shift R16 to get the MSB
	BRSH var31
	SBI PORTC, 3
	rjmp var41		;conditional branching whthere MSB is 0 or not
var31:
	CBI PORTC, 3
var41:
	DEC R19
	BRNE var21
	DEC R18
	BRNE var11

	CALL DELAY
	CALL TOGGLE

	;start sending 52H-12H to PORTC (running 5times variable R18 branch_name-var11)
	LDI R18, 0x05
	LDI R16, 0
var12:
	ADD R16,R21 ;copying content from R21 for further operation
	LDI R19, 0X8
	var22: ; start sending each
	; bit of data (running 8 times one for each bit variable-R19 branch_name-var22)
	LSL R16
	BRSH var32   ;conditional branching whthere MSB is 0 or not
	SBI PORTC, 3
	rjmp var42
var32:
	CBI PORTC, 3
var42:
	DEC R19
	BRNE var22
	LDI R20, 0x52
	CP R21,R20
	BRNE var52    ;Compares the contents of R20 with 0x52 and runs the toggle and delay accordingly

	CALL DELAY
	CALL TOGGLE

var52:
	SUB R21, R17 ; decrementing R21 by 0x10 for further operation
	DEC R18
	BRNE var12
;sending data from 22H-52H(running 4 times variable_name var13)
	LDI R16, 0x0
	LDI R17, 0x12
	LDI R18, 0X4
	LDI R21, 0x2
	;start sending 12H - 52H to PORTC- var11 
	;loop(running 5 times one for each number variable R18 branch_name-var11)
var13:
	ADD R21, R17
	ADD R16, R21	;increment R21 by 0x10 and copied to R16 for further operation
	LDI R19, 0X8
	var23:		;start sending each bit of the data- 
	;var21 (running 8 times one for each bit variable R19 branch_name-var21)
	LSL R16		; left shift R16 to get the MSB
	BRSH var33
	SBI PORTC, 3
	rjmp var43		;conditional branching whthere MSB is 0 or not
var33:
	CBI PORTC, 3
var43:
	DEC R19
	BRNE var23
	DEC R18
	BRNE var13

	CALL DELAY
	CALL TOGGLE

	rjmp start

DELAY: LDI R23, 48      //delay subroutine consisting of three loops of 48*250*255 giving a total delay of 1.5 sec
LOOP_1:
		LDI R24, 200
LOOP_2:
		LDI R25, 250
LOOP_3:
		NOP
		NOP
		DEC R25
		BRNE LOOP_3

		DEC R24
		BRNE LOOP_2

		DEC R23
		BRNE LOOP_1
		RET

TOGGLE: IN R26, PORTC  //toggling the PORTC pin 6 
		AND R26, R27
		BRNE LOOP_4
		SBI PORTC, 6
		RET
LOOP_4:
		CBI PORTC, 6
		RET	

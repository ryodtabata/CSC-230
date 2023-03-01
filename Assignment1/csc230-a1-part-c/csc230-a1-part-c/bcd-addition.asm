; bcd-addition.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (c). In this and other
; files provided through the semester, you will see lines of code
; indicating "DO NOT TOUCH" sections. You are *not* to modify the
; lines within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; In a more positive vein, you are expected to place your code with the
; area marked "STUDENT CODE" sections.

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: Two packed-BCD numbers are provided in R16
; and R17. You are to add the two numbers together, such
; the the rightmost two BCD "digits" are stored in R25
; while the carry value (0 or 1) is stored R24.
;
; For example, we know that 94 + 9 equals 103. If
; the digits are encoded as BCD, we would have
;   *  0x94 in R16
;   *  0x09 in R17
; with the result of the addition being:
;   * 0x03 in R25
;   * 0x01 in R24
;
; Similarly, we know than 35 + 49 equals 84. If 
; the digits are encoded as BCD, we would have
;   * 0x35 in R16
;   * 0x49 in R17
; with the result of the addition being:
;   * 0x84 in R25
;   * 0x00 in R24
;

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).



    .cseg
    .org 0

	; Some test cases below for you to try. And as usual
	; your solution is expected to work with values other
	; than those provided here.
	;
	; Your code will always be tested with legal BCD
	; values in r16 and r17 (i.e. no need for error checking).

	; 94 + 9 = 03, carry = 1
	;ldi r16, 0x01
	;ldi r17, 0x99

	; 86 + 79 = 65, carry = 1
	ldi r16, 0x00
	ldi r17, 0x00

	; 35 + 49 = 84, carry = 0
	;ldi r16, 0x35
	;ldi r17, 0x49

	; 32 + 41 = 73, carry = 0
	;ldi r16, 0x32
	;ldi r17, 0x41

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

MASKING: 

	ldi r21, 0x0A        ;loaded register to 10 
	ldi r20, 0b00001111  ;mask to isolate lower nibble
	ldi r30, 0b00010000  ;number to carry to upper nibble if we do a carry

	add r18, r16         ;moving r16 into r18 to work on it, without changing original 
	add r19, r17         ; ''

	and r19,r20          ;adding mask
	and r18,r20          ;adding mask

	add r19,r18          ;adding 2 lower nibbles

	cp r19, r21          ;comparing lower nibble to 10
	brge carry1          ;if sum is greater than 10, we branch to carry the 1 to upper nibble 

	jmp Uppernibble      ;if not, we jump over carry1 to the Uppernibble section

carry1:                  ;sends 10 to upper nibble
	add r16,  r30        
	sub r19, r21         ;subtracting 10 from lowernibble sum


uppernibble:              
	lsr r16              ;shifting both upper nibbles over 4, because I ran into an issue with registers restting to 0 when adding too large numbers
	lsr r16				 ;shifting over so it behaves like a lower nibble was easier to manage
	lsr r16
	lsr r16
	lsr r17
	lsr r17
	lsr r17
	lsr r17
	add r17,r16          ;adding upper nibbles together as lower nibbles
	cp r17, r21			 ;comparing sum to 10 to see if we must carry again	
	BRGE carry2          ;branching out to carry2 if over 10
	jmp finish           ;if not jumping to finish


carry2:                  ;if over 10 for upper nibble sum, adding it to r24 as "100"
	inc r24              ; adding 1 to r24
	sub r17, r21         ;subtracting the 10 from sum 

finish:
	lsl r17              ;shifting back to normal, since we wont be over 10 since we just subtracted it in carry2
	lsl r17 
	lsl r17
	lsl r17
	mov r25, r17         ;moving and adding proper registers for the proper format 
	add r25, r19



; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
bcd_addition_end:
	rjmp bcd_addition_end



; ==== END OF "DO NOT TOUCH" SECTION ==========

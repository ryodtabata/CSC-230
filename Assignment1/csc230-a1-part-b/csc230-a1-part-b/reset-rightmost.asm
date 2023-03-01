; reset-rightmost.asm
; CSC 230: Fall 2022
;
; Code provided for Assignment #1
;
; Mike Zastre (2022-Sept-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (b). In this and other
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
; Your task: You are to take the bit sequence stored in R16,
; and to reset the rightmost contiguous sequence of set
; by storing this new value in R25. For example, given
; the bit sequence 0b01011100, resetting the right-most
; contigous sequence of set bits will produce 0b01000000.
; As another example, given the bit sequence 0b10110110,
; the result will be 0b10110000.
;
; Your solution must work, of course, for bit sequences other
; than those provided in the example. (How does your
; algorithm handle a value with no set bits? with all set bits?)

; ANY SIGNIFICANT IDEAS YOU FIND ON THE WEB THAT HAVE HELPED
; YOU DEVELOP YOUR SOLUTION MUST BE CITED AS A COMMENT (THAT
; IS, WHAT THE IDEA IS, PLUS THE URL).

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========

ldi R16, 0b10001100
	; ldi R16, 0b10110110


	; THE RESULT **MUST** END UP IN R25

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

ldi r17, 0b00000001 ;mask to isolate bit 0
ldi r24, 0          ;register holding 0 to use for conditions


loop1:
	mov r18, r16    ;moving our original byte into a new register to work with, R18 holds our bit
	and r18, r17    ;adding our byte to a mask bit to compare
	cp  r17, r18	;comparing mask to masked byte
	brne shiftleft  ;if not equal, ie. there's not a one in the original byte, branch to shiftleft loop
	mov r18, r16    ;if past this spot, we know where the first 1 is, and can change byte original back to normal
	mov r19, r17    ;r19 now becomes our new mask, which we will add upcoming ones to if needed
	lsl r17         ;shifting ourmask over one bit to compare in next loop
	jmp equal       ;go to next part of function

shiftleft:          ;lsl our mask  
lsl r17
jmp loop1           ;back to original loop


equal:  
mov r18,r16         ;now we have our first 1, this part of code finds the following 1's      
and r18, r17        ;adding mask to original byte
cp r18, r24         ;comparing our masked byte to 0, incase we are at the end of the loop
breq finish         ;exit if only 0s left
cp r18, r17         ;compare masked bit to to mask
breq addingtomask   ;if both ones, then brramch to add that 1 to the new mask 
jmp finish          ;if not, then finished loop and exit


addingtomask:       ;entering this loop if we found a bit and need to add it to overall mask
add r19,r17         ;adding newly found bit to our overall mask
lsl r17             ;shifting mask over 1 to find next 1
jmp equal           ;jumping back into funtion
 
finish:             
mov r25,r16         ;move original byte into answer register 
eor r25, r19        ;adding mask using exclusive or to cancel out all the 1's




; **** END OF "STUDENT CODE" SECTION ********** 



; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
reset_rightmost_stop:
    rjmp reset_rightmost_stop


; ==== END OF "DO NOT TOUCH" SECTION ==========

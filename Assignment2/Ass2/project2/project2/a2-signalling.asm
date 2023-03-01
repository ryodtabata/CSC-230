; a2-signalling.asm
; CSC 230: Fall 2022
;
; Student name:
; Student ID:
; Date of completed work:
;
; *******************************
; Code provided for Assignment #2
;
; Author: Mike Zastre (2022-Oct-15)
;
 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are "DO
; NOT TOUCH" sections. You are *not* to modify the lines within these
; sections. The only exceptions are for specific changes changes
; announced on Brightspace or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****

.include "m2560def.inc"
.cseg
.org 0

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION ****
; ***************************************************

	; initializion code will need to appear in this
    ; section

	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	LDI R17,HIGH(RAMEND)
	OUT SPH,R17

	ldi r18, 0xFF
	sts DDRL, r18
	out DDRB, r18
	
	
; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION **********
; ***************************************************

; ---------------------------------------------------
; ---- TESTING SECTIONS OF THE CODE -----------------
; ---- TO BE USED AS FUNCTIONS ARE COMPLETED. -------
; ---------------------------------------------------
; ---- YOU CAN SELECT WHICH TEST IS INVOKED ---------
; ---- BY MODIFY THE rjmp INSTRUCTION BELOW. --------
; -----------------------------------------------------

	rjmp test_part_e
	; Test code


test_part_a:
	ldi r16, 0b11111111
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00111000
	rcall set_leds
	rcall delay_short

	clr r16
	rcall set_leds
	rcall delay_long

	ldi r16, 0b00100001
	rcall set_leds
	rcall delay_long

	clr r16
	rcall set_leds

	rjmp end


test_part_b:
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds
	ldi r17, 0b00101010
	rcall slow_leds
	ldi r17, 0b00010101
	rcall slow_leds

	rcall delay_long
	rcall delay_long

	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds
	ldi r17, 0b00101010
	rcall fast_leds
	ldi r17, 0b00010101
	rcall fast_leds

	rjmp end

test_part_c:
	ldi r16, 0b11111000
	push r16
	rcall leds_with_speed
	pop r16

	ldi r16, 0b11011100
	push r16
	rcall leds_with_speed
	pop r16

	ldi r20, 0b00100000
test_part_c_loop:
	push r20
	rcall leds_with_speed
	pop r20
	lsr r20
	brne test_part_c_loop

	rjmp end


test_part_d:
	ldi r21, 'Q'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'U'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long


	ldi r21, 'I'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	ldi r21, 'C'
	push r21
	rcall encode_letter
	pop r21
	push r25
	rcall leds_with_speed
	pop r25

	rcall delay_long

	rjmp end


test_part_e:
	ldi r25, HIGH(WORD02 << 1)
	ldi r24, LOW(WORD02<< 1)
	rcall display_message
	call delay_long
	ldi r25, HIGH(WORD02 << 1)
	ldi r24, LOW(WORD02<< 1)
	rcall display_message
	rjmp end

end:
    rjmp end



; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION ****
; ****************************************************

set_leds:

    push r17              ;pushing all values onto stack to not lose values 
	push r18
	push r19
	push r20
	push r21
	push r22
	push r23
	push r24

    ldi r17, 0 ;for PORTB
	ldi r18, 0 ;for PORTL
	ldi r19, 0b00000010 ;rightmost 
	ldi r20, 0b00001000 ;PORT Bs
	ldi r21, 0b00000010
	ldi r22, 0b00001000
	ldi r23, 0b00100000
	ldi r24, 0b10000000 ;leftmost
	
	sbrc r16, 5             ;going through bit by bit seeing it bit is set, and adding to mask if needed
		add r17, r19
	sbrc r16, 4
		add r17, r20
	sbrc r16, 3
		add r18, r21
	sbrc r16, 2
		add r18, r22
	sbrc r16, 1
		add r18, r23
	sbrc r16, 0
		add r18, r24
	  
	out PORTB, r17
	sts PORTL, r18
	 
	pop r24                    ;returning all values
	pop r23
	pop r22
	pop r21
	pop r20
	pop r19
	pop r18
	pop r17

	ret


slow_leds:
    
	push r16
	push r17

	mov r16, r17              ;moving value of r16 into r17 so function works correctly 
	call set_leds
	call delay_long
	ldi r16, 0
	call set_leds
	
	pop r17                   ;return all values
	pop r16

	ret


fast_leds:
   
    push r16                         ;push values
	push r17

	mov r16, r17 
	call set_leds
	call delay_short
	ldi r16,0
	call set_leds 
	
	pop r17
	pop r16
	
	ret 

leds_with_speed:
    
	push r16
	push r17
	push YL
	push YH
	push r19
	
	in YL, spl    ;using stack pointer
	in YH, sph


	ldd r18, Y+9 ;adding 9 to stack pointer to retrive value push on r18
	mov r17, r18
	mov r16, r18
	
	ldi r19, 0b11000000
    
	and r19, r18    ;add mask 

	cpi r19, 0b11000000   ;compare to see if they are equal
 	breq slow
	
	call fast_leds
	jmp end2

	slow:
	  call slow_leds
	  rjmp end2
	
	end2:
	pop r19
	pop YH
	pop YL
	pop r17
	pop r16
	
	ret


; Note -- this function will only ever be tested
; with upper-case letters, but it is a good idea
; to anticipate some errors when programming (i.e. by
; accidentally putting in lower-case letters). Therefore
; the loop does explicitly check if the hyphen/dash occurs,
; in which case it terminates with a code not found
; for any legal letter.

encode_letter:
    push ZH
	push ZL
	push r18    ;regsiter holding value of point stack
	push r16    ;register holding PATTERN Letter
    push YL
	push YH 
	push r17
	
	in YL, spl    ;using stack pointer
	in YH, sph

	ldd r18, Y+11 ;adding 11 to stack pointer to retrive value push on r18
    ldi r25, 0b00000000
	ldi ZH, high(PATTERNS<< 1)
	ldi ZL, low(PATTERNS<<1)

	lpm r16, Z
	
	initial_check:
	    cpi r16, 0x2D
		breq end3
		cp r18, r16           ;compare our given letter to letter in messages
		breq loop_letters     ;if letter is correct branch to go through the characters 
		adiw Z, 8
		lpm r16, Z
		rjmp initial_check    ;loop again with next letter

	loop_letters:             ;go through each letter to decode 
		lpm r16, Z+1
	    cpi r16, 1
		breq one_second
		cpi r16, 2
		breq quater_second     ; . = 0x2E
		cpi r16, 0x2E          ; o = 0x6F
		breq period            ;if we find a period
		cpi r16, 0x6F          ;if we find an o
		breq lowercase_o
		rjmp loop_letters

	one_second:
	    lsr r25
	    ori r25, 0b11000000    ;add mask if it needs one second 
		jmp end3
	
	quater_second:
	    lsr r25                ;add nothing if it does not need one second delay
		rjmp end3

	period:
		 lsl r25               ;shift once over if it does not need a 1
		 rjmp loop_letters
    
	lowercase_o:               ;inc 1 then shift over 
	     inc r25
		 lsl r25
		 rjmp loop_letters

end3:
    pop r17
    pop YH
	pop YL
	pop r16
	pop r18
	pop ZL
	pop ZH
ret



display_message:

    mov ZL, r24
	mov ZH, r25
	lpm r22, Z         ;move word value into r22 

	through_letters:   ;go through each letter
	    cpi r22, 0     ;if we hit a 0 we end
		breq end4
		push r22       
        rcall encode_letter
	    pop r22
	    push r25
	    rcall leds_with_speed     ;call led function
	    pop r25
	    rcall delay_short         ;delay bettween letters  
		rcall delay_short
		adiw Z, 1                 ;next letter
		lpm r22, Z
		rjmp through_letters      ;loop back in 

end4:
	ret


; ****************************************************
; **** END OF SECOND "STUDENT CODE" SECTION **********
; ****************************************************


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

; about one second
delay_long:
	push r16
	ldi r16, 14
delay_long_loop:
	rcall delay
	dec r16
	brne delay_long_loop

	pop r16
	ret


; about 0.25 of a second
delay_short:
	push r16

	ldi r16, 4
delay_short_loop:
	rcall delay
	dec r16
	brne delay_short_loop

	pop r16
	ret

; When wanting about a 1/5th of a second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code. Really this is
; nothing other than a specially-tuned triply-nested
; loop. It provides the delay it does by virtue of
; running on a mega2560 processor.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit

	ldi r17, 0xff
delay_busywait_loop2:
	dec r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret


; Some tables
.cseg
.org 0x600

PATTERNS:
	; LED pattern shown from left to right: "." means off, "o" means
    ; on, 1 means long/slow, while 2 means short/fast.
	.db "A", "..oo..", 1
	.db "B", ".o..o.", 2
	.db "C", "o.o...", 1
	.db "D", ".....o", 1
	.db "E", "oooooo", 1
	.db "F", ".oooo.", 2
	.db "G", "oo..oo", 2
	.db "H", "..oo..", 2
	.db "I", ".o..o.", 1
	.db "J", ".....o", 2
	.db "K", "....oo", 2
	.db "L", "o.o.o.", 1
	.db "M", "oooooo", 2
	.db "N", "oo....", 1
	.db "O", ".oooo.", 1
	.db "P", "o.oo.o", 1
	.db "Q", "o.oo.o", 2
	.db "R", "oo..oo", 1
	.db "S", "....oo", 1
	.db "T", "..oo..", 1
	.db "U", "o.....", 1
	.db "V", "o.o.o.", 2
	.db "W", "o.o...", 2
	.db "W", "oo....", 2
	.db "Y", "..oo..", 2
	.db "Z", "o.....", 2
	.db "-", "o...oo", 1   ; Just in case!

WORD00: .db "HELLOWORLD", 0, 0
WORD01: .db "THE", 0
WORD02: .db "QUICK", 0
WORD03: .db "BROWN", 0
WORD04: .db "FOX", 0
WORD05: .db "JUMPED", 0, 0
WORD06: .db "OVER", 0, 0
WORD07: .db "THE", 0
WORD08: .db "LAZY", 0, 0
WORD09: .db "DOG", 0

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================


/*
 * led.asm
 *
 *  Created: 9/27/2022 12:49:22 PM
 *   Author: ryotabata
 */ 
 .cseg 
 .org 0 
	ldi r16, 0xFF
	sts DDRL, r16
	out DDRB, r16
	

	ldi r16, 0b10000000
	sts PORTL, r16
	ldi r16, 0b00000010
	out PORTB, r16

done: jmp done
LCDInit	macro

;for 0 index
DigitPatternsLowIndex0
		addwf   PCL, F
		retlw	b'00001000' ;0
		retlw	b'00001000' ;1
		retlw	b'00000000' ;2
;for 1 index
DigitPatternsLowIndex1
		addwf   PCL, F
		retlw	b'00000111' ;0
		retlw	b'00000110' ;1
		retlw	b'00000011' ;2
		retlw	b'00000111' ;3
		retlw	b'00000110' ;4
		retlw	b'00000101' ;5
		retlw	b'00000101' ;6	
		retlw	b'00000111' ;7
		retlw	b'00000111' ;8
		retlw	b'00000111' ;9
;for 2 index
DigitPatternsLowIndex2
		addwf   PCL, F
		retlw	b'00010111' ;0
		retlw	b'00010100' ;1
		retlw	b'00000110' ;2
		retlw	b'00010110' ;3
		retlw	b'00010101' ;4
		retlw	b'00010011' ;5
;for 3 index
DigitPatternsLowIndex3
		addwf   PCL, F
		retlw	b'00011101' ;0
		retlw	b'00011000' ;1
		retlw	b'00001100' ;2
		retlw	b'00011100' ;3
		retlw	b'00011001' ;4
		retlw	b'00010101' ;5
		retlw	b'00010101' ;6
		retlw	b'00011100' ;7
		retlw	b'00011101' ;8
		retlw	b'00011101' ;9
;for 0 index
DigitPatternsHighIndex0
		addwf   PCL, F
		retlw	b'01110110' ;0
		retlw	b'01000000' ;1
		retlw	b'01101110' ;2
;for 1 index
DigitPatternsHighIndex1
		addwf   PCL, F
		retlw	b'10110000' ;0
		retlw	b'00000000' ;1
		retlw	b'01110000' ;2
		retlw	b'01010000' ;3
		retlw	b'11000000' ;4
		retlw	b'11010000' ;5
		retlw	b'11110000' ;6
		retlw	b'00000000' ;7
		retlw	b'11110000' ;8
		retlw	b'11010000' ;9

;for 2 index
DigitPatternsHighIndex2
		addwf   PCL, F
		retlw	b'01010000' ;0
		retlw	b'00000000' ;1
		retlw	b'11010000' ;2
		retlw	b'10010000' ;3
		retlw	b'10000000' ;4
		retlw	b'10010000' ;5
;for 3 index
DigitPatternsHighIndex3
		addwf   PCL, F
		retlw	b'01100000' ;0
		retlw	b'00000000' ;1
		retlw	b'11100000' ;2
		retlw	b'10100000' ;3
		retlw	b'10000000' ;4
		retlw	b'10100000' ;5
		retlw	b'11100000' ;6
		retlw	b'00000000' ;7
		retlw	b'11100000' ;8
		retlw	b'10100000' ;9

SetDigit
    	movf	DIGIT_INDEX,	W
    	addwf   PCL, F
    	goto	SetDigit0
    	goto	SetDigit1
    	goto	SetDigit2
    	goto	SetDigit3

SetDigit0
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsLowIndex0
    	iorwf   RGL4, F
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsHighIndex0
    	iorwf   RGL5, F  
    	return
  
SetDigit1
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsLowIndex1
    	iorwf   RGL3, F
    	movf    DIGIT_VALUE, W
   		call    DigitPatternsHighIndex1
    	iorwf   RGL4, F  
    	return
  
SetDigit2
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsLowIndex2
    	iorwf   RGL1, F
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsHighIndex2
    	iorwf   RGL2, F  
    	return
  
SetDigit3
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsLowIndex3
    	iorwf   RGL0, F
    	movf    DIGIT_VALUE, W
    	call    DigitPatternsHighIndex3
    	iorwf   RGL1, F  
    	return

ClearDisplay
	 	call    LCDClearReg
	 	movlw   .48
	 	movwf   Counter
	    bcf	    PORTA,Clock_line	;0
	    bcf	    PORTA,LCD_line
loop_counter2
	    bcf	    PORTA,Data_line
	    bsf	    PORTA,Clock_line	;1
	    nop
	    bcf	    PORTA,Clock_line	;0
	    decfsz  Counter, F
	    goto    loop_counter2
	    bcf	    PORTA,Data_line
	    bsf	    PORTA,Clock_line	;1
	    nop
	    bcf	    PORTA,Clock_line	;0
	    bsf	    PORTA,LCD_line
	    nop
	    bcf	    PORTA,LCD_line
	    return
	    
LCDClearReg 
	    clrf    RGL0
	    clrf    RGL1
	    clrf    RGL2
	    clrf    RGL3
	    clrf    RGL4
	    clrf    RGL5
	    return
	    

Showdisplay
	    bcf	    STATUS,C
	    clrf    TEMP
	    bcf	    PORTA,Clock_line
	    bcf	    PORTA,LCD_line
	    movf    RGL0, W
	    movwf   TEMP          
	    call    LCDloopReg
	    movf    RGL1, W
	    movwf   TEMP
	    call    LCDloopReg
	    movf    RGL2, W
	    movwf   TEMP
	    call    LCDloopReg
	    movf    RGL3, W
	    movwf   TEMP
	    call    LCDloopReg
	    movf    RGL4, W
	    movwf   TEMP
	    call    LCDloopReg
	    movf    RGL5, W
	    movwf   TEMP
	    call    LCDloopReg
	    bcf	    PORTA,Data_line
	    bsf	    PORTA,Clock_line	;1
	    nop
	    nop
	    bcf	    PORTA,Clock_line	;0
	    bsf	    PORTA,LCD_line
	    nop
	    bcf	    PORTA,LCD_line
	    return

LCDloopReg
	    movlw   .8
	    movwf   COUNT
	    bcf	    STATUS,C
TMPloop1    
	    rlf	    TEMP,F
	    bcf	    PORTA,Data_line
	    btfsc   STATUS,C	;proverka flaga perenoca
	    bsf	    PORTA,Data_line
	    bsf	    PORTA,Clock_line	;1
	    nop
	    bcf	    PORTA,Clock_line	;0
	    decfsz  COUNT,F
	    goto    TMPloop1
	    return

		endm
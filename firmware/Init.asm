;INIT block begin\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	
Init macro
	clrf	ANSELA	    ;off analog
	clrf	LATA	    
	clrf	TRISA	    ;on output
	clrf	PORTA
	movlw	b'01010000' ;4MHz
	;movlw	b'00110000' ;1MHz
	;movlw	b'01000000' ;2MHz
	movwf	OSCCON
	movlw	0x06
	movwf	FSR
clearloop
	clrf	INDF
	incf	FSR,F
	movf	FSR,W
	sublw	0x7F
	btfss	STATUS,Z
	goto	clearloop
	goto	Main
	endm
	
;INIT block end\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
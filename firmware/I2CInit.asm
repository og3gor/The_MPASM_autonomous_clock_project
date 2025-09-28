I2CInit	macro

Init_I2C
	bsf	TRISA, Clock_line
	bsf	TRISA, Data_line
	return
	
UnInit_I2C
	bcf	TRISA, Clock_line
	bcf	TRISA, Data_line
	return

Clock_null
	bcf	PORTA, Clock_line
	bcf	TRISA, Clock_line
	return
	
Clock_one
	bsf	TRISA, Clock_line
	return

Data_null
	bcf	PORTA, Data_line
	bcf	TRISA, Data_line
	return
	
Data_one
	bsf	TRISA, Data_line
	return

Start_uslovie
	call	Data_one ;na vsaki slychai
	call	Clock_one
	call	Data_null
	call	Clock_null
	return
	
Stop_uslovie
	call	Data_null
	call	Clock_one
wait_clock_p
	btfss	PORTA,Clock_line
	goto	wait_clock_p
	call	Data_one
	return
	
Send_Byte
	bcf	I2C_flags,0
	movlw	.8
	movwf	Bit_counter
next_bit_s
	btfsc	BTS,7
	call	Data_one
	btfss	BTS,7
	call	Data_null
	call	Clock_one
wait_clock_s1
	btfss	PORTA,Clock_line
	goto	wait_clock_s1
	call	Clock_null
	rlf	BTS,1
	decfsz	Bit_counter,1
	goto	next_bit_s
	call	Data_one
	call	Clock_one
wait_clock_s2
	btfss	PORTA,Clock_line
	goto	wait_clock_s2
	btfsc	PORTA,Data_line
	bsf	I2C_flags,0
	call	Clock_null
	return
	
Recieve_Byte
	clrf	RDB
	movlw	.8
	movwf	Bit_counter
next_bit_r
	bcf	STATUS,0
	rlf	RDB,1
	call	Data_one
	call	Clock_line
wait_clock_r1
	btfss	PORTA,Clock_line
	goto	wait_clock_r1
	btfsc	PORTA,Data_line
	bsf	RDB,0
	call	Clock_null
	decfsz	Bit_counter
	call	next_bit_r
	btfsc	I2C_flags,0
	call	Data_one
	call	Clock_one
wait_clock_r2
	btfss	PORTA,Clock_line
	goto	wait_clock_r2
	call	Clock_null
	return

	endm
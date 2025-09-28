#include "p10f322.inc"
#include "Init.asm"
#include "LCD.asm"
#include "I2CInit.asm"
	    
    
	     		LIST P=10F322
	    		__CONFIG _FOSC_INTOSC & _BOREN_ON & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _LVP_OFF & _LPBOR_ON & _BORV_LO & _WRT_OFF
	    
STATUS	    	EQU	    03h
PORTA	    	EQU	    05h
TRISA	    	EQU	    06h
	    

Clock_line  	EQU	    1
Data_line   	EQU	    0
LCD_line    	EQU	    2
Button_line 	EQU	    3

;I2C Reg
BTS	    		EQU	    40h
RDB	    		EQU	    41h
Bit_counter 	EQU	    42h
I2C_flags   	EQU	    43h

;Pause Reg
Reg_1	    	EQU	    44h
Reg_2	    	EQU	    45h
Reg_3	    	EQU	    46h
	    
;LCD Reg
Counter	    	EQU	    47h
RGL0	    	EQU	    48h
RGL1	    	EQU	    49h
RGL2	    	EQU	    4Ah
RGL3	    	EQU	    4Bh
RGL4	    	EQU	    4Ch
RGL5	    	EQU	    4Dh
TEMP	    	EQU	    4Eh
COUNT	    	EQU	    4Fh
  
DIGIT_INDEX 	EQU	    50h
DIGIT_VALUE 	EQU	    51h
HOUR_TENS   	EQU	    52h
HOUR_UNITS  	EQU	    53h
MINUTE_TENS 	EQU	    54h
MINUTE_UNITS 	EQU    55h
 
;DS1338 Reg
TempSeconds 	EQU	    56h
Seconds	    	EQU	    57h
Minutes	    	EQU	    58h
Hours	    	EQU	    59h
	    
	    	    
	    
Start			org	0
	
				Init
				I2CInit
				LCDInit
	
Main
				;proverka peredachi
    			;call    Init_I2C
    			;call    Start_uslovie
   				;call    MegaPause
    			;movlw   .25
    			;movwf   BTS
    			;call    Start_uslovie
    			;call    Send_Byte
    			;movlw   .55
    			;movwf   BTS
    			;call    Send_Byte
    			;call    Stop_uslovie
 
    			;call    Set_DS1338_Time
    			;call    Pause
    			;call    Read_DS1338_Time
   				;call    UnInit_I2C
    
    			;call    Pause   

				;loop time on display
    			call    LCDClearReg
    			goto	LOOP_TIME

				goto	Main
	

;delay = 500 machine cycles
Pause       	movlw       .166
            	movwf       Reg_1
wr          	decfsz      Reg_1, F
            	goto        wr
            	nop
	    		return


MegaPause
	    		call    Pause
	    		call    Pause
	    		return
            	    
MicroPause
	    		nop
	    		nop
	    		nop
	    		nop
	    		return
	    


;DS1338	block begin\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	
Set_DS1338_Time
    			call    Start_uslovie
    
    			movlw   0xD0
    			movwf   BTS
    			call    Send_Byte
    
   				movlw   0x00
    			movwf   BTS
    			call    Send_Byte
    
    			call    Stop_uslovie
    
    			call    Start_uslovie
    			movlw   0xD1
    			movwf   BTS
    			call    Send_Byte
    			call    Recieve_Byte
    			movf    RDB, W
    			movwf   TempSeconds
    
    			call    Stop_uslovie
    
    			bcf     TempSeconds, 7
    
    			call    Start_uslovie
    			movlw   0xD0
    			movwf   BTS
    			call    Send_Byte
    
    			movlw   0x00
    			movwf   BTS
    			call    Send_Byte
    
    			movf    TempSeconds, W
    			movwf   BTS
    			call    Send_Byte
    
    			movlw   0x30
    			movwf   BTS
    			call    Send_Byte
    
    			movlw   0x12
    			movwf   BTS
    			call    Send_Byte
    
    			call    Stop_uslovie
    			return

Read_DS1338_Time
    			call    Start_uslovie
    
    			movlw   0xD0
    			movwf   BTS
    			call    Send_Byte
    
    			movlw   0x00
    			movwf   BTS
    			call    Send_Byte
    
    			call    Stop_uslovie
    
    			call    Start_uslovie
    
    			movlw   0xD1
    			movwf   BTS
    			call    Send_Byte
    
    			call    Recieve_Byte
    			movwf   Seconds
    
    			call    Recieve_Byte
    			movwf   Minutes
    
    			call    Recieve_Byte
    			movwf   Hours
    
    			call    Stop_uslovie
    			return
    
;DS1338 block end\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	

;Display Hours and Minutes
DISPLAY_TIME
;Display Hour Tens
    			movf    HOUR_TENS, W
    			movwf   DIGIT_VALUE
    			movlw   .0
    			movwf   DIGIT_INDEX
    			call    SetDigit

;Display Hour Units
    			movf    HOUR_UNITS, W
    			movwf   DIGIT_VALUE
    			movlw   .1
    			movwf   DIGIT_INDEX
    			call    SetDigit

;Display Minute Tens
    			movf    MINUTE_TENS, W
    			movwf   DIGIT_VALUE
    			movlw   .2
    			movwf   DIGIT_INDEX
    			call    SetDigit

;Display Minute Units
    			movf    MINUTE_UNITS, W
   				movwf   DIGIT_VALUE
    			movlw   .3
    			movwf   DIGIT_INDEX
    			call    SetDigit

;Show the current time on display
    			call    Showdisplay
    			call    LCDClearReg
				call	Check_Time
				goto	LOOP_TIME ;For LOOP, no exit
;return

LOOP_TIME
;Increment Time
				call	MegaPause
    			incf    MINUTE_UNITS, F
    			movlw   .10
    			subwf   MINUTE_UNITS, W
    			btfss   STATUS, Z
    			goto    DISPLAY_TIME

    			clrf    MINUTE_UNITS
    			incf    MINUTE_TENS, F

    			movlw   .6
    			subwf   MINUTE_TENS, W
    			btfss   STATUS, Z
    			goto    DISPLAY_TIME

    			clrf    MINUTE_TENS
    			incf    HOUR_UNITS, F

    			movlw   .10
    			subwf   HOUR_UNITS, W
    			btfss   STATUS, Z
    			goto    DISPLAY_TIME

    			clrf    HOUR_UNITS
    			incf    HOUR_TENS, F

    			movlw   .2
    			subwf   HOUR_TENS, W
    			btfss   STATUS, Z
    			goto    DISPLAY_TIME

;Check if time reached 23:59
Check_Time
				movf    HOUR_TENS, W
				xorlw   .2
				btfss   STATUS, Z
				goto    LOOP_TIME

				movf    HOUR_UNITS, W
				xorlw   .3
				btfss   STATUS, Z
				goto    LOOP_TIME

				movf    MINUTE_TENS, W
				xorlw   .5
				btfss   STATUS, Z
				goto    LOOP_TIME

				movf    MINUTE_UNITS, W
				xorlw   .9
				btfss   STATUS, Z
				return
;Time reached 23:59, exit
				clrf    HOUR_TENS
				clrf    HOUR_UNITS
				clrf	MINUTE_TENS
				clrf	MINUTE_UNITS
				call	ClearDisplay
				call    LCDClearReg
				return
    
				end

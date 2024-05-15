    
LIST  P=PIC16F877
include P16f877.inc
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
org 0x00
reset goto start

       org 0x10
start: bcf STATUS, RP0
      bcf STATUS, RP1   ; Bank 0
      clrf PORTD
      clrf PORTE

      bsf STATUS, RP0   ; Bank 1
      movlw 0x06
      movwf ADCON1
      clrf TRISE         ; porte output 
      clrf TRISD         ; portd output
      ;=====    
      bcf INTCON, GIE   ; No interrupt
      movlw 0x0F
      movwf TRISB
      bcf OPTION_REG, 0x7 ; Enable PortB Pull-Up
      clrf TRISD

      bcf STATUS, RP0   ; Bank0
      clrf PORTD
      clrf 0x30
      clrf 0x40
      clrf 0x50
      call init
      clrf 0x60
goto enterA
;===================================================
enterA: movlw 0x80
       movwf 0x20
       call lcdc
       call mdel

       call wkb 
       addlw 0x37
       movwf 0x20
       call lcdd
       call mdel

       call wkb
       movwf 0x31
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x31,0
       call add1A
       call mdel
 
       call wkb 
       movwf 0x32
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x32,0
       call add2A
       call mdel

       call wkb 
       movwf 0x33
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x33,0
       call add3A
       call mdel
 
       call wkb 
       movwf 0x34
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x34,0
       call add4A
       call mdel
 
       movf 0x30,W
       addlw 0x30
       movwf 0x20
       call lcdd
       call mdel
       call mdel
       call mdel
       call BeginToClearFirstLine
       goto enterB
;===================================================
add1A: movlw 0x08
      addwf 0x30
      return
add2A: movlw 0x04
      addwf 0x30
      return
add3A: movlw 0x02
      addwf 0x30 
      return
add4A: movlw 0x01
      addwf 0x30 
      return
;===================================================
enterB: movlw 0x80
       movwf 0x20
       call lcdc
       call mdel

       call wkb 
       addlw 0x37
       movwf 0x20
       call lcdd
       call mdel

       call wkb
       movwf 0x41
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x41,0
       
call add1B
       call mdel
 
       call wkb 
       movwf 0x42
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x42,0
       call add2B
       call mdel

       call wkb 
       movwf 0x43
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x43,0
       call add3B 
       call mdel;----

       call wkb 
       movwf 0x44
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x44,0
       call add4B 
       call mdel;----

       movf 0x40,W
       addlw 0x30
       movwf 0x20
       call lcdd
       call mdel
       call mdel
       call mdel
       call BeginToClearFirstLine
       goto enterC
       
;===================================================
add1B: movlw 0x08
      addwf 0x40
      return
add2B: movlw 0x04
      addwf 0x40
      return
add3B: movlw 0x02
      addwf 0x40
       return
add4B: movlw 0x01
      addwf 0x40
       return
;===================================================
enterC: movlw 0x80
       movwf 0x20
       call lcdc
       call mdel

       call wkb 
       addlw 0x37
       movwf 0x20
       call lcdd
       call mdel

       call wkb
       movwf 0x51
       addlw 0x30
       movwf 0x20
       call lcdd 
       btfsc 0x51,0
       call add1C
       call mdel
 
       call wkb 
       movwf 0x52
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x52,0
       call add2C
       call mdel

       call wkb 
       movwf 0x53
       addlw 0x30
       movwf 0x20
       call lcdd
       btfsc 0x53,0
       call add3C 
       call mdel;---
       movf 0x40,W
       addlw 0x30
       movwf 0x20
       call lcdd
       call mdel
       call mdel
       call mdel
       call BeginToClearFirstLine
       goto TOE
      
;===================================================
add1C: movlw 0x04
      addwf 0x50
      return
add2C: movlw 0x02
      addwf 0x50
       return
add3C: movlw 0x01
      addwf 0x50
       return
;====================================================

TOE: movlw 0x01
     subwf 0x50,W
     btfsc STATUS,Z
     goto SUB

     movlw 0x02
     subwf 0x50,W
     btfsc STATUS,Z
     goto MULT
     
     movlw 0x03
     subwf 0x50,W
     btfsc STATUS,Z
     ;goto  DIV
 
     movlw 0x04
     subwf 0x50,W
     btfsc STATUS,Z
     ;goto POW
 
     movlw 0x05
     subwf 0x50,W
     btfsc STATUS,Z
     goto Dig1B
 
     movlw 0x06
     subwf 0x50,W
     btfsc STATUS,Z
     ;goto Dig0A
     ;call printERROR
;====================================================
SUB: movf 0x30,W
     subwf 0x40,W
     btfss STATUS,Z 
     movwf 0x60
     
     movlw 0xc0
     movwf 0x20
     call lcdc
     call mdel
     
     movf 0x60,W
     addlw 0x30
     movwf 0x20
     call  lcdd 
     call mdel
     SLEEP
;----------------------------------------------------
MULT: clrf 0x60
      movf 0x40,W
      movwf 0x70
      call MULLOOP
      SLEEP

MULLOOP: movf 0x30,W
         addwf 0x30
         movwf 0x60
         decf 0x70,f
         movf 0x70,W
         sublw 0x00
         btfss STATUS,C
         goto MULLOOP

         movlw 0xC0
         movwf 0x20
         call lcdc
         call mdel
     
         
         movf 0x60,W
         addlw 0x30
         movwf 0x20
         call  lcdd 
         call mdel
         return
;----------------------------------------------------
DIV:  clrf 0x71
      movf 0x30,W
      movwf 0x70
      call DIVLOOP
      SLEEP

DIVLOOP: movf 0x40,W
         subwf 0x70
         movwf 0x60
         incf 0x71
         movf 0x70,W
         subwf 0x30
         btfss STATUS,C
         goto DIVLOOP

         movlw 0xC0
         movwf 0x20
         call lcdc
         call mdel
     
         
         movf 0x71,W
         addlw 0x30
         movwf 0x20
         call  lcdd 
         call mdel
         return
;====================================================
Dig1B: movlw 0x00
       movwf 0x78
       movlw 0x01
       subwf 0x41,W
       btfss STATUS,Z
       incf 0x78,F

       subwf 0x42,W
       btfss STATUS,Z
       incf 0x78,F
 
       subwf 0x43,W
       btfss STATUS,Z
       incf 0x78,F
 
       subwf 0x44,W
       btfss STATUS,Z
       incf 0x78,F
       
       movlw 0xC0
       movwf 0x20
       call lcdc
       call mdel
     
         
       movf 0x78,W
       addlw 0x30
       movwf 0x20
       call  lcdd 
       call mdel
       return
;====================================================
del_41	movlw		0xcd
		movwf		0x23
lulaa6	movlw		0x20
		movwf		0x22
lulaa7	decfsz		0x22,1
		goto		lulaa7
		decfsz		0x23,1
		goto 		lulaa6 
		return


del_01	movlw		0x20
		movwf		0x22
lulaa8	decfsz		0x22,1
		goto		lulaa8
		return


sdel	movlw		0x19		; movlw = 1 cycle
		movwf		0x23		; movwf	= 1 cycle
lulaa2	movlw		0xfa
		movwf		0x22
lulaa1	decfsz		0x22,1		; decfsz= 12 cycle
		goto		lulaa1		; goto	= 2 cycles
		decfsz		0x23,1
		goto 		lulaa2 
		return


mdel	movlw		0x3a
		movwf		0x24
lulaa5	movlw		0x19
		movwf		0x23
lulaa4	movlw		0xfa
		movwf		0x22
lulaa3	decfsz		0x22,1
		goto		lulaa3
		decfsz		0x23,1
		goto 		lulaa4 
		decfsz		0x24,1
		goto		lulaa5
		return
;===================================================
wait goto wait

;
;subroutine to initialize LCD
;
init movlw 0x30
     movwf 0x20
     call lcdc
     call del_41

     movlw 0x30
     movwf 0x20
     call lcdc
     call del_01

     movlw 0x30
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x01         ; display clear
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x06         ; ID=1,S=0 increment,no shift 000001 ID S
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x0c         ; D=1,C=B=0 set display, no cursor, no blinking
     movwf 0x20
     call lcdc
     call mdel

     movlw 0x38         ; dl=1 ( 8 bits interface,n=12 lines,f=05x8 dots)
     movwf 0x20
     call lcdc
     call mdel
     return

;
;subroutine to write command to LCD
;

lcdc movlw 0x00        ; E=0,RS=0 
     movwf PORTE
     movf 0x20, w
     movwf PORTD
     movlw 0x01        ; E=1,RS=0
     movwf PORTE
     call sdel
     movlw 0x00        ; E=0,RS=0
     movwf PORTE
     return

;
;subroutine to write data to LCD
;

lcdd movlw 0x02        ; E=0, RS=1
     movwf PORTE
     movf 0x20, w
     movwf PORTD
     movlw 0x03        ; E=1, rs=1  
     movwf PORTE
     call sdel
     movlw 0x02        ; E=0, rs=1  
     movwf PORTE
     return
;===================================================
BeginToClearFirstLine: call mdel
Movlw 0x80
Movwf 0x20
Movwf 0x59
Call lcdc
call ClearNextBit1
return
ClearNextBit1: incf 0x59
Movlw 0x90
Subwf 0x59, W
Btfsc STATUS, Z
Return
movlw 0x20
movwf 0x20
Call lcdd
Goto ClearNextBit1

BeginToClearSecLine:   ;call mdel
Movlw 0xC0
Movwf 0x20
Movwf 0x58
Call lcdc
call ClearNextBit2
return

ClearNextBit2: incf 0x58
Movlw 0xD0
Subwf 0x58, W
Btfsc STATUS, Z
Return
movlw 0x20
movwf 0x20
Call lcdd
goto ClearNextBit2
;===================================================
wkb:    bcf             PORTB,0x4     ;Line 0 of Matrix is enabled
        bsf             PORTB,0x5
        bsf             PORTB,0x6
        bsf             PORTB,0x7
;-----------------------------------------------------------------------
        btfss           PORTB,0x0     ;Scan for 1,A
        goto            kb01
        btfss           PORTB,0x3
        goto            kb0a
;-----------------------------------------------------------------------
        bsf             PORTB,0x4	;Line 1 of Matrix is enabled
        bcf             PORTB,0x5
;-----------------------------------------------------------------------
        btfss           PORTB,0x3     ;Scan for B
        goto            kb0b
;-----------------------------------------------------------------------	
        bsf             PORTB,0x5	;Line 2 of Matrix is enabled
        bcf             PORTB,0x6
;-----------------------------------------------------------------------
        btfss           PORTB,0x3      ;Scan for C
        goto            kb0c
;-----------------------------------------------------------------------
        bsf             PORTB,0x6	;Line 3 of Matrix is enabled
        bcf             PORTB,0x7
;----------------------------------------------------------------------
        btfss           PORTB,0x1       ;Scan FOR 0
        goto            kb00
;----------------------------------------------------------------------
        goto            wkb

kb00:   movlw           0x00
        goto            disp	
kb01:   movlw           0x01
        goto            disp		
kb0a:   movlw           0x0a
        goto            disp	
kb0b:   movlw           0x0b
        goto            disp	
kb0c:   movlw           0x0c
        goto            disp		


disp:   return

	end

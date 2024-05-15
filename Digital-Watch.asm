LIST  P=PIC16F877
include P16f877.inc
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _HS_OSC & _WRT_ENABLE_ON & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

; LCD
;
    org 0x00
reset goto start

    org 0x10
start bcf STATUS, RP0
      bcf STATUS, RP1   ; Bank 0
      clrf PORTD
      clrf PORTE

      bsf STATUS, RP0   ; Bank 1
      movlw 0x06
      movwf ADCON1
      clrf TRISE         ; porte output 
      clrf TRISD         ; portd output

      bcf INTCON, GIE   ; No interrupt
      movlw 0x0F
      movwf TRISB
      bcf OPTION_REG, 0x7 ; Enable PortB Pull-Up
      clrf TRISD
      bcf STATUS, RP0   ; Bank0
      
      call init
      goto PrintClock
      
;---------------------------------------------------------------------------------------
PrintClock: movlw 0x84          
            movwf 0x20
            call lcdc
            call mdel

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw ':'
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

            movlw ':'
            movwf 0x20
            call lcdd
            call del_41

            movlw 0x30
          movwf 0x20
          call lcdd
          call del_41

          movlw 0x30
            movwf 0x20
            call lcdd
            call del_41

          movlw 0x84
          movwf 0x20
          call lcdc
          call mdel
          goto ScanClock
;---------------------------------------------------------------------------------------
  

;======================================================
del_41 movlw 0xff
        movwf 0x23
lulaa6 movlw 0xff
        movwf 0x22
lulaa7 decfsz 0x22, 1
        goto lulaa7
        decfsz 0x23, 1
        goto lulaa6 
        return

del_01 movlw 0x20
        movwf 0x22
lulaa8 decfsz 0x22, 1
        goto lulaa8
        return

sdel movlw 0x19         ; movlw = 1 cycle
     movwf 0x23         ; movwf = 1 cycle
lulaa2 movlw 0xfa
        movwf 0x22
lulaa1 decfsz 0x22, 1  ; decfsz = 12 cycles
        goto lulaa1     ; goto = 2 cycles
        decfsz 0x23, 1
        goto lulaa2 
        return

mdel movlw 0x05
     movwf 0x24
lulaa5 movlw 0xff
        movwf 0x23
lulaa4 movlw 0xff
        movwf 0x22
lulaa3 decfsz 0x22, 1
        goto lulaa3
        decfsz 0x23, 1
        goto lulaa4 
        decfsz 0x24, 1
        goto lulaa5
        return

;======================================================
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
;======================================================
      
ScanClock: call wkb
           movwf 0x70
           addlw 0x30; scan hours -0
           movwf 0x20
           call  lcdd
           call  mdel
         
           call wkb
           movwf 0x71
           addlw 0x30
           movwf 0x20;scan hours 0-
           call  lcdd
           call  mdel

           movlw 0x87
          movwf 0x20
          call lcdc
          call mdel

           call wkb
           movwf 0x60
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel

           call wkb
           movwf 0x61
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel

           movlw 0x8A
          movwf 0x20
          call lcdc
          call mdel

           call wkb
           movwf 0x50
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel

           call wkb
           movwf 0x51
           addlw 0x30
           movwf 0x20
           call  lcdd
           call  mdel
           goto  incfSec1
           
;-------------------------------------------------
incfSec1: incf 0x50
          movlw 0x8B
          movwf 0x20
          call  lcdc 
          call  mdel
          movf 0x50,W
           addlw 0x30
           movwf 0x20
           call lcdd
           call mdel
         movlw 0x39
         subwf 0x20,Z
         btfss STATUS,Z
         goto incfSec1
         goto incfSec2
         
incfSec2: clrf 0x50
incf 0x51
          movlw 0x8A
          movwf 0x20
          call  lcdc 
          call  mdel
          movf 0x51,W
           addlw 0x30
           movwf 0x20

           call lcdd
           clrf 0x20
           call lcdd
           call mdel
           movlw 0x36
         subwf 0x20,Z
         btfss STATUS,Z
         goto incfSec1 
         clrf 0x51
         movlw 0x00
          movwf 0x20
          call  lcdc 
          call  mdel
          
           addlw 0x00
           movwf 0x20
           call lcdd
           clrf 0x20
           call lcdd
           call mdel
         goto inf;min
         
         


         
;-------------------------
inf: clrf 0x36
     incf 0x36
     goto inf
;------------------------
delay:					
		movlw       0x03
        movwf       0x50

CONT1:	movlw       0xFF
        movwf       0x51

CONT2:	movlw		0xFF		
		movwf		0x52

CONT3:  decfsz      0x52,f
        goto        CONT3 
        decfsz      0x51,f
        goto        CONT2
        decfsz      0x50,f
        goto        CONT1
        return  
        ; delay of (255*255*3) * 2*3 * 1 = 1.1sec
        ;            for 255 to 0 ( for 255 to 0 ( for 3 to 0))) inside every loop there is 2 instructions so 2*3 * every instruction takes 1 microsec

;-------------------------------------------------

wkb: bcf PORTB, 0x4      ; scan Row 1
    bsf PORTB, 0x5
    bsf PORTB, 0x6
    bsf PORTB, 0x7
    btfss PORTB, 0x0
    goto kb01
    btfss PORTB, 0x1
    goto kb02
    btfss PORTB, 0x2
    goto kb03
    btfss PORTB, 0x3
    goto kb0a

    bsf PORTB, 0x4
    bcf PORTB, 0x5       ; scan Row 2
    btfss PORTB, 0x0
    goto kb04
    btfss PORTB, 0x1
    goto kb05
    btfss PORTB, 0x2
    goto kb06
    btfss PORTB, 0x3
    goto kb0b

    bsf PORTB, 0x5
    bcf PORTB, 0x6       ; scan Row 3
    btfss PORTB, 0x0
    goto kb07
    btfss PORTB, 0x1
    goto kb08
    btfss PORTB, 0x2
    goto kb09
    btfss PORTB, 0x3
    goto kb0c

    bsf PORTB, 0x6
    bcf PORTB, 0x7       ; scan Row 4
    btfss PORTB, 0x0
    goto kb0e
    btfss PORTB, 0x1
    goto kb00
    btfss PORTB, 0x2
    goto kb0f
    btfss PORTB, 0x3
    goto kb0d

    goto wkb

kb00 movlw 0x00
     goto disp
kb01 movlw 0x01
     goto disp
kb02 movlw 0x02
     goto disp
kb03 movlw 0x03
     goto disp
kb04 movlw 0x04
     goto disp
kb05 movlw 0x05
     goto disp
kb06 movlw 0x06
     goto disp
kb07 movlw 0x07
     goto disp
kb08 movlw 0x08
     goto disp
kb09 movlw 0x09
     goto disp
kb0a movlw 0x0A
     goto disp
kb0b movlw 0x0B
     goto disp
kb0c movlw 0x0C
     goto disp
kb0d movlw 0x0D
     goto disp
kb0e movlw 0x0E
     goto disp
kb0f movlw 0x0F
     goto disp

disp: return

end
           
           

 

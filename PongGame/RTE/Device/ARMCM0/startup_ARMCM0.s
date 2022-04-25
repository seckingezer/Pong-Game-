Stack_Size      EQU      0x00000400

                AREA     STACK, NOINIT, READWRITE, ALIGN=3
__stack_limit
Stack_Mem       SPACE    Stack_Size
__initial_sp
				AREA     RESET, DATA, READONLY
                EXPORT   __Vectors
                EXPORT   __Vectors_End
                EXPORT   __Vectors_Size


Heap_Size       EQU      0x00000C00

                IF       Heap_Size != 0                      ; Heap is provided
                AREA     HEAP, NOINIT, READWRITE, ALIGN=3
__heap_base
Heap_Mem        SPACE    Heap_Size
__heap_limit
                ENDIF


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA     RESET, DATA, READONLY
                EXPORT   __Vectors
                EXPORT   __Vectors_End
                EXPORT   __Vectors_Size

__Vectors       DCD      __initial_sp                        ;     Top of Stack
                DCD      Reset_Handler                       ;     Reset Handler
                DCD      NMI_Handler                         ; -14 NMI Handler
                DCD      HardFault_Handler                   ; -13 Hard Fault Handler
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      SVC_Handler                         ;  -5 SVCall Handler
                DCD      0                                   ;     Reserved
                DCD      0                                   ;     Reserved
                DCD      PendSV_Handler                      ;  -2 PendSV Handler
                DCD      SysTick_Handler                     ;  -1 SysTick Handler
                DCD      Button_Handler                      ;  
__Vectors_End
__Vectors_Size  EQU      __Vectors_End - __Vectors
				AREA     |.text|, CODE, READONLY



; Reset Handler

Reset_Handler   PROC
                EXPORT   Reset_Handler             [WEAK]
				IMPORT	 __main
				ldr		 r0,=0xE000E100	; Nested Interrupt Vector Address
				movs	 r1,#0x01		; Move r1 #0x01
				str		 r1,[r0]		; store it 
				CPSIE	 i
				ldr		 r0, =__main
				bx		 r0
                ENDP
	

; The default macro is not used for HardFault_Handler
; because this results in a poor debug illusion.
HardFault_Handler PROC
                EXPORT   HardFault_Handler         [WEAK]
                B        .
                ENDP

; Macro to define default exception/interrupt handlers.
; Default handler are weak symbols with an endless loop.
; They can be overwritten by real handlers.
                MACRO
                Set_Default_Handler  $Handler_Name
$Handler_Name   PROC
                EXPORT   $Handler_Name             [WEAK]
                B        .
                ENDP
                MEND


; Default exception/interrupt handler

                Set_Default_Handler  NMI_Handler
                Set_Default_Handler  SVC_Handler
                Set_Default_Handler  PendSV_Handler
                Set_Default_Handler  SysTick_Handler

				AREA	button, CODE, READONLY
Button_Handler PROC
                EXPORT         Button_Handler
				EXPORT		   _np
				IMPORT		   _GKRmovementup
				IMPORT		   _GKRmovementdown
				IMPORT		   _GKLmovementup
				IMPORT		   _GKLmovementdown
                ldr            r0,=0x40010000
                ldr            r1,[r0,#0x10]	; getting the value from button				
				movs		   r3,#0xFF			; moving 0xFF to r3 0xFF=> 11111111
				ands		   r1,r1,r3			; using and operator to get the value of button
				ldr			   r2,[r0]			; getting the last stored row position to r2
				ldr			   r3,[r0,#0x04]	; getting the last stored col position to r3
				ldr			   r0,=0x20000600	; this is address to store row and col position before interrupt functions happens
				str			   r2,[r0,#0x60]	; address for row	  			   
				str			   r3,[r0,#0x64]	; address for column
                cmp            r1,#0x00			; comparing if there is a button pressed
                beq            _nobutton		; if there isnt go _nobutton
				cmp			   r1,#0x04			; comparing if A button is pressed
				beq			   _nobutton		; if so go into _nobutton
				cmp			   r1,#0x08			; comparing if B button is pressed
				beq			   _nobutton		; if so go into _nobutton
                cmp            r1,#0x10			; comparing if up button is pressed
                beq            _rightup			; if so go into _rightup 
				cmp			   r1,#0x80			; comparing if right button is pressed
				beq			   _rightdown		; if so go into _rightdown 
				cmp 		   r1,#0x40			; comparing if left button is pressed
				beq			   _leftup			; if so go into _leftup
				cmp			   r1,#0x20			; comparing if down button is pressed
				beq			   _leftdown		; if so go into _leftdown
				bl			   _nobutton		; just go to _nobutton  (for protection) (not necessary line)
				
_rightup				
                ldr           r0,=_GKRmovementup ; get the address of _GKRmovementup
                bx            r0 
                bl            _np
_rightdown				
                ldr           r0,=_GKRmovementdown ; get the address of _GKRmovementdown
                bx            r0
                bl            _np
_leftup			
                ldr           r0,=_GKLmovementup ; get the address of _GKLmovementup
                bx            r0
                bl            _np
_leftdown				
                ldr           r0,=_GKLmovementdown	; get the address of _GKLmovementdown
                bx            r0
                bl            _np
_nobutton        
				ldr			   r0,=0x40010000 
                movs           r1,#0x00	; changing button value into #0x00
				str			   r1,[r0,#0x10] ; 	storing r1 into LCD button register address
_np
				bx			   lr
                ENDP        
                ALIGN


                IF       :LNOT::DEF:__MICROLIB
                IMPORT   __use_two_region_memory
                ENDIF

                EXPORT   __stack_limit
                EXPORT   __initial_sp
                IF       Heap_Size != 0                      ; Heap is provided
                EXPORT   __heap_base
                EXPORT   __heap_limit
                ENDIF

                END

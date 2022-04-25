LCD_BALLROW				EQU 	0X73 ; BALL CENTER ROW OFFSET
LCD_BALLCOL				EQU		0X9B ; BALL CENTER COLUMN OFFSET
LCD_GOALRIGHTLEFTROW	EQU 	0X64 ; LEFT&RIGHT GOALKEEPER ROW OFFSET
LCD_GOALLEFTCOL			EQU		0X00 ; LEFT GOALKEEPER COLUMN OFFSET
LCD_GOALRIGHTCOL		EQU 	0X13A ; RIGHT GOALKEEPER COLUMN OFFSET
LCD_ROWOFFSET			EQU 	0x00 ; LCD ROW OFFSET
LCD_COLOFFSET			EQU 	0x04 ; LCD COLUMN OFFSET
LCD_PIXOFFSET			EQU 	0x08 ; LCD PIXEL OFFSET
LCD_CONOFFSET			EQU 	0x0C ; LCD CONTROL OFFSET
LCD_BUTOFFSET			EQU 	0x10 ; LCD BUTTON OFFSET

		AREA	BLG212PROJE, CODE, READONLY
		EXPORT	__main
		ALIGN
		ENTRY		
_DEFINITIONS    PROC						; _DEFINITIONS
		push	{r0,r1,r2,r3,lr} 			; push 
		ldr		r3, =0x20006000  			; oC ram address:
		movs 	r0, #LCD_BALLCOL 			; move LCD_BALLCOL constant into r0
		movs 	r1, #LCD_BALLROW 			; move LCD_BALLROW constant into r1
		str 	r0, [r3, #0x00]  			; oC(Column)-> LCD_BALLCOL stored in oC ram address
		str 	r1, [r3, #0x04]  			; oR(Row)-> LCD_BALLROW stored in oR ram address
		movs 	r0, #0x05 		 			; ball movement increment is #0x05
		str 	r0, [r3, #0x08]  			; coefC -> movement increment of column in the start of game is #0x05
		str 	r0, [r3, #0x0C] 			; coefR -> movement increment of row in the start of game is #0x05
		ldr		r1, =LCD_GOALRIGHTLEFTROW 	; LEFT&RIGHT GOAL KEEPER CENTER ROW OFFSET
		ldr 	r2, =0x20005000 			; DEFINITIONS FOR EQU 
		str		r1, [r2] 					; LCD_GOALRIGHTLEFTROW ->  stored it into the 0x20005000 ram address
		adds	r2,#0x04 					; increment the address by 0x04
		ldr 	r1, =LCD_GOALRIGHTCOL 		; RIGHT GOALKEEPER CENTER COLUMN OFFSET 
		str		r1, [r2] 					; RIGHT GOALKEEPER CENTER COLUMN OFFSET -> stored into 0x20005004 ram address
		adds 	r2,#0x04 					; increment the address by 0x04
		ldr 	r1, =LCD_GOALLEFTCOL 		; LEFT GOALKEEPER CENTER COLUMN OFFSET
		str		r1, [r2] 					; LEFT GOALKEEPER CENTER COLUMN OFFSET -> stored into 0x20005008 ram address 
		;0x20006010 ->the addresss that is holding the value of comparison result of ball row
		;0x20006014 ->the addresss that is holding the value of comparison result of ball column
		;0x20007000 ->the addresss that is for ball preposition deleting rows
		;0x20007004 ->the addresss that is for ball preposition deleting columns
		;0x20008000 ->the addresss that is for GKL Row position
		;0x20008004 ->the addresss that is for GKR Row Position
		;0x20008008 ->the addresss that is for GKL Movement  delete
		;0x2000800C ->the addresss that is for GKR Movement  delete
		;0x40010000 ->LCD Base address & LCD row address
		;0x40010004 ->LCD Column Address
		;0x40010008 ->LCD Pixel Address
		;0x4001000C ->LCD Control Address
		;0x40010010 ->LCD Button Address			
        pop 	{r0,r1,r2,r3,pc} 			; pop 
        ENDP
			
_createball PROC 						; CREATING THE BALL FUNCTION
		push 	{r0,r1,r2,r3,r5,r6,lr}  ; push 
		ldr		r1,	=0xFF7B68EE  		; load mediumslateblue color in alfaRGB -> r1 register
		ldr		r3, =0x40010000  		; load the LCD base address -> r3 register
		ldr		r2, =LCD_BALLROW 		; load LCD_BALLROW constant into r2
		movs	r6,#0x00 		 		; row counter into -> r6
_CBFILLROW 								; CREATEBALL FILL ROW
		ldr		r0, =LCD_BALLCOL 		; load LCD_BALLCOL constant into r0 
		movs	r5,#0x00 		 		; column counter into -> r5
		str		r2,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_CBFILLCOL								; CREATEBALL FILL COLUMN	
		str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
		str		r1,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
		adds	r5,#0x01 				; increment r5 by 0x01
		adds	r0,r0,#0x01 			; increment r0 by 0x01
		cmp 	r5,#0x0A 				; compare r5 with 0x0A(10 in decimal)
		bne		_CBFILLCOL 				; if not go into _CBFILLCOL
		adds 	r6,#0x01 				; increment r6 by 0x01
		adds	r2,r2,#0x01 			; increment r2 by 0x01	
		cmp		r6,#0x0A 				; compare r6 with 0x0A(10 in decimal)
		bne		_CBFILLROW 				; if not go into _CBFILLROW
		pop 	{r0,r1,r2,r3,r5,r6,pc}  ; pop 
		ENDP
						
_creategkleft PROC 						  ; CREATE GOAL KEEPER LEFT FUNCTION
		push 	{r0,r1,r2,r3,r5,r6,lr} 	  ; push 
		ldr		r1,	=0XFFFFD700 		  ; load gold color in alfaRGB -> r1 register
		ldr		r3, =0x40010000 		  ; load the LCD base address -> r3 register
		ldr		r2, =LCD_GOALRIGHTLEFTROW ; load LCD_BALLROW constant into -> r2 register			
		movs	r6,#0x00 				  ; row counter 
_GKLFILLROW 							  ; GOALKEEPERLEFT FILL ROW
		ldr		r0, =LCD_GOALLEFTCOL 	  ; load the value LCD_GOALLEFTCOL into r0
		movs	r5,#0x00 				  ; column counter
		str		r2,[r3, #LCD_ROWOFFSET]   ; store the r2 register into LCD row register
_GKLFILLCOL								  ; GOALKEEPERLEFT FILL COLUMN
		str 	r0,[r3, #LCD_COLOFFSET]   ; store the r0 register into LCD column register
		str		r1,[r3, #LCD_PIXOFFSET]   ; store the r1 register into LCD Pixel register
		adds	r5,#0x01 				  ; increment r5 by 0x01
		adds	r0,r0,#0x01 			  ; increment r0 by 0x01
		cmp 	r5,#0x04 			      ; compare r5 with 0x04
		bne		_GKLFILLCOL 			  ; if not go into _GKLFILLCOL
		adds 	r6,#0x01 				  ; increment r6 by 0x01
		adds	r2,r2,#0x01 			  ; increment r2 by 0x01	
		cmp		r6,#0x28 				  ; compare r6 with 0x28(40 in decimal)
		bne		_GKLFILLROW 			  ; if not go into _GKLFILLROW
		ldr		r0,=0x20008000			  ; load the value stored in 0x20008000(Last position GKL ROW LEFT)
		str		r2,[r0]					  ; load the last value stored in r2 into 0x20008000
		pop  	{r0,r1,r2,r3,r5,r6,pc}    ; pop
		ENDP
			
_creategkright PROC 					  ; CREATE GOAL KEEPER RIGHT FUNCTION
		push    {r0,r1,r2,r3,r5,r6,lr} 	  ; push
		ldr		r1,	=0xFFC0C0C0 		  ; load silver color in alfaRGB -> r1 register
		ldr		r3, =0x40010000 		  ; load the LCD base address -> r3 register
		ldr		r2, =LCD_GOALRIGHTLEFTROW ; load LCD_BALLROW constant into r2				
		movs	r6,#0x00 				  ; row counter
_GKRFILLROW 							  ; GOALKEEPERRIGHT FILL ROW
		ldr		r0, =0x13D 				  ; col offset
		ldr		r5, =0x00 				  ; column counter
		str		r2,[r3, #LCD_ROWOFFSET]   ; store the r2 register into LCD row register
_GKRFILLCOL								  ; GOALKEEPERRIGHT FILL COLUMN
		str 	r0,[r3, #LCD_COLOFFSET]   ; store the r0 register into LCD column register
		str		r1,[r3, #LCD_PIXOFFSET]   ; store the r1 register into LCD Pixel register
		adds	r5,#0x01 				  ; increment r5 by 0x01
		subs	r0,r0,#0x01 			  ; increment r0 by 0x01
		cmp 	r5,#0x04 				  ; compare r5 with 0x04
		bne		_GKRFILLCOL 			  ; if not go into _GKRFILLCOL
		adds 	r6,#0x01 				  ; increment r6 by 0x01
		adds	r2,r2,#0x01 			  ; increment r2 by 0x01	
		cmp		r6,#0x28 				  ; compare r6 with 0x28
		bne		_GKRFILLROW 			  ; if not go into _GKRFILLROW
		ldr		r0,=0x20008004			  ; load the value stored in 0x20008004(Last position GKL ROW LEFT)
		str		r2,[r0]					  ; load the last value stored in r2 into 0x20008004
		pop     {r0,r1,r2,r3,r5,r6,pc} 	  ; pop
		ENDP			
_refresh								  ; REFRESH FUNCTION
		push    {r1,r3,lr} 			      ; push
		ldr		r3, =0x40010000 		  ; load the LCD base address -> r3 register
		movs 	r1, #0x01 				  ; set least significant bit 1 to refresh screen
		str 	r1,[r3,#LCD_CONOFFSET]    ; refresh screen by storing r1 register into LCD control register
		pop	    {r1,r3,pc} 			  	  ; pop

_ballmovement PROC						  ; _ballmovement FUNCTION
    push {r0,r1,r2,r3,r4,r5,r6,r7,lr} 	  ; save the content of register which will be used in procedure
	ldr	r1,=0x40010000					  ; load the LCD base address -> r1 register    
    ldr r6,=0x20006000					  ; load the address 0x2000600(ram address for oC)
    ldr r0,[r6, #0x04] 				  	  ; load the value that is hold on 0x20006004(ram address for oR)
    ldr r4,[r6, #0x00] 				  	  ; load the value that is hold on 0x20006000(ram address for oC)
    ldr	r6,=0xFF7B68EE					  ; load mediumslateblue color in alfaRGB -> r6 register
	ldr r3, =0x00 						  ; initialize row counter
_frameR									  ; Row Frame
    movs r7,r0 							  ; move r0 into r7
    adds r7,r7,r3 						  ; oR + cR
    str  r7,[r1] 						  ; store the r7 register into LCD row register
    movs r5, #0x00 						  ; initalize counter of column	
_frameC											; _frameC
    movs r7,r4							  		; move r4 into r7
    add  r7, r7, r5 					 		; oC + column counter
    str  r7,[r1, #0x04] 				  		; write to column register of LCD	
    str  r6,[r1, #0x08] 				  		; write pixel value to pixel register of LCD
    adds r5, #0x01 						  		; increment r5 by 0x01
    cmp  r5, #0x0A 						  		; compare r5 by 0x0A (if entire column is finished)
    blt  _frameC 						  		; if it is not go back to _frameC
    adds r3, #0x01 					      		; increment r3 by 0x01
    cmp  r3, #0x0A 						  		; compare r3 by 0x0A (if entire row is finished)
    blt  _frameR 						  		; if it is not go back to _frameR
	ldr r3,=0x20007000							; load the address that is for deletement
	ldr	r2,[r1]									; load the value that is kept in LCD row address (0x40010000) 	
	str	r2,[r3]									; store it to row delete address to be used later
	ldr	r2,[r1,#0x04]							; load the value that is kept in LCD column address (0x40010004) 
	str r2,[r3,#0x04]							; store it to column delete address to be used later
    ldr r6, =0x20006000					  		; load the 0x20006000( oC ram address)	  
    ldr r3, [r6, #0x08] 				  		; load coefficient C value to r3
    ldr r5, [r6, #0x0C] 				  		; load coefficient R value to r5
    cmp r5,#0x02						  		; compare r5 with #0x02 (r5 = #0x02 if we reached bottom edge of LCD)
    beq _subsOpR						  		; branch to _subsOpR
    adds r0, r0, #0x05					  		; add r0 by #0x05 (movement of ball in positive row direction +5) 
    b _cCheck							  		; branch to _cCheck
_subsOpR								  		; substitute R
    subs r0, r0, #0x05 					  		; subs r0 by #0x05(movement of ball in negative row direction -5)
_cCheck									  		; checking the column
    cmp	r3,#0x02						  		; compare r3 with #0x02 (r5 = #0x02 if we reached bottom edge of LCD)
    beq _subsOpC						  		; branch to _subsOpC
    adds r4, r4, #0x05 					  		; adds r4 by #0x05 (movement of ball in positive column direction +5)
    b _update							  		; branch to _update
_subsOpC								  		; substitute column
    subs r4, r4, #0x05 					  		; subs r4 by #0x05 (movement of ball in negative column direction -5)
_update									  		; branch to _update
    str r0, [r6, #0x04] 				  		; update oR
    str r4, [r6, #0x00] 				  		; update oC	
    pop {r0, r1,r2, r3, r4, r5, r6, r7, pc}	    ; restore content of register which was used in procedure
    ENDP
    
_coefC PROC
    push {r0,r1,r3,r6,r7,lr} 			  ; push
	ldr	r1,=0x20007004					  ; load the delete col address -> r1 register
    ldr	r6,=0x20006000				  	  ; load the oC memory address -> r6 register
    ldr r3, [r1] 						  ; load the value stored in oC memory address
	subs r3,#0x0F						  ; substitute r3 by #0x05
    cmp r3, #0x04 						  ; comparison for less than or equal to 0x04
    bgt _upperBoundCheckC 				  ; if it is greater than zero check upper boundary
	bl  _goalleft 				 		  ; check if there is a goal in left goalkeeper
	movs r0, #0x01 						  ; if it is less than or equal to zero make r0 #0x01 so we will increase the column position by 5
    str r0, [r6, #0x08] 				  ; and store it in memory location which is reserved for coefficient C
    bl	 _finalC 						  ; and go to finalC
_upperBoundCheckC						  ; comparison for less than or equal to 320
    ldr  r0, =0x139 					  ; mov 0x139 to r0 
    ldr	 r7,[r1]						  ; load the value stored in 0x20007004 (last position of ball column)
	adds r7,#0x09						  ; add r7 with 0x09 
    cmp  r7, r0							  ; compare it with 0x139
    blt _finalC 						  ; if it is less than 0x139 goto final
	bl  _goalright						  ;	check if there is a goal in right goalkeeper
    movs r0, #0x02 						  ; if it is greater than 0x139 (r0 = #0x02 if we reached bottom edge of LCD) (so we can decrease column by 5)
    str  r0, [r6, #0x08] 				  ; and store it in memory location which is reserved for coefficient C
_finalC									  ; finalC
    pop {r0, r1,r3,r6,r7,pc}			  ; pop
    ENDP
_coefR PROC
    push {r0,r1,r2,r3,r6,r7, lr}			; push
	ldr	 r1, =0x20007000					; load the delete row address -> r1 register
    ldr	 r6, =0x20006000					; load r6 with 0x20006000 memory address(oC memory address)
    ldr  r3, [r1] 							; load the value of oR to r3
	subs r3 ,#0x0F							; substitute r3 by 0x0F
    cmp  r3, #0x00							; compare with r3 with 0x00
    bgt  _upperBoundCheckR 					; if it is greater than zero check upper boundary
    movs r0, #0x01 							; if it is less than or equal to zero make r0 #0x01 so we will increase the row position by 5
    str  r0, [r6, #0x0C] 					; and store it in memory location which is reserved for coefficient R
    b    _finalR 							; and goto _finalR
_upperBoundCheckR							; comparison for greater than or equal to zero, then comparison with 0xEF					
    ldr	 r7,[r1]							; get the last position of row into r7
	adds r7,#0x0A							; add r7 with 0x0A
    cmp  r7,#0xEF							; compare r7 0xEF(239)
    blt  _finalR 							; if it is not equal go to _finalR 
    movs r2, #0x02 							; if it is greater than or equal to 0xEF make it #0x02 so we will decrease the row position by 5
    str  r2, [r6, #0x0C] 					; and store it in memory location which is reserved for coefficient R
_finalR										; _finalR
    pop  {r0,r2,r1,r3,r6,r7, pc}				; pop
    ENDP
		
		
_prepositiondeleter PROC					 ; prepositiondeleter
		push 	{r0,r1,r2,r3,r4,r5,r6,r7,lr} ; push r0,r1,r2,r3,r5,r6,lr
		ldr		r3, =0x40010000 			 ; load the LCD base address into -> r3
		ldr		r1, =0x20007000 			 ; load the row delete address into -> r1		
		ldr		r7, [r1] 					 ; take the value that is last row position of ball
		subs	r7, r7,#0x0A 				 ; subs r7 by 0x0A
		movs	r2, r7 						 ; move r7 to r2
		movs	r6,#0x00 					 ; row counter -> r6
_BDFILLROW 									 ; BALLDELETE FILL ROW	    
		ldr		r7,[r1,#0x04] 				 ; take the value that is last column position of ball	
		subs	r7,r7,#0x0A 				 ; subs r7 by 0x0A
		movs	r0,r7 						 ; move r7 into r0
		movs	r5,#0x00 					 ; column counter
		str		r2,[r3, #LCD_ROWOFFSET] 	 ; store the r2 register into LCD row register		
_BDFILLCOL 									 ; BALLDELETE FILL COLUMN
		ldr		r7,=0xFF000000 				 ; BLACK COLOR TO DELETE PREVIOUS CONTENT OF BALL
		str 	r0,[r3, #LCD_COLOFFSET]	 	 ; store the r0 register into LCD column register
		str		r7,[r3, #LCD_PIXOFFSET] 	 ; store the r1 register into LCD Pixel register
		adds	r5,#0x01 					 ; increment r5 by 0x01
		adds	r0,#0x01 				 	 ; increment r0 by 0x01		
		cmp 	r5,#0x0B 					 ; compare r5 with 0x0B 
		blt		_BDFILLCOL 					 ; if not go into _BDFILLCOL
		adds 	r6,#0x01 				 	 ; increment r6
		adds	r2,#0x01 			     	 ; increment r2 by 1						
		cmp		r6,#0x0B 					 ; compare r6 with 0x0B
		blt		_BDFILLROW 					 ; if not go into _BDFILLROW	
		pop 	{r0,r1,r2,r3,r4,r5,r6,r7,pc} ; pop r0,r1,r2,r3,r5,r6,pc
		ENDP	
		
		
_delay PROC					;_delay
    push 	{r7, lr} 		; push
    ldr		r7, =0x00088000 ; giving random value to make delay, chosen by the delay seconds we wanted
_delayLoop					;_delayLoop
    subs 	r7, r7, #0x01 	; subtract r7 by 0x01 
    bpl 	_delayLoop 		; if positive or zero go into loop again
    pop 	{r7, pc} 		; pop 
    ENDP
		
_GKLmovementup PROC			;_GKLmovementup
	push	{r0,r1,r2,r3,r5,r6,r7,lr} ; push
	ldr		r0,=0x20008000	; GKL row left address
	ldr		r3,=0x40010000	; 
	ldr		r1,=0XFFFFD700	; load the gold color in alfargb into -> r1
	ldr		r2,[r0] 		; load the GKL row left value into r2
	str		r2,[r0,#0x08]	; store it into GKL row left delete address to be used later
	subs	r2,r2,#0x28		; because we are in the bottom edge of goalkeeper we want to go upper side so we add it by 0x28(40 in decimal)
	cmp		r2,#0x00	    ; compare if we reached top edge of screen 
	beq		_end			; if so dont move up
	subs	r2,r2,#0x14		; if not decrease r2 by 0x14(20 in decimal) which is our unit movement
	str		r2,[r0] 		; store the row value which will be our next bottom edge			
	movs	r6,#0x00 		; row counter 
_GKLMFILLROW 				; GOALKEEPERLEFTMOVEMENT FILL ROW
	ldr		r0, =LCD_GOALLEFTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 			 ; column counter
	str		r2,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKLMFILLCOL						; GOALKEEPERLEFTMOVEMENT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r1,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 				; increment r5 by 1
	adds	r0,r0,#0x01 			; increment r0 by 0x01
	cmp 	r5,#0x04 				; compare r5 with 0x04
	blt		_GKLMFILLCOL 			; if not go into _GKLMFILLCOL
	adds 	r6,#0x01 				; increment r6 by 1
	adds	r2,r2,#0x01 			; increment r2 by 1	
	cmp		r6,#0x28 				; compare r6 with 0x28
	blt		_GKLMFILLROW 			; if not go into _GKLMFILLROW
	ldr		r0,=0x20008000			; load the GKL row left address into r0
	str		r2,[r0]					; store r2 into GKL row left address
_GKLD
	ldr	 	r1,=0x20008008			; load the address of GKL ROW LEFT Delete
	ldr		r3,=0x40010000			;
	ldr		r2,=0xFF000000			; load the black color in alfargb into -> r2
	ldr		r7,[r1]					; load the value of GKL ROW LEFT Delete
	subs	r7,r7,#0x14				; subtitute r7 by 0x14( decimal 20) which is movement up value
	movs	r6,#0x00				; row counter
_GKLDFILLROW ;GOALKEEPERLEFTDELETE FILL ROW
	ldr		r0, =LCD_GOALLEFTCOL	; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 				; column counter
	str		r7,[r3, #LCD_ROWOFFSET] ; store the r7 register into LCD row register
_GKLDFILLCOL	;GOALKEEPERLEFTDELETE FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r2,[r3, #LCD_PIXOFFSET] ; store the r2 register into LCD Pixel register
	adds	r5,#0x01 ; increment r5 by 1
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 ; compare r5 with 0x04
	blt		_GKLDFILLCOL ; if not go into _GKLDFILLCOL
	adds 	r6,#0x01 ; increment r6 by 1
	adds	r7,r7,#0x01 ; increment r7 by 1	
	cmp		r6,#0x14 ; compare r6 with 0x14
	blt		_GKLDFILLROW ; if not go into _GKLDFILLROW
	ldr		r0,=0x20008000 ; load the GKL ROW LEFT address
	ldr		r1,[r0]		   ; load the value of GKL row left 
	str		r1,[r0,#0x08]  ; store r1 into GKL ROW LEFT DELETE address
_end
	bl		_refresh		;	branch to refresh
	ldr		r3,=0x20000600 	;	load the memory address of 0x20000600 which holds the value of LCD row register before interrupt happens
    ldr     r0,=0x40010000	; 
	ldr		r2,[r3,#0x60]	;	get the value of LCD row register before interrupt happens 
	str		r2,[r0]			;	store it back to the LCD row register
	ldr		r2,[r3,#0x64]	;	get the value of LCD col register before interrupt happens
	str		r2,[r0,#0x04]	;	store it back to the LCD col register
    ldr     r1,[r0,#0x10]	;	get the LCD button value into r1
	ldr     r3,=0x7FFFFFFF	;	and it with only 32'nd bit 0, 
    ands    r1,r1,r3		;   and r1 with r3
	str		r1,[r0,#0x10]	;	store it back to the LCD button address
	pop 	{r0,r1,r2,r3,r5,r6,r7,pc}	; pop
	ENDP
	
_GKLmovementdown PROC ; this is the same procedure in _GKLmovementleft only we add #0x14 to move down
	push	{r0,r1,r2,r3,r5,r6,r7,lr}
	ldr		r0,=0x20008000
	ldr		r3,=0x40010000
	ldr		r1,=0XFFFFD700
	ldr		r2,[r0] ;
	str		r2,[r0,#0x08]
	subs	r2,#0x28			
	cmp		r2,#0xC8
	beq		_endD
	adds	r2,r2,#0x14	; add it with #0x14 (20 in decimal) the next row position
	str		r2,[r0] 	; load the content stored in r2 address into r0				
	movs	r6,#0x00 	; row counter
_GKLMDFILLROW ; GOALKEEPERLEFT FILL ROW
	ldr		r0, =LCD_GOALLEFTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 				; column counter
	str		r2,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKLMDFILLCOL	; GOALKEEPERLEFT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r1,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 	; increment r5 by 0x01
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 	; compare r5 with 0x04
	blt		_GKLMDFILLCOL ; if not go into _GKLFILLCOL
	adds 	r6,#0x01 	; increment r6 by 1
	adds	r2,r2,#0x01 ; increment r2 by 1	
	cmp		r6,#0x28 	; compare r6 with 0x28
	blt		_GKLMDFILLROW ; if not go into _GKLFILLROW
	ldr		r0,=0x20008000;
	str		r2,[r0]
_GKLDD
	ldr	 	r1,=0x20008008
	ldr		r3,=0x40010000
	ldr		r2,=0xFF000000
	ldr		r7,[r1]
	subs	r7,r7,#0x28
	movs	r6,#0x00
_GKLDDFILLROW ; GOALKEEPERLEFT FILL ROW
	ldr		r0, =LCD_GOALLEFTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 ; column counter
	str		r7,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKLDDFILLCOL	; GOALKEEPERRIGHT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r2,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 ; increment r5 by 1
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 ; compare r5 with 0x04
	blt		_GKLDDFILLCOL ; if not go into _GKLFILLCOL
	adds 	r6,#0x01 ; increment r6 by 1
	adds	r7,r7,#0x01 ; increment r2 by 1	
	cmp		r6,#0x14 ; compare r6 with 0x28
	blt		_GKLDDFILLROW ; if not go into _GKLFILLROW
	ldr		r0,=0x20008000
	ldr		r1,[r0]
	str		r1,[r0,#0x08]	
_endD
	bl	_refresh
	ldr		r3,=0x20000600
    ldr     r0,=0x40010000
	ldr		r2,[r3,#0x60]
	str		r2,[r0]
	ldr		r2,[r3,#0x64]
	str		r2,[r0,#0x04]
    ldr     r1,[r0,#0x10]
	ldr     r3,=0x7FFFFFFF
    ands    r1,r1,r3
	str		r1,[r0,#0x10]
	pop  	{r0,r1,r2,r3,r5,r6,r7,pc}
	ENDP
_GKRmovementup PROC ; This is the same procedure in _GKLmovementleft but the row addresses are changed into right
	push	{r0,r1,r2,r3,r5,r6,r7,lr}
	ldr		r0,=0x20008004	; GKR ROW address
	ldr		r3,=0x40010000
	ldr		r1,=0xFFC0C0C0	; silver color in alfa rgb into -> r1
	ldr		r2,[r0];
	str		r2,[r0,#0x08] ; GKR Row delete address 0x2000800C
	subs	r2,r2,#0x28	
	cmp		r2,#0x00
	beq		_endR
	subs	r2,r2,#0x14			
	movs	r6,#0x00 ; row counter
_GKRMFILLROW ; GOALKEEPERLEFT FILL ROW
	ldr		r0, =LCD_GOALRIGHTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 ; column counter
	str		r2,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKRMFILLCOL	; GOALKEEPERRIGHT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r1,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 ; increment r5 by 0x01
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 ; compare r5 with 0x04
	blt		_GKRMFILLCOL ; if not go into _GKLFILLCOL
	adds 	r6,#0x01 ; increment r6 by 0x01
	adds	r2,r2,#0x01 ; increment r2 by 0x01	
	cmp		r6,#0x28 ; compare r6 with 0x28
	blt		_GKRMFILLROW ; if not go into _GKLFILLROW
	ldr		r0,=0x20008004; GKR Row Address
	str		r2,[r0]
_GKRD
	ldr	 	r1,=0x2000800C ;GKR Row delete address 
	ldr		r3,=0x40010000
	ldr		r2,=0xFF000000
	ldr		r7,[r1]
	subs	r7,r7,#0x14
	movs	r6,#0x00
_GKRDFILLROW ; GOALKEEPERLEFT FILL ROW
	ldr		r0, =LCD_GOALRIGHTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 ; column counter
	str		r7,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKRDFILLCOL	; GOALKEEPERRIGHT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r2,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 ; increment r5 by 1
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 ; compare r5 with 0x04
	blt		_GKRDFILLCOL ; if not go into _GKLFILLCOL
	adds 	r6,#0x01 ; increment r6 by 1
	adds	r7,r7,#0x01 ; increment r2 by 1	
	cmp		r6,#0x14 ; compare r6 with 0x28
	blt		_GKRDFILLROW ; if not go into _GKLFILLROW
	ldr		r0,=0x20008004
	ldr		r1,[r0]
	str		r1,[r0,#0x08]
	
_endR
	bl	_refresh
	ldr		r3,=0x20000600
    ldr     r0,=0x40010000
	ldr		r2,[r3,#0x60]
	str		r2,[r0]
	ldr		r2,[r3,#0x64]
	str		r2,[r0,#0x04]
    ldr     r1,[r0,#0x10]
	ldr     r3,=0x7FFFFFFF
    ands    r1,r1,r3
	str		r1,[r0,#0x10]
	pop  	{r0,r1,r2,r3,r5,r6,r7,pc} ; pop r0,r1,r2,r3,r5,r6,pc
	ENDP
	
_GKRmovementdown PROC ; This is the same procedure in _GKLmovementleft but the row addresses are changed into right & we add #0x14 to move down
	push	{r0,r1,r2,r3,r5,r6,r7,lr}
	ldr		r0,=0x20008004
	ldr		r3,=0x40010000
	ldr		r1,=0xFFC0C0C0
	ldr		r2,[r0] ;
	str		r2,[r0,#0x08]
	subs	r2,#0x28		
	cmp		r2,#0xC8
	beq		_endDR
	adds	r2,r2,#0x14			
	movs	r6,#0x00 ; row counter
_GKRMDFILLROW ; GOALKEEPERLEFT FILL ROW
	ldr		r0, =LCD_GOALRIGHTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 ; column counter
	str		r2,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKRMDFILLCOL	; GOALKEEPERLEFT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r1,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 ; increment r5 by 1
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 ; compare r5 with 0x04
	blt		_GKRMDFILLCOL ; if not go into _GKLFILLCOL
	adds 	r6,#0x01 ; increment r6 by 1
	adds	r2,r2,#0x01 ; increment r2 by 1	
	cmp		r6,#0x28 ; compare r6 with 0x28
	blt		_GKRMDFILLROW ; if not go into _GKLFILLROW
	ldr		r0,=0x20008004;
	str		r2,[r0]
_GKRDD
	ldr	 	r1,=0x2000800C
	ldr		r3,=0x40010000
	ldr		r2,=0xFF000000
	ldr		r7,[r1]
	subs	r7,r7,#0x28
	movs	r6,#0x00
_GKRDDFILLROW ; GOALKEEPERLEFT FILL ROW
	ldr		r0, =LCD_GOALRIGHTCOL ; load the value GOALLEFTcolumn into r0
	movs	r5,#0x00 ; column counter
	str		r7,[r3, #LCD_ROWOFFSET] ; store the r2 register into LCD row register
_GKRDDFILLCOL	; GOALKEEPERRIGHT FILL COLUMN
	str 	r0,[r3, #LCD_COLOFFSET] ; store the r0 register into LCD column register
	str		r2,[r3, #LCD_PIXOFFSET] ; store the r1 register into LCD Pixel register
	adds	r5,#0x01 ; increment r5 by 1
	adds	r0,r0,#0x01 ; increment r0 by 0x01
	cmp 	r5,#0x04 ; compare r5 with 0x04
	blt		_GKRDDFILLCOL ; if not go into _GKLFILLCOL
	adds 	r6,#0x01 ; increment r6 by 1
	adds	r7,r7,#0x01 ; increment r2 by 1	
	cmp		r6,#0x14 ; compare r6 with 0x28
	blt		_GKRDDFILLROW ; if not go into _GKLFILLROW
	ldr		r0,=0x20008004
	ldr		r1,[r0]
	str		r1,[r0,#0x08]	
_endDR
	bl		_refresh
	ldr		r3,=0x20000600
    ldr     r0,=0x40010000
	ldr		r2,[r3,#0x60]
	str		r2,[r0]
	ldr		r2,[r3,#0x64]
	str		r2,[r0,#0x04]
    ldr     r1,[r0,#0x10]
	ldr     r3,=0x7FFFFFFF
    ands    r1,r1,r3
	str		r1,[r0,#0x10]
	pop  	{r0,r1,r2,r3,r5,r6,r7,pc} ; pop r0,r1,r2,r3,r5,r6,pc

	ENDP	
_clear PROC
	push 	{r0,r2,lr}
	ldr  	r0,=0x4001000C
	movs 	r2,#0x02
	str	 	r2,[r0]
	pop 	{r0,r2,pc}
	ENDP		
		
_goalleft PROC ; Checking if there is a goal in left goal keeeper
	push	{r0,r1,r2,r3,lr} 	;
	ldr 	r3,=Reset_Handler	; Reset Handler address into -> r3
	ldr		r0,=0x20008000 		; Goalkeeper left row last position address
	ldr		r1,[r0] 			; Goalkeeper left row last position value
	ldr 	r0,=0x20007000 		; ball last row position
	ldr		r2,[r0]				; getting the ball's last row position
	subs 	r2,#0x0A			; subtracting the ball's last row position by 0x0A to get upper edge of ball's row position
	cmp 	r2,r1				; comparing upper edge of ball's row position with GKL's bottom edge row position
	bgt		_resetleft			; if ball's position is greater than go into reset (THERE IS A GOAL!)
	adds 	r2,#0x0A			; adding the ball's last row position by 0x0A to get bottom edge of ball's row position	
	subs 	r1,#0x28			; subtracting the GKL's last row position by 0x28 to get upper edge of GKL's row position	
	cmp	 	r2,r1				; comparing bottom edge of ball's row position with GKL's upper edge row position
	blt 	_resetleft			; if ball's position is lower than go into reset (THERE IS A GOAL!)
	bl 		_endleft			; if not go into _endleft
_resetleft 
	bx		r3					; branch to Reset_Handler	
_endleft
	pop		{r0,r1,r2,r3,pc}
	ENDP	
		
_goalright	PROC	; Checking if there is a goal in right goal keeeper
	push	{r0,r1,r2,r3,lr}
	ldr 	r3,=Reset_Handler ; Reset Handler address into -> r3
	ldr		r0,=0x20008004  ; Goalkeeper right row last position address
	ldr		r1,[r0] 		; Goalkeeper right row last position value
	ldr 	r0,=0x20007000  ; ball last row position
	ldr		r2,[r0]			; getting the ball's last row position
	subs 	r2,#0x0A		; subtracting the ball's last row position by 0x0A to get upper edge of ball's row position
	cmp 	r2,r1			; comparing upper edge of ball's row position with GKR's bottom edge row position
	bgt		_resetright		; if ball's position is greater than go into reset (THERE IS A GOAL!)
	adds 	r2,#0x0A		; adding the ball's last row position by 0x0A to get bottom edge of ball's row position			
	subs 	r1,#0x28		; subtracting the GKR's last row position by 0x28 to get upper edge of GKL's row position
	cmp  	r2,r1			; comparing bottom edge of ball's row position with GKR's upper edge row position		
	blt 	_resetright		; if ball's position is lower than go into reset (THERE IS A GOAL!)
	b   	_endright		; if not go into _endright
_resetright
	bx r3					; branch to Reset_Handler	
_endright
	pop		{r0,r1,r2,r3,pc}
	ENDP
__main PROC
	IMPORT Reset_Handler	; Import Reset_Handler to reset if there is a goal
	EXPORT _GKRmovementup	; EXPORT _GKRmovementup for interrupt services
	EXPORT _GKRmovementdown	; EXPORT _GKRmovementdown for interrupt services
	EXPORT _GKLmovementup	; EXPORT _GKLmovementup for interrupt services
	EXPORT _GKLmovementdown	; EXPORT _GKRmovementdown for interrupt services
	bl  _clear 				; branch to  clear 
	bl	_refresh 			; branch to _refresh 
	bl	_DEFINITIONS 		; BRANCH TO _DEFINITIONS 
    bl	_createball  		; BRANCH TO _createball
	bl 	_creategkleft 		; branch to _creategkleft 
	bl 	_creategkright		; BRANCH TO _creategkright 	
	bl	_refresh			; branch to _refresh 
_loop						; _loop
	bl _prepositiondeleter	; branch to _prepositiondeleter 
    bl _ballmovement		; branch to _ballmovement 
    bl _delay				; branch to _delay 
	bl _refresh				; branch to _refresh 
	bl _coefC				; branch to _coefC 
    bl _coefR				; branch to _coefR 
    b _loop					; branch to _loop 
	ENDP
	END
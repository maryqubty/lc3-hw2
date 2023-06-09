
.orig x4320
PrintNum:
; Arguments: R0 = A number. Numerical value, NOT ASCII!
; Output: The subroutine prints to the console a number it gets in R0. Numerical value => ASCII values is what you're here to do.
ST R7, PRINTNUM_R7_SAVE
ST R0, PRINTNUM_R0_SAVE
ST R1, PRINTNUM_R1_SAVE
ST R2, PRINTNUM_R2_SAVE ; WHEN WE CALL DIV SABROUTINE, THESE REGISTERS WILL HAVE NEW VALUES, WE DON'T WANT TO LOSE THE PREVIOUS VALUES.
ST R3, PRINTNUM_R3_SAVE
ST R4, PRINTNUM_R4_SAVE ; WILL HOLD THE ADDRESS OF DIV SABROUTINE.
ST R5, PRINTNUM_R5_SAVE ; PTR TO INTEGERS_ARRAY THAT WILL SAVE THE INTEGERS OF THE NUMBER SEPERATELY.
; Your code here. Remember to save the registers that you will use to subroutine-specific labels, and then load them just before the RET command.	
 LD R4, DIV_PTR ; THE ADDRESS FOR CALLING DIV.
 LEA R5, INTEGERS_ARRAY ;PTR TO THE BEGINNING OF INTEGERS_ARRAY.
 
;CHECK IF NUMBER IS NEGATIVE. 
 ADD R1, R0, #0
 BRzp START 
 LD R0, MINUS_ASCII_SIGN ;MINUS SIGN ASCII_VALUE =45 
 OUT ;PRINTS "-" IF THE NUM IS NEGATIVE.
 ;NO WORRIES, THE RECEIVED NUMBER IS SAVED IN R1 WE DIDN'T OVERWRITE IT :)
 ADD R0, R1, #0 ;R0=THE RECEIVED NUMBER.
 
	START: 
 AND R1, R1, #0
 ADD R1, R1, #10 ;DEVIDING THE INPUT WITH 10 IN ORDER TO SEPERATE THE INTEGERS. 
 
 PRINTNUM_LOOP: ; WHILE (!R2). THE GOAL IS TO KEEP ON DEVIDING UNTIL THERE'S NOTHING LEFT TO DEVIDE.
 JSRR R4 ; DIV: R2=R0/R1, R3=REST 
 STR R3, R5, #0 ; MEM[CURRENT_INTEGERS_ARRAY_PTR]= CURRENT R0%10  
 ADD R5, R5, #1 ; WE INCREASE THE PTR TO POINT TO THE NEXT CELL IN INTEGERS_ARRAY.
 ADD R0, R2, #0 ;CURRENT R0= PREVIOUS R0/10
 BRnp PRINTNUM_LOOP  

 ADD R5, R5, #-1 ; AT THE END OF LOOP, R5 POINTS AT NULL, WE FIX THIS BY TAKING A STEP BACK.
 ;WE'RE GONNA USE R1 AS A COUNTER TO GO THROUGH THE INTEGERS_ARRAY FROM END TO BEGINNING.
 LEA R1, INTEGERS_ARRAY 
 NOT R1, R1
 ADD R1, R1, #1 
 ADD R1, R5, R1 ;R1 IS THE NUMBER OF SEPERATED INTEGERS IN RECEIVED INPUT(THE ACTUAL SIZE OF INTEGERS_ARRAY). IT'S THE OFFSET FROM INTEGERS_ARRAY_PTR TO THE BEGINNING OF INTEGERS_ARRAY.
 
 LD R3, ASCII_OFFSET ;R3=48
	PRINT_LOOP: 
 LDR R0, R5, #0
 ADD R0, R0, R3  ; ASCII OFFSET 
 OUT             ;PRINT MEM[CURRENT_INTEGERS_ARRAY_PTR]
 ADD R5, R5, #-1
 ADD R1, R1, #-1
 BRzp PRINT_LOOP ;AS LONG AS THE COUNTER>=0 WE'RE GOOD TO CONTINUE THE LOOP. 

	FINISH:
LD R7, PRINTNUM_R7_SAVE
LD R0, PRINTNUM_R0_SAVE 
LD R1, PRINTNUM_R1_SAVE
LD R2, PRINTNUM_R2_SAVE 
LD R3, PRINTNUM_R3_SAVE
LD R4, PRINTNUM_R4_SAVE
LD R5, PRINTNUM_R5_SAVE

RET
PRINTNUM_R7_SAVE  .fill #0
PRINTNUM_R0_SAVE  .fill #0
PRINTNUM_R1_SAVE  .fill #0
PRINTNUM_R2_SAVE  .fill #0
PRINTNUM_R3_SAVE  .fill #0
PRINTNUM_R4_SAVE  .fill #0
PRINTNUM_R5_SAVE  .fill #0

INTEGERS_ARRAY                .blkw #5   ; IT'S ENOUGHT TO ALLOCATE ONLY 5 CELLS SINCE THE HIGHEST LEGAL NUMBER CONSISTS 5 INTEGERS.
DIV_PTR              .fill X4064 
MINUS_ASCII_SIGN     .fill #45
ASCII_OFFSET         .fill #48
; Put your various labels here, between RET and .END.
; Remember to write comments that thoroughly explain everything you do - this is assembly code, not Python or C! It's hard to follow otherwise.	

; Make sure to properly write your real ID at the top of this asm file, don't just leave the default values there!
.end

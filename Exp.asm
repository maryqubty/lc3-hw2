; 206528275, 50%
; 315046128, 50%
.ORIG X40C8
Exp:

ST R7, EXP_R7_SAVE
ST R1, EXP_R1_SAVE
ST R3, EXP_R3_SAVE   ;SAVING THE PREVIUS VALUE OF REGISTERS 
ST R4, EXP_R4_SAVE ;ACTS AS COUNTER FOR THE LOOP         
LD R2, ERROR           

;FIRST WE CHECK THE ILLEGAL CASES:
;CASE 1, R1<0 OR R2<0 
ADD R0, R0, #0 
BRn FINISH
ADD R1, R1, #0
BRn FINISH 
BRp LEGAL
;CASE 2, R1=R2=0:
;IF REACHED HERE, R1=0
ADD R0, R0, #0
BRz FINISH
;in case r0>0, r1=0 ----> R2=1:
ADD R2, R2, #2
BR FINISH 

; IF REACHED HERE THEN R0>=0, R1>0
LEGAL:
;casr 3: R1=1 then the result should be R0:
ADD R2, R0, #0 ;WE INITIATE THE RESULT WITH THE VALUE OF R0, IN CASE R1=1.
ADD R1, R1, #-1 
BRz FINISH

;R1 IS CURRENTLY R1 (THAT WE RECIEVED) MINUS 1, THIS WILL KEEP THE LOOP LEGAL SINCE WE HAVE TO CALL MULL R1-1 TIMES AND NOT R1 TIMES 
LD R3, Mul_PTR  ;R3 HOLDS THE ADDRESS OF MUL 
ADD R4, R1, #0    ; R4 ACTS AS COUNTER, WE'RE GONNA MULTIPLY R0 WITH ITSELF R1 TIMES
ADD R1, R0, #0 ; R1=R0 AT THE BEGINNING SINCE WE'RE MULTIPLYING R0 WITH ITSELF, AFTER THE FIRST TIME, R4 WILL HOLD THE RESULT.
LOOP:
  
   JSRR R3   ; 
   ADD R1, R2, #0
   ADD R4, R4, #-1
   BRp LOOP


; Your code here. Remember to save the registers that you will use to subroutine-specific labels, and then load them just before the RET command.
FINISH:
; Note: Exp uses Mul, but Mul isn't in this file, nor should it be. You won't be using JSR here - you will use JSRR. That means you need a label for Mul's address. You will find an example label at the bottom. Feel free to use it verbatim.			
LD R7, EXP_R7_SAVE
LD R1, EXP_R1_SAVE
LD R3, EXP_R3_SAVE
LD R4, EXP_R4_SAVE 
RET

EXP_R7_SAVE .FILL #0
EXP_R1_SAVE .FILL #0
EXP_R3_SAVE .FILL #0	
EXP_R4_SAVE .FILL #0

ERROR .FILL #-1	
Mul_PTR .FILL x4000
; Put your various labels here, between RET and .END.
; Remember to write comments that thoroughly explain everything you do - this is assembly code, not Python or C! It's hard to follow otherwise.	

; Make sure to properly write your real ID at the top of this asm file, don't just leave the default values there!

; Here's an example of a pointer label to Mul. As you can see, it's simply .fill, and the value is Mul's address according to HW1's requirements document. Remembere, you use LD to load the contents pointed by a label to a register...

; Mul_PTR .FILL x4000
.END

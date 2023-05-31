
.ORIG X4000
Mul:
                                   ;  mem[MUL_R3_SAVE]=R3 ,נשמור את הערך של הרגסטר לפני שיידרס
ST R3, MUL_R3_SAVE          ; נשתמש בריגסטרים נוספים בשביל לשחק בסימנים של הקלט
ST R4, MUL_R4_SAVE
ST R7, MUL_R7_SAVE

AND R2, R2, #0       ; נאפס את הריגסטר
; now we have to deal with different cases:
;case one: one of the values is 0:
ADD R3, R0, #0
BRz FINISH
ADD R4, R1, #0
BRz FINISH
; case two: both values are positive:
BRn R1_NEGATIVE
ADD R3, R0, #0
BRn R0_NEGATIVE_R1_POSITIVE
BR MUL_LOOP

; case three: both values are negative:
R1_NEGATIVE:
ADD R3, R0, #0
BRp R1_NEGATIVE_R0_POSITIVE
; if we reached this line, it means that both values are indeed negative, we convert them to positive and do a regular mul:
NOT R4, R4
ADD R4, R4, #1
NOT R3, R3
ADD R3, R3, #1
BR MUL_LOOP

; case four: only one of the values is negative. 
; we load the negative value into R3 since this is the register that we're using in the LOOP tochange the value of R2, and we load  the positive value into R4 since this is the "counter".
R0_NEGATIVE_R1_POSITIVE:
ADD R3, R0, #0
ADD R4, R1, #0
BR MUL_LOOP

R1_NEGATIVE_R0_POSITIVE:
ADD R3, R1, #0
ADD R4, R0, #0


MUL_LOOP:                      ; פעולת הכפל היא שקולה להוספת את האיבר לעצמו מספר הפעמים שאנו כופלים בו 
ADD R2, R2, R3
ADD R4, R4, #-1
BRp MUL_LOOP            ; the loop stops when we add the value of R3, R4 times


; Your code here. Remember to save the registers that you will use to subroutine-specific labels, and then load them just before the RET command.			

FINISH:
                           ; החזרת הערך ההתחלתי  
LD R3, MUL_R3_SAVE
LD R4, MUL_R4_SAVE
LD R7, MUL_R7_SAVE
RET

MUL_R3_SAVE .fill #0	
MUL_R4_SAVE .fill #0
MUL_R7_SAVE .fill #0 
; Put your various labels here, between RET and .END.
; Remember to write comments that thoroughly explain everything you do - this is assembly code, not Python or C! It's hard to follow otherwise.	

; Make sure to properly write your real ID at the top of this asm file, don't just leave the default values there!
.END

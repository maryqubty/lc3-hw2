; 206528275, 50%
; 315046128, 50%
.ORIG X4064
Div:

                                   ;  נשמור את הערך של הרגסטר לפני שיידרס
ST R0, DIV_R0_SAVE         
ST R1, DIV_R1_SAVE
ST R4, DIV_R4_SAVE                  ; we're gonna use an additional register that indicates the result sign.
ST R7, DIV_R7_SAVE

LD R2, ERROR       ; we initiate the registers with -1.
LD R3, ERROR

; now we have to deal with different cases:
;case one: one of the values is 0:
ADD R1, R1, #0
BRz FINISH    ; in case R1=0 - illigal calculation
LD R2, ZERO
LD R3, ZERO
ADD R0, R0, #0
BRz FINISH

; case two: both values are positive: we send them to the pre-loop2 and change R4=0 to indicate that the result should be positive.
BRn R0_NEGATIVE
ADD R1, R1, #0
BRn R1_NEGATIVE_R0_POSITIVE
LD R4, ZERO
BR PRE_LOOP2 

; case three: both values are negative:
R0_NEGATIVE:
ADD R1, R1, #0
BRp R0_NEGATIVE_R1_POSITIVE
; if we reached this line, it means that both values are indeed negative, the result should be positive, so we change R4=0 to indicate a positive result' and then go to pre-loop3 :
LD R4, ZERO
BR PRE_LOOP3

; case four: only one of the values is negative- the final result should be negative, so we change R4=1 to indicate that the result is negative, and then jump to the loop/pre-loop4.

R1_NEGATIVE_R0_POSITIVE:
LD R4, ZERO
ADD R4, R4, #1
BR DIVIDE
R0_NEGATIVE_R1_POSITIVE: 
LD R4, ZERO
ADD R4, R4, #1
BR PRE_LOOP4

;the idea of the loop is to do R0-R1 until R0<=0.
; case two and three have both registers with the same sign, so we have to swich one the registers in each case, to have a legal MINUS operation using the ADD.
; case four already has two registers with different signs so the ADD operation is basically MINUS, but we have to swich sign in case four R0-NEGATIVE&R1-POSITIVE :).

PRE_LOOP2:
NOT R1, R1
ADD R1, R1, #1
BR DIVIDE

PRE_LOOP3:
NOT R0, R0
ADD R0, R0, #1
BR DIVIDE

PRE_LOOP4:
NOT R0, R0
ADD R0, R0, #1
NOT R1, R1
ADD R1, R1, #1
BR DIVIDE

ADD R2, R2, #0 ;R2 is initiated with 0 before intering the DIVIDE.
; R2 should always be added after we completed a whole cycle and made sure that R0>=R1. 
LOOP_ADD:
ADD R2, R2, #1
DIVIDE:                 
ADD R3, R0, #0 ; R3 WILL HOLD THE VALUE BEFORE DOING THE MINUS, SO IF WE GET TO THE END OF THE LOOP IT WILL HAVE THE 'REST' VALUE    
ADD R0, R0, R1
BRzp LOOP_ADD            ; we jump to loop_add in order to increase the counter r2 and then continue to the loop. the loop stops when R0<=0

ADD R4, R4, #0                ; if R4=0, R2 should be positive, else, it should be negative.
BRz FINISH
BR NEGATIVE_RESULT

NEGATIVE_RESULT:  ;CONVERTING R2 TO NEGATIVE 
NOT R2, R2       
ADD R2, R2, #1

FINISH:
                           ; החזרת הערך ההתחלתי  
LD R0, DIV_R0_SAVE
LD R1, DIV_R1_SAVE
LD R4, DIV_R4_SAVE
LD R7, DIV_R7_SAVE
RET

DIV_R0_SAVE .fill #0	
DIV_R1_SAVE .fill #0
DIV_R4_SAVE .fill #0
DIV_R7_SAVE .fill #0

ERROR .fill #-1
ZERO .fill #0


.END

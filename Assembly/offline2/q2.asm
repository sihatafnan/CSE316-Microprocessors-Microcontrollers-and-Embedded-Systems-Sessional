.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER PASSWORD: $' 
    VALID DB CR,LF,'VALID PASSWORD $'
    INVALID DB CR,LF,'INVALID PASSWORD $'
    NL DB CR,LF,'$'
    
.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    MOV BL,0     ;BL contaiins cnt of small letters
    MOV BH,0     ;BH contaiins cnt of capital letters
    MOV CL,0     ;CL contains cnt of digit
    
    MOV AH,1
    
    
WHILE_:   
    INT 21H
    CMP AL,21H
    JL END_WHILE
    CMP AL,7EH
    JG END_WHILE
    CMP AL,'A'
    JGE A_G
    JL A_L 
    JMP WHILE_
    

A_G:             ;found sth greater than "A"
    CMP AL,'Z'
    JLE CAP
    JG SM_CHK
A_L:              ;found sth less than "A"
    CMP AL,30H
    JGE DIGIT_CHK
    JL DO_NOTHING 
    
DIGIT_CHK:        ;less than "A" and chk for 0..9
    CMP AL,30H
    JGE DIGIT_CHK_FINAL
    JL DO_NOTHING
    
DIGIT_CHK_FINAL:   ;if digit or not
    CMP AL,39H
    JLE DIGIT
    JG DO_NOTHING
    
DIGIT:            ;found digit
    INC CL   
    JMP WHILE_
CAP:              ;found capital letter
    INC BH    
    JMP WHILE_
SM_CHK:           ;greater han "A" and chk for a..z
    CMP AL,61H
    JGE SM_CHECK_FINAL
    JL DO_NOTHING
    
SM_CHECK_FINAL:    ;if a..z or not
    CMP AL,7AH
    JLE SMALL
    JG DO_NOTHING
    
SMALL:            ;found small letter
    INC BL    
    JMP WHILE_

DO_NOTHING:   ;entered this lable means got a valid char except cap letter,small letter and digit
    JMP WHILE_        

END_WHILE:
    
    CMP BL,0
    JG SM_DONE
    JLE FAILED
    
SM_DONE:
    CMP BH,0
    JG SM_CP_DONE
    JLE FAILED
    
SM_CP_DONE:
    CMP CL,0
    JG SUCCESS
    JLE FAILED
    
SUCCESS:  
    LEA DX,VALID
    MOV AH,9
    INT 21H     
    JMP EXIT
    
FAILED:  
    LEA DX,INVALID
    MOV AH,9
    INT 21H 
    JMP EXIT


EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
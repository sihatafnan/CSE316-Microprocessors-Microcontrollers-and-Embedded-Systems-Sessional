.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER 1st NUMBER: $'
    MSG2 DB CR, LF, 'ENTER 2nd NUMBER: $'
    MSG3 DB CR, LF, 'ENTER 3rd NUMBER: $'
    EQUAL_MSG DB CR,LF, 'All the numbers are equal $'  
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

;input 1ST NUM     
    MOV AH, 1
    INT 21H
    MOV BL,AL
    
;PRINT USER PROMPT
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    
;input Y  
    MOV AH, 1
    INT 21H
    MOV BH,AL

;PRINT USER PROMPT
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  
    
;input Z  
    MOV AH, 1
    INT 21H
    MOV CL,AL
       
;NEWLINE
    LEA DX,NL
    MOV AH,9
    INT 21H
;CHECKING STARTS
    CMP BL,BH
    JE XYEQUAL
    JG XGY
    JL XLY      
    
XYEQUAL:
     CMP BH,CL
     JE EQUAL
     JL PRINT_BH
     JG PRINT_CL
     
     
EQUAL:
     LEA DX,EQUAL_MSG
     MOV AH,9
     INT 21H    
     JMP EXIT
XLY:
     CMP BH,CL
     JL PRINT_BH
     JE PRINT_BL
     JG XLY_YGZ
     
XGY:
     CMP BH,CL
     JG PRINT_BH
     JE PRINT_CL
     JL XGY_YLZ
   
XGY_YLZ:
     CMP BL,CL
     JE PRINT_BH
     JG PRINT_CL
     JL PRINT_BL


XLY_YGZ:
     CMP BL,CL
     JE PRINT_BL
     JG PRINT_BL
     JL PRINT_CL   
    
PRINT_BH:
     MOV AH,2
     MOV DL,BH
     INT 21H
     JMP EXIT
PRINT_CL:
     MOV AH,2
     MOV DL,CL
     INT 21H
     JMP EXIT   
PRINT_BL:
     MOV AH,2
     MOV DL,BL
     INT 21H
     JMP EXIT
      
    
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
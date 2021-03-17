.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER OPERAND1: $'   
    MSG2 DB CR,LF,'ENTER OPERATOR: $'
    MSG3 DB CR,LF,'ENTER OPERAND2: $'
    NL DB CR,LF,'$'  
    WRONG_OP DB CR,LF,'Wrong operator $'  
    SUM DW ?   
    OP DB ? 
    NUM1 DW ?
    NUM2 DW ?    
    ANS DW ?
    
.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H           
    
    CALL TAKE_INPUT ;AFTER CALLING , DX STORES THE NUMBER
           
    LEA DX, NL
    MOV AH, 9
    INT 21H  
    
    MOV DX , SUM
    MOV NUM1 , DX 
    
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    
    MOV AH,1
    INT 21H
    CMP AL , '+'
    JE PLUS
    CMP AL , '-'
    JE MINUS
    CMP AL , '*'
    JE MULTIPLY
    CMP AL  , '/'
    JE DIVIDE
    CMP AL , 'q'
    JE EXIT
    JL PRINT_EXIT
    JG PRINT_EXIT
   
PRINT_EXIT:
    LEA DX, WRONG_OP
    MOV AH, 9
    INT 21H     
    JMP EXIT
               
PLUS:
    MOV OP , AL
    JMP SECOND_INPUT    
MINUS:
    MOV OP , AL
    JMP SECOND_INPUT    
MULTIPLY:
        MOV OP , AL
        JMP SECOND_INPUT    
DIVIDE:
       MOV OP , AL
       JMP SECOND_INPUT    


SECOND_INPUT:  
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  
    
    CALL TAKE_INPUT
    MOV DX , SUM
    MOV NUM2 , DX
    JMP CALCULATE:
    
CALCULATE:
    MOV DX , NUM1
    MOV CX , NUM2        
    CMP OP , '+'
    JE ADD_
    CMP OP , '-'
    JE SUB_   
    CMP OP , '*'
    JE MUL_
    CMP OP , '/'
    JE DIV_
    
ADD_:
    ADD DX , CX
    MOV ANS , DX  
    JMP SHOW
SUB_:
    SUB DX , CX
    MOV ANS,DX
    JMP SHOW
MUL_:
    MOV AX , DX
    IMUL CX
    MOV ANS , AX
    JMP SHOW  
DIV_:
    MOV AX , DX
    IDIV CX
    MOV ANS , AX
    JMP SHOW  
    
SHOW:
    MOV BX , ANS   
    ;PUSH TO STACK
    BEGIN:
          TEST BX,8000H
          JNZ NEG_RESULT
          MOV AX,BX
          MOV DX , 10D
          DIV DX
          
    NEG_RESULT:
               
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

   
    
TAKE_INPUT PROC  
    
    
    MOV DX , 0   
    MOV AH,1 
    WHILE_:
           INT 21H  
           CMP AL , 0DH
           JE END_WHILE_
           CMP AL , 30H
           JL WHILE_
           CMP AL , 39H
           JLE FOUND
           JG WHILE_ 
    
    FOUND:
          MOV BH,0
          MOV BL,AL  
          SUB BX,30H
          PUSH BX 
          INC DX
          JMP WHILE_   
    
    END_WHILE_:
             
               MOV CX , DX
               MOV BX , 1D
               MOV SUM , 0D  
               
        CONVERT:  
        MOV AX,1
               CHK:
                   
                   POP DX 
                
                   MUL DX
              
                   ADD SUM , AX  
                   MOV AX , 10D
                   MUL BX
                   MOV BX,AX
                   
                   
                    
                   LOOP CHK
             
             
    
        
         RET        
                             
TAKE_INPUT ENDP    

 END MAIN    
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
    IS_NEGATIVE DB 0
    SUM DW ?      ;TO HOLD THE INPUT VALUE
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
           
    CALL NEWLINE
    
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

;SETTING OPERATOR               
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

;INPUT NUM2
SECOND_INPUT:  
    CALL NEWLINE
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  
    
    CALL TAKE_INPUT
    MOV DX , SUM
    MOV NUM2 , DX
    JMP CALCULATE:

;CALCULATE THE RESULT    
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
;RESULT STORED IN ANS    
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
    CWD
    IDIV CX
    MOV ANS , AX
    JMP SHOW   
    
;DISPLAY OUTPUT    
SHOW:   
    CALL NEWLINE  
    ;NUM1
    CALL LEFT_BRAC    
    MOV AX , NUM1   
    CALL OUTDEC
    CALL RIGHT_BRAC
    ;OPERATOR
    CALL LEFT_BRAC
    CALL OUT_OP   
    CALL RIGHT_BRAC
    ;NUM2
    CALL LEFT_BRAC
    MOV AX , NUM2   
    CALL OUTDEC 
    CALL RIGHT_BRAC
    ;EQUAL SIGN    
    CALL EQUAL 
    ;RESULT
    CALL LEFT_BRAC
    MOV AX , ANS
    CALL OUTDEC    
    CALL RIGHT_BRAC
                     
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

EQUAL PROC
    MOV AH,2
    MOV DL , "="
    INT 21H 
    RET
EQUAL ENDP

LEFT_BRAC PROC
    MOV AH,2
    MOV DL , "["
    INT 21H 
    RET
LEFT_BRAC ENDP
      
RIGHT_BRAC PROC
    MOV AH,2
    MOV DL , "]"
    INT 21H
    RET
RIGHT_BRAC ENDP

OUT_OP PROC
    MOV AH,2
    MOV DL , OP
    INT 21H
    RET
OUT_OP ENDP    
          
NEWLINE PROC
    LEA DX, NL
    MOV AH, 9
    INT 21H
    RET 
NEWLINE ENDP 

TAKE_INPUT PROC  
    MOV IS_NEGATIVE , 0
    MOV DX , 0   
    MOV AH,1 
    WHILE_:
           INT 21H
           CMP AL , '-'       ;FIRST CHK IF NEG NUMBER
           JE NEG_SIGN_FOUND  
           CMP AL , 0DH       ;END IF NEWLINE INPUT
           JE END_WHILE_
           CMP AL , 30H
           JL WHILE_
           CMP AL , 39H
           JLE FOUND
           JG WHILE_ 
    
    FOUND:               ;FOUND DIGIT,SO PUSH IN STACK
          MOV BH,0
          MOV BL,AL  
          SUB BX,30H
          PUSH BX 
          INC DX
          JMP WHILE_   
    
    NEG_SIGN_FOUND:
          MOV IS_NEGATIVE , 1D
          JMP WHILE_
            
    END_WHILE_:
             
               MOV CX , DX
               MOV BX , 1D
               MOV SUM , 0D  
               
        CONVERT:                ;POP FROM STACK AND CONVERT TO A DECIMAL NUMBER
        MOV AX,1
               CHK:
                   
                   POP DX 
                
                   MUL DX
              
                   ADD SUM , AX  
                   MOV AX , 10D
                   MUL BX
                   MOV BX,AX
                                                         
                   LOOP CHK   
                   
         CMP IS_NEGATIVE , 0
         JG MAKE_NEG
         JLE FINISHED
         MAKE_NEG:
                NEG SUM                                             
         FINISHED:
         
         RET        
                             
TAKE_INPUT ENDP     

OUTDEC PROC
   ; input : AX

   PUSH BX                       
   PUSH CX                      
   PUSH DX                       

   CMP AX, 0        ; compare AX with 0
   JGE POS_OUT  
                       ;IF AX <0
   PUSH AX                       
   MOV AH, 2                     
   MOV DL, "-"                 
   INT 21H                       
   POP AX                  
   NEG AX           ;take 2's complement of AX

   POS_OUT:                       

   XOR CX, CX                    
   MOV BX, 10                    

   PUSH_AX:                      
     XOR DX, DX                  
     DIV BX                       
     PUSH DX                  
     INC CX                     
     OR AX, AX                  
   JNE PUSH_AX        

   MOV AH, 2                    

   DISPLAY_AX:                    
     POP DX                      
     OR DL, 30H                  
     INT 21H                     
   LOOP DISPLAY_AX            

   POP DX                       
   POP CX                      
   POP BX                   

   RET                          
         
 END MAIN    
.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER MATRIX1: $'   
    MSG2 DB CR,LF,'ENTER MATRIX2: $'
    MSG3 DB CR,LF,'SUM OF TWO MATRIX: $',CR,LF    
    MSG4 DB CR,LF,'1ST ROW: $'
    MSG5 DB CR,LF,'2ND ROW: $'    
    
    MSG_ DB  '  $'
    
    NL DB CR,LF,'$'  
   
    
    M1 DB 4 DUP(?)
    M2 DB 4 DUP(?)   
    M3 DB 4 DUP(?)     
    SUM DB ?
   
    
    NUM2 DB ?    
    ANS DB ?
    
.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt    
;TAKE 1ST MATRIX
;1ST ROW
    LEA DX, MSG1
    MOV AH, 9
    INT 21H   
    
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    
    MOV CX , 2
    MOV SI , 1
    XOR BX,BX
    P1:
      LEA DX, MSG_
      MOV AH, 9
      INT 21H
      CALL TAKE_INPUT
      SUB AL,30H
      MOV M1[BX][SI] , AL
      ADD SI,1
      LOOP P1         
    
    ;2ND ROW
    LEA DX, MSG5
    MOV AH, 9
    INT 21H     
    
    MOV CX , 2
    MOV SI , 3
    XOR BX,BX
    P1_:
      LEA DX, MSG_
      MOV AH, 9
      INT 21H
      CALL TAKE_INPUT
      SUB AL,30H
      MOV M1[BX][SI] , AL
      ADD SI,1
      LOOP P1_    
    
    ;TAKE 2ND MATRIX
    ;1ST ROW
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    
    
    MOV CX , 2
    MOV SI , 1
    XOR BX,BX
    P2:
      LEA DX, MSG_
      MOV AH, 9
      INT 21H
      CALL TAKE_INPUT  
      SUB AL,30H
      MOV M2[BX][SI] , AL
      ADD SI,1
      LOOP P2    
   
    ;2ND ROW
    LEA DX, MSG5
    MOV AH, 9
    INT 21H
    
    MOV CX , 2
    MOV SI , 3
    XOR BX,BX
    P2_:
      LEA DX, MSG_
      MOV AH, 9
      INT 21H
      CALL TAKE_INPUT  
      SUB AL,30H
      MOV M2[BX][SI] , AL
      ADD SI,1
      LOOP P2_    
   
    
    ;ADDING
    
    MOV SI,1
    XOR BX,BX
    MOV CX,4  
    ADD_:   
    MOV AL, M1[BX][SI]
    MOV DL, M2[BX][SI]
    ADD AL,DL 
    MOV M3[BX][SI] , AL     
    ADD SI,1
    LOOP ADD_
    
    ;SHOW OUTPUT
    ;1ST ROW  
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    
    MOV SI,1
    XOR BX,BX
    MOV CX,2
    MOV AH,2 
    
    PR:     
    CALL SPACE
    MOV AH,00H
    MOV AL,M3[BX][SI] 
    CALL OUTDEC   
    ADD SI,1
    LOOP PR      
    ;2ND ROW    
    LEA DX, MSG5
    MOV AH, 9
    INT 21H
    
    MOV SI,3
    XOR BX,BX
    MOV CX,2
    MOV AH,2 
    
    PR_: 
    CALL SPACE   
    MOV AH,00H
    MOV AL,M3[BX][SI] 
    CALL OUTDEC   
    ADD SI,1
    LOOP PR_


                     
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

SPACE PROC
    LEA DX, MSG_
    MOV AH, 9
    INT 21H
    RET 
SPACE ENDP 
          
NEWLINE PROC
    LEA DX, NL
    MOV AH, 9
    INT 21H
    RET 
NEWLINE ENDP 

TAKE_INPUT PROC    
    MOV AH,1   
    int 21H
          
    RET        
                             
TAKE_INPUT ENDP     

OUTDEC PROC
   ; input : AX

   PUSH BX                       
   PUSH CX                      
   PUSH DX                       

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
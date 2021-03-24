.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER N: $'   
    SP_COM DB ' , $'
  
    NL DB CR,LF,'$'  
    SUM DW ?      ;TO HOLD THE INPUT VALUE 
    N DW ?
    A DW 100 DUP(0) ;ARRAY TO STORE RECURSION RESULTS
 
    
.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    CALL TAKE_INPUT
    MOV AX,SUM
   
    MOV CX , AX
    DEC AX
    ADD AX,AX
    PUSH AX
    
    CALL FIB    ;AFTER THIS CALL,A STORES FIB NUMBERS
     
    CALL NEWLINE
    
    MOV SI,0  
    MOV CX,SUM
    P:  
    
    MOV AX,A[SI]
    CALL OUTDEC  
    CALL SPACE_COMMA
    ADD SI,2
    
    LOOP P
;print user prompt
   
   
EXIT:
    MOV AH, 4CH
    INT 21H
  
SPACE_COMMA PROC
    LEA DX, SP_COM
    MOV AH, 9
    INT 21H
    RET 
SPACE_COMMA ENDP

;[BP+4] STORES THE INDICES OF ARRAY A 
;A[0]=0
;A[2]=1
;A[4]=1 ....
;IF THE INDEX IS 0 OR 2,THEN BASE CASES FOLLOWS
FIB PROC NEAR
    PUSH BP
    MOV BP,SP
    CMP [BP+4],0
    JE STORE_0
    JG NEXT
    
    NEXT:
         CMP WORD PTR[BP+4] , 2
         JE STORE_0_1
         JMP REAL
    
    STORE_0:
            MOV A[0] , 0D
            JMP ALU
    
    
    STORE_0_1:
            MOV A[0] , 0D
            MOV A[0+2] , 1D
            JMP ALU
            
    REAL:
         ;HERE,WE TAKE INDEX OF N-1 AND N-2 AND IF THEIR 
         ;CORRESSPONDING POSITION ISN'T FILLED UP YET,
         ;THEN CALL FIB AGAIN
         MOV CX , [BP+4] 
                  
         SUB CX,2
         MOV SI,CX 
         CMP A[SI] , 0
         JE NEWCALL
         JG SKIP
         NEWCALL:
         PUSH CX
         CALL FIB
         
         SKIP:
         MOV CX , [BP+4]
         SUB CX,4   
         MOV SI,CX 
         CMP A[SI] , 0
         JG SKIP_
         JG NEWCALL_
         
         
         NEWCALL_:
         PUSH CX 
         CALL FIB     
         
         ;FIB(N)=FIB(N-1)+FIB(N-2)
         SKIP_:
         MOV SI , [BP+4]
         MOV DI , [BP+4]
         SUB DI , 2
         MOV BX , DI
         SUB BX,2  
         MOV DX,A[DI]
         ADD A[SI] ,DX
         MOV DX,A[BX]
         ADD A[SI] , DX
         
     ALU:

         POP BP
         RET 2
         
      FIB ENDP   
         
            
NEWLINE PROC
    LEA DX, NL
    MOV AH, 9
    INT 21H
    RET 
NEWLINE ENDP 

TAKE_INPUT PROC  
    MOV DX , 0   
    MOV AH,1 
    WHILE_:
           INT 21H
           
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
.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER X: $'
    MSG2 DB CR, LF, 'ENTER Y: $'
    MSG3 DB CR, LF, 'Value of Z: $'
    X DW ?
    Y DW ?
    Z DW ?   

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;input X     
    MOV AH, 1
    INT 21H
    SUB AL, 30h
    MOV CL, AL
    MOV CH, 0h
    MOV X,  CX
    
;display on the next line
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    
;input Y  
    MOV AH, 1
    INT 21H
    SUB AL, 30h
    MOV BL, AL
    MOV BH, 0h
    MOV Y,  BX
    
;calculate Z = Y - X +1
    NEG CX
    ADD CX,1
    MOV X,CX 
    ADD BX,X
    MOV Z,BX  
    
;converting Z to decimal number    
    ADD Z,30h

;display on the next line
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  

;display Z    
    MOV AH, 2
    MOV DX, Z    
    INT 21H   
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
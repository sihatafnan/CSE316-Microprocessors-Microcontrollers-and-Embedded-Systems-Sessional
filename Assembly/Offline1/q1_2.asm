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
    MOV CL, AL
    MOV CH, 0h
    MOV Y,  CX
    
;calculate Z = 25 - (X+Y)
    ADD X,CX
    MOV CL, 25
    MOV CH, 0h
    SUB CX, X
    
    MOV Z,CX  
    
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
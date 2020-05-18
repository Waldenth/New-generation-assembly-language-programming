.MODEL SMALL 
.386
INOUT MACRO X,Y
	PUSH AX
	PUSH DX
	LEA DX,X
	MOV AH,Y
	INT 21H
	POP DX
	POP AX
	ENDM
DATAS SEGMENT
    ;此处输入数据段代码  
    BUF DD -0A62B89F0H,-739066ABH,11112222H,88889999H
    TIPS1 DB 'THE NO SIGNAL DEC NUMBER:',13,10,'$'
    TIPS2 DB 13,10,'THE SIGNAL DEC NUMBER:',13,10,'$'
    TIPS3 DB 13,10,'THE NO SIGNAL HEX NUMBER:',13,10,'$'
    TIPS4 DB 13,10,'THE SIGNAL HEX NUMBER:',13,10,'$'
    ENTERSTRING DB ' ','$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
   	
   	CALL DECNOSIGN
   	CALL DECSIGN
	CALL HEXNOSIGN
	CALL HEXSIGN
	 ;程序结束
    MOV AH,4CH
    INT 21H

DECNOSIGN PROC   	
   	INOUT TIPS1,9
   	MOV SI,0
   	L1:
   	PUSH SI
   	MOV EAX,BUF[SI]
   	XOR EDX,EDX
   	
   	L2:
   	MOV EDX,0
   	MOV ECX,10D
   	
   	DIV ECX
   	
   	PUSH EAX
   	PUSH EDX
   	
   	
   	ADD DL,30H
   	MOV AH,2
   	INT 21H
   	
   	POP EDX
   	POP EAX
  
   	CMP EAX,0
   	JNZ L2
   	INOUT ENTERSTRING,9
   	POP SI
   	INC SI
   	CMP SI,4
   	JNA L1
   	INOUT ENTERSTRING,9
   	RET
DECNOSIGN ENDP    
    


DECSIGN PROC   	
   	INOUT TIPS2,9
   	MOV SI,0
   	
   	L1:
   	PUSH SI
   	MOV EAX,BUF[SI]
   	OR EAX,EAX
   	JNS PLUS
   	MOV DL,'-'
   	MOV AH,2
   	INT 21H
   	PLUS:
   	XOR EDX,EDX
   	
   	L2:
   	MOV EDX,0
   	MOV ECX,10D
   	
   	DIV ECX
   	
   	PUSH EAX
   	PUSH EDX
   	
   	
   	ADD DL,30H
   	MOV AH,2
   	INT 21H
   	
   	POP EDX
   	POP EAX
  
   	CMP EAX,0
   	JNZ L2
   	INOUT ENTERSTRING,9
   	POP SI
   	INC SI
   	CMP SI,4
   	JNA L1
   	RET
DECSIGN ENDP    



HEXNOSIGN PROC   	
   	INOUT TIPS3,9
   	MOV SI,0
   	L1:
   	PUSH SI
   	MOV EAX,BUF[SI]
   	XOR EDX,EDX
   	
   	L2:
   	MOV EDX,0
   	MOV ECX,16D
   	
   	DIV ECX
   	
   	PUSH EAX
   	PUSH EDX
   	
   	
   	ADD DL,30H
   	CMP DL,39H
   	JNA NOCHAR
   	ADD DL,7
   	NOCHAR:
   	MOV AH,2
   	INT 21H
   	
   	POP EDX
   	POP EAX
  
   	CMP EAX,0
   	JNZ L2
   	INOUT ENTERSTRING,9
   	POP SI
   	INC SI
   	CMP SI,4
   	JNA L1
   	INOUT ENTERSTRING,9
   	RET
HEXNOSIGN ENDP    


HEXSIGN PROC   	
   	INOUT TIPS4,9
   	MOV SI,0
   	
   	L1:
   	PUSH SI
   	MOV EAX,BUF[SI]
   	OR EAX,EAX
   	JNS PLUS
   	MOV DL,'-'
   	MOV AH,2
   	INT 21H
   	PLUS:
   	XOR EDX,EDX
   	
   	L2:
   	MOV EDX,0
   	MOV ECX,16D
   	
   	DIV ECX
   	
   	PUSH EAX
   	PUSH EDX
   	
   	
   	ADD DL,30H
   	CMP DL,39H
   	JNA NOCHAR2
   	ADD DL,7
   	NOCHAR2:
   	MOV AH,2
   	INT 21H
   	
   	POP EDX
   	POP EAX
  
   	CMP EAX,0
   	JNZ L2
   	INOUT ENTERSTRING,9
   	POP SI
   	INC SI
   	CMP SI,4
   	JNA L1
   	RET
HEXSIGN ENDP        
    
   
CODES ENDS
    END START
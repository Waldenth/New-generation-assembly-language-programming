INOUT MACRO X,Y
	LEA DX,X
	MOV AH,Y
	INT 21H
	ENDM		;输入输出宏
DATAS SEGMENT
    ;此处输入数据段代码  
    A DW 1D,2D,3D,4D,5D,6D,23D,12D,13D,14D,15D,16D
	N11 = ($-A)/2
	N12 = ($-A)
	B DW 1,2,3,4,5,6,23,12,26,28,30,32,34,36,38,40
	N21 = ($-B)/2
	N22 = ($-B)
    CC DW  20 DUP(2 DUP(0))
	TIPS1 DB 'THE ARRAY OF A IS :',13,10,'$'
	TIPS2 DB 'THE ARRAY OF B IS :',13,10,'$'
	TIPS3 DB 'THE ARRAY OF C IS :',13,10,'$'
    TEMP DW 0000H
    ENTERSTRING DB 13,10,'$'
    
    STRR DB 9 DUP(' ')
	CHE DW 10000,1000,100,10,1
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DW 100 DUP(?)
	TOPS LABEL WORD
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    
    
    MOV AX,STACKS
	MOV SS,AX
	LEA SP,TOPS
    
    INOUT TIPS1,9
    MOV BX,0
    
   	L3:
    MOV AX,A[BX]
    LEA DI,STRR
	
	CALL CBD
    
    INC BX
    INC BX
   	CMP BX,N12
   	JNZ L3
    
    INOUT ENTERSTRING,9
    INOUT TIPS2,9
    MOV BX,0
    
   	L4:
    MOV AX,B[BX]
    LEA DI,STRR
	
	CALL CBD
    
    INC BX
    INC BX
   	CMP BX,N22
   	JNZ L4
    
    MOV SI,0
    MOV DI,0
    MOV DX,0
    
    L5:
    MOV AX,A[SI]
    MOV TEMP,AX
    INC SI
    INC SI
    MOV DI,0
    L6:
    MOV BX,B[DI]
    INC DI
    INC DI
    CMP TEMP,BX
    JNZ L7
    PUSH SI
    
    MOV SI,DX
    MOV CC[SI],BX
    
    POP SI
    INC DX
    INC DX
    L7:
    CMP DI,N22
    JNZ L6
    CMP SI,N12
    JNZ L5
    
    INOUT ENTERSTRING,9
    INOUT TIPS3,9
    	
    MOV SI,0
    MOV BX,DX
    
    L8:
    MOV AX,CC[SI]
    INC SI
    INC SI
    PUSH SI
    LEA SI,STRR
    CALL CBD
    POP SI
    CMP SI,16
    JNZ L8
    
    
    
    
    
    MOV AH,4CH
    INT 21H


CBD PROC 	;十进制调用子程序
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	PUSH DI
	
	LEA SI,CHE
	OR AX,AX
	JNS PLUS
	MOV BYTE PTR[DI],'-'
	INC DI
	NEG AX
PLUS:
	MOV CX,5
L1:
	MOV BX,[SI]
	MOV DX,0
	DIV BX
	ADD AL,30H
	MOV [DI],AL
	INC DI
	ADD SI,2
	MOV AX,DX
	LOOP L1
L2:
	MOV BYTE PTR[DI],20H
	INC DI
	MOV BYTE PTR[DI],'$'
	POP DX
	MOV AH,9
	INT 21H
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
CBD ENDP


CODES ENDS
    END START
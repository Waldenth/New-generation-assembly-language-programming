INOUT MACRO X,Y
	LEA DX,X
	MOV AH,Y
	INT 21H
	ENDM
	
DATAS SEGMENT
	INPUT1 DB 21,22 DUP(' ')
	CR01 DB 13,10,'$'
	INPUT2 DB 21,22 DUP(' ')
	CR02 DB 13,10,'$'
	MESSAGE DB 'PLEASE INPUT:',13,10,'$'
	RES1 DB 13,10,'THE STRING IS MATCH!',13,10,'$'
	RES2 DB 13,10,'THE STRING IS NOT MATCH!',13,10,'$'
DATAS ENDS

STACKS SEGMENT
    DB 256 DUP(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
	INOUT MESSAGE,9
	INOUT INPUT1,10
	XOR BX,BX
	MOV BL,INPUT1+1
	MOV INPUT1[BX+2],20H
	
	INOUT CR01,9
	
	INOUT MESSAGE,9
	INOUT INPUT2,10
	XOR BX,BX
	MOV BL,INPUT2+1
	MOV INPUT2[BX+2],20H
	
	MOV BL,INPUT1+1
	MOV BH,INPUT2+1
	CMP BL,BH
	JZ L2	;判断两个字符串长度是否相等
L1:	INOUT RES2,9
	JMP EXIT
L2:	
	LEA SI,INPUT1+2
	LEA DI,INPUT2+2
	XOR CX,CX
	MOV CL,BL
	CLD
	REPZ CMPSB
	JNZ L1
	INOUT RES1,9
EXIT:	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
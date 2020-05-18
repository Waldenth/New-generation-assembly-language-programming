.MODEL SMALL 
.386
INOUT MACRO X,Y
	PUSH DX
	PUSH AX
	LEA DX,X
	MOV AH,Y
	INT 21H
	POP AX
	POP DX
	ENDM
STACKS SEGMENT PARA STACK 'STACK'
	DB 256 DUP(' ')
STACKS ENDS

DATAS SEGMENT PARA PUBLIC 'DATA'
	ARRAY DD 20001008H,-20001002H,90001001H,10001005H,-80001000H,0AFFF8000H,0FFF6200H,-0F700500H
	LEN = ($-ARRAY)/4
	COUNT DD LEN-1
	RESULT DD 00000000H
	BUF DB 11 DUP(' '),2 DUP(' '),'$'
	BUF2 DB 11 DUP(' '),2 DUP(' '),'$'
	CONST DW 10000,1000,100,10,1
	TIPS1 DB 'THE ARRAY IS:',13,10,'$'
	ENTERS DB  13,10,'$'
	TIPS2 DB 'AFTER SORTED THE ARRAY IS:',13,10,'$'
DATAS ENDS

CODES SEGMENT PARA PUBLIC 'CODE'
	ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	MOV AX,DATAS
	MOV DS,AX

	INOUT TIPS1,9
	
	MOV SI,0
	MOV CX,LEN
LOOP1:	
	MOV EAX,ARRAY[SI]
	PUSH SI
	PUSH ECX
	MOV RESULT,EAX
	CALL CVD16
	LEA DX,BUF
	MOV AH,9
	INT 21H
	POP ECX
	POP SI
	ADD SI,4
	LOOP LOOP1
	
	
	
	
	
	
	CALL SORTP
	INOUT ENTERS,9
	INOUT TIPS2,9
	
	
	
	MOV SI,0
	MOV CX,LEN
LOOP2:	
	MOV EAX,ARRAY[SI]
	PUSH SI
	PUSH ECX
	MOV RESULT,EAX
	CALL CVD16
	LEA DX,BUF
	MOV AH,9
	INT 21H
	POP ECX
	POP SI
	ADD SI,4
	LOOP LOOP2
	
	
	
	
	

	;程序结束
	MOV AX,4C00H
	INT 21H
	
SORTP	PROC
		MOV SI,0
		MOV DI,OFFSET ARRAY
		MOV EBX,-1
LOOPOUT:
		CMP EBX,-1
		JNE SORTEND
		XOR EBX,EBX
		MOV ECX,COUNT
		MOV SI,DI
LOOPIN:
		MOV EAX,[SI]
		CMP AX,[SI+4]
		JLE NOCHANGE
		XCHG [SI+4],EAX
		MOV [SI],EAX
		MOV EBX,-1
NOCHANGE:
		ADD SI,4
		LOOP LOOPIN
		JMP LOOPOUT
SORTEND:
		RET
SORTP ENDP




CVD16 PROC
	MOV EAX,RESULT
	OR EAX,EAX
	JNS PLUS
	;NEG EAX
	;MOV BUF,'-'
	JMP ENDD
PLUS:
	;MOV BUF,'+'
ENDD:	
	MOV SI,10D
NOZERO:
	XOR EDX,EDX
	MOV ECX,16D
	DIV ECX
	ADD DL,30H
	CMP DL,39H
	JNA L3
	ADD DL,7
	L3:
	MOV BUF[SI],DL
	DEC SI
	CMP EAX,0
	JNZ NOZERO
	
	RET
CVD16 ENDP


CODES ENDS
	  END START		

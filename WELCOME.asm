DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	;打印WELCOME!
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    STRING DB 'WElCOME!' ',13,10,' '$'	;13使光标回到行首(ODH),10表示换行(0AH)
    	MOV AX,SEG STRING
    	MOV DS,AX
    	LEA DX,STRING
    	MOV AH,9
    	INT 21H
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

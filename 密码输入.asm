DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    ;密码输入程序,输入一个口令,显示*
    MOV AX,DATAS
    MOV DS,AX
    
    PASSWORD DB 10 DUP(0)
    	MOV CX,6	;设置保密口令需要的字符个数
    	MOV SI,0	;设置SI源变址器初值,数组开头[0]
    AGAIN:	MOV AH,7;将功能号设置为7,即不显示
    		INT 21H
    		MOV PASSWORD[SI],AL
    		MOV DL,'*'	;将DL寄存器传递为*,
    		MOV AH,2	;将DOS调用功能号设为2
    		INT 21H		;进行DOS调用
    		INC SI		;SI++
    		LOOP AGAIN    
    
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


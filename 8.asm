;.586
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
    TIPS1 DB 'PLEASE INPUT NUMBER',13,10,'$'
	TIPS2 DB 'THE RESULTS ARE AS FOLLOWS:',13,10,'$'
	TAB  DB 20 DUP(?)
	HBPX   DB 20 DUP(?)
	FIRST DW 5AH
	S1 DB " 0-99: $"
	S2 DB " 100-199: $"
	S3 DB " 200-299: $"
	S4 DB " 300-399: $"
	S5 DB " 400-499: $"
	S6 DB " 500-599: $"
	S7 DB " 600-699: $"
	S8 DB " 700-799: $"
	S9 DB " 800-899: $"
	S10 DB "900-999: $"
	PX DB "XSCJSC: $"
	MAX DB 0
	C1 DB 0              ; 统计0-9分、
	C2 DB 0              ; 统计10-19分区间
	C3 DB 0              ; 统计20-29分区间
	C4 DB 0              ; 统计30-39分区间
	C5 DB 0              ; 统计40-49分区间
	C6 DB 0              ; 统计50-59分以下
	C7 DB 0              ; 统计60-69分区间
	C8 DB 0              ; 统计70-79分区间
	C9 DB 0              ; 统计80-89分区间
	C10 DB 0              ; 统计90-100分区间的人数
	firs   DB  20				    ;预定义20字节的空间
       		DB  ?				    ;待输入完成后,自动获得输入的字符个数
       		DB  20  DUP(0)
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
    INOUT TIPS1,9
	LEA SI,TAB  
    CALL INPUT           ; 调用INPUT子程序（从键盘接受学生成绩）
    LEA SI,TAB
    INOUT TIPS2,9
	CALL COUNT           ; 调用COUNT子程序（统计各区间得分的人数）
    LEA SI,TAB
    ;CALL LAST            
    MOV AH,4CH
    INT 21H
    

INPUT PROC NEAR            ; 接受学生成绩的子程序
MOV CX,10				   ;10次输入
LP:  PUSH CX
     MOV AH,1              ; 1号功能调用
     INT 21H
     MOV CL,4
     SHL AL,CL             ; 逻辑左移，取十位上的数
     MOV BH,AL             ; 将十位上的数存入BH
     MOV AH,1              ; 1号功能调用
     INT 21H
     AND AL,0FH            ; 取个位上的数
     OR AL,BH              ; 得到分数
     MOV [SI],AL
     INC SI
     MOV AH,1              ; 1号功能调用
     INT 21H
     POP CX
     
	 
     CALL CRLF

     LOOP LP
     RET
INPUT ENDP

CALL CRLF


COUNT PROC NEAR           ; 统计各区间得分人数的子程序
LEA SI,TAB
MOV CX,10
LOP:  MOV AL,[SI]         ; 取分数
	  CMP AL,10H
      JB  T1
      CMP AL,20H
      JB  T2  
	  CMP AL,30H
      JB  T3              ; 60分以下，转到T1
      CMP AL,40H
      JB  T4              ; 70分以下，转到T2
      CMP AL,50H        
      JB  T5              ; 80分以下，转到T3
      CMP AL,60H        
      JB  T6              ; 90分以下，转到T4
      CMP AL,70H
      JB  T7              ; 60分以下，转到T1
      CMP AL,80H
      JB  T8              ; 70分以下，转到T2
      CMP AL,90H        
      JB  T9              ; 80分以下，转到T3
      
  
T10:   INC C10              ; 90-100分区间人数加1
      JMP NEXT
      
T9:   INC C9              ; 80-89分区间人数加1
      JMP NEXT
T8:   INC C8              ; 70-79分区间人数加1
      JMP NEXT
T7:   INC C7              ; 60-69分区间人数加1
      JMP NEXT
T6:   INC C6              ; 50-59分区间人数加1
	  JMP NEXT
T5:   INC C5              ; 40-49分区间人数加1
      JMP NEXT
T4:   INC C4              ; 30-39分区间人数加1
      JMP NEXT
T3:   INC C3              ; 20-29分区间人数加1
      JMP NEXT
T2:   INC C2              ; 10-19分区间人数加1
      JMP NEXT
T1:   INC C1              ; 0-9间人数加1

NEXT: INC SI              ; 下一分数
      LOOP LOP

CALL CRLF                 ; 回车换行
MOV DX,OFFSET S10          ; 输出100-90分区间的人数
MOV AH,09H
INT 21H

MOV DL,C10
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S9         ; 输出89-90分区间的人数
MOV AH,09H
INT 21H

MOV DL,C9
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S8          ; 输出79-70分区间的人数
MOV AH,09H
INT 21H

MOV DL,C8
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S7          ; 输出69-60分区间的人数
MOV AH,09H
INT 21H

MOV DL,C7
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S6          ; 输出60分以下区间的人数
MOV AH,09H
INT 21H
MOV DL,C6
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF
              
MOV DX,OFFSET S5          ; 输出100-90分区间的人数
MOV AH,09H
INT 21H

MOV DL,C5
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S4          ; 输出89-90分区间的人数
MOV AH,09H
INT 21H

MOV DL,C4
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S3          ; 输出79-70分区间的人数
MOV AH,09H
INT 21H

MOV DL,C3
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S2          ; 输出69-60分区间的人数
MOV AH,09H
INT 21H

MOV DL,C2
ADD DL,30H
MOV AH,02H
INT 21H
CALL CRLF

MOV DX,OFFSET S1          ; 输出60分以下区间的人数
MOV AH,09H
INT 21H

MOV DL,C1
ADD DL,30H
MOV AH,02H
INT 21H

CALL CRLF
RET
COUNT ENDP




CRLF PROC NEAR           ; 回车换行
MOV DL,0AH
MOV AH,02H
INT 21H
MOV DL,0DH
MOV AH,02H
INT 21H
RET
CRLF ENDP

    
CODES ENDS
    END START

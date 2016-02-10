.586
.model flat, stdcall
.stack 4096

option casemap : none

includelib msvcrt.lib

printf      PROTO C : ptr byte, : vararg
scanf       PROTO C : ptr byte, : vararg
gets		PROTO C : ptr byte
getchar		PROTO C
_getche		PROTO C
ExitProcess	PROTO, dwExitCode : DWORD; exit program
exit		equ <INVOKE ExitProcess, 0>

chr$ MACRO any_text : VARARG
LOCAL txtname
.data
IFDEF __UNICODE__
WSTR txtname, any_text
align 4
.code
EXITM <OFFSET txtname>
ENDIF
txtname db any_text, 0
align 4
.code
EXITM <OFFSET txtname>
ENDM

.data

count dword 10
val1 = 1
val2 =1
val3 = 0
fib  qword 0,1,1
REPEAT 10
	qword val1
	qword val2
	qword val3
val3=val2+val1
val1=val2
val2=val3

qword val3
ENDM
.code

main proc

mov edi, 0
printArray:
invoke printf, chr$("%d "), dword ptr fib[edi * 2]
inc edi
cmp edi, count
jl printArray


main	endp
end main

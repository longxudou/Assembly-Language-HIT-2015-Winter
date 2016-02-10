.586
.model flat, stdcall
.stack 4096
option	casemap : none

includelib msvcrt.lib

printf	PROTO C : ptr byte, : vararg
scanf	PROTO C : ptr byte, : vararg
getchar PROTO C
_getch	PROTO C
_getche	PROTO C
ExitProcess   PROTO : dword
exit	EQU		<invoke	ExitProcess, 0>

chr$ MACRO any_text : vararg
LOCAL textname
.const
textname db any_text, 0
ALIGN 4
.code
EXITM <OFFSET textname>
ENDM

.data
STRIN1 db "ABCDEFGHI"
STRIN2 db ?
count    dword ?
.code
main	proc


invoke scanf, chr$("%d"), offset count
invoke getchar

lea ebx, STRIN1
dec count
mov edi, count

invoke printf, chr$(0dh, 0ah, "当前队列内容为: %c"),dword ptr [ebx+edi]

invoke _getche

INVOKE  ExitProcess, 0
main	endp

end		main
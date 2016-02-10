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
Array sdword 100 dup(0)
count dword ?
.code

main proc


invoke printf, chr$("请输入数组元素的个数1~100：")
invoke scanf, chr$("%d"), offset count
invoke getchar


mov edi, 0
.while edi < count
	invoke  printf, chr$("请输入第%3d个元素", 0dh, 0ah), edi
	invoke  scanf, chr$("%d"), ADDR  Array[edi * 4]
	invoke	getchar

	add edi, 1
.endw



mov esi, 0
mov edi, 0

.while esi<count
	mov edi,0
	mov ebx,count
	sub ebx,esi
	dec ebx
	.while edi<ebx
		mov eax, Array[edi * 4]
		.if Array[edi * 4 + 4] < eax
			xchg eax, Array[edi * 4 + 4]
			mov Array[edi * 4], eax
		.endif
		inc edi
	.endw
	inc esi
.endw



invoke printf, chr$("数组排序结果为：")

mov edi, 0
printArray:
invoke printf, chr$("%d "), dword ptr Array[edi * 4]
inc edi
cmp edi, count
jl printArray

invoke _getche
exit

main	endp
end main

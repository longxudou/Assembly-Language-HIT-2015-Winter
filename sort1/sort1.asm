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
Array dword 100 dup(0)
count dword ?
.code

main proc


getcnt :
invoke printf, chr$("请输入数组元素的个数1~100：")
invoke scanf, chr$("%d"), offset count
invoke getchar


lea ebx, Array
mov edi, 0
getarray:
mov ecx, count
invoke  printf, chr$("请输入第%3d个元素", 0dh, 0ah), edi
invoke  scanf, chr$("%d"), ADDR[ebx + edi * 4]
invoke	getchar

add edi, 1
cmp edi, count
jl getarray



mov ecx, count
dec ecx
mov edi,0
L1 :
push ecx
lea ebx, Array
L2 :
mov eax, [ebx + edi * 4]
cmp[ebx + edi * 4 + 4], eax
jg L3
xchg eax, [ebx + edi * 4 + 4]
mov[ebx + edi * 4 ], eax
L3 :
inc edi
loop L2

add ebx,4
mov edi,0
pop ecx
loop L1

invoke printf, chr$("数组排序结果为：")
lea ebx, Array
mov edi, 0
printArray:
invoke printf, chr$("%d "), dword ptr[ebx + edi * 4]
inc edi
cmp edi, count
jl printArray

invoke _getche
exit

main	endp
end main

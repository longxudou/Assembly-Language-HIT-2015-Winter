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


mov edi, 0
getarray:
mov ecx, count
invoke  printf, chr$("请输入第%3d个元素", 0dh, 0ah), edi
invoke  scanf, chr$("%d"), ADDR  Array[edi * 4]
invoke	getchar

add edi, 1
cmp edi, count
jl getarray


mov ebx, count


xor esi, esi
L1 :
add esi,1
mov edi, 0
L2:
mov eax, Array[edi * 4]
cmp Array[edi * 4 + 4], eax
jg L3
xchg eax, Array[edi * 4 + 4]
mov Array[edi * 4], eax
L3 :
inc edi
mov eax,ebx
dec eax
cmp edi,eax
jl  L2
inc esi
cmp esi,ebx
jl L1




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

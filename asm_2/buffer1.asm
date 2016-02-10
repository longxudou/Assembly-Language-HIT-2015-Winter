.586
.model flat, stdcall
.stack 4096

option casemap : none

INCLUDELIB msvcrt.lib

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
	buf byte  16 dup(0)
	ip  dword 0
	op  dword 0
	n	dword 0
	chr byte  0
.code

iq proc
	push ebp
	mov ebp, esp

	push ebx
	push edx

	.if n == 16
		mov eax, 0
		jmp over
	.endif

	mov ebx, [ebp + 8]
	mov edx, [ebp + 12]
	mov eax, [edx]
	mov dl, [ebp + 16]
	mov[ebx + eax], dl

	push[ebp + 12]
	call incp

	inc n

	mov eax, 1

over:
	pop edx
	pop ebx
	mov esp, ebp
	pop ebp
	ret
iq endp

oq proc
	push ebp
	mov ebp, esp

	push ebx
	push edx

	.if n == 0
		mov eax, 0
		jmp @F
	.endif

	mov ebx, [ebp + 8]
	mov edx, [ebp + 12]
	mov eax, [edx]
	mov dl, [ebx + eax]
	mov eax, [ebp + 16]
	mov[eax], dl

	push[ebp + 12]
	call incp

	dec n

	mov eax, 1

@@:
	pop edx
	pop ebx
	mov esp, ebp
	pop ebp
	ret
oq endp

incp proc
	push ebp
	mov ebp, esp
	push ebx

	mov ebx, [ebp + 8]
	mov eax, [ebx]
	inc eax
	.if eax == 16
		mov eax, 0
	.endif

	mov[ebx], eax
	pop ebx
	mov esp, ebp
	pop ebp
	ret
incp endp

pq proc
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push esi
	push edi

	invoke printf, chr$("当前队列内容: ")
	mov ebx, [ebp + 8]
	mov esi, [ebp + 12]
	mov edi, [ebp + 16]
	mov ecx, n
	cmp ecx, 0
	jle @F
L1:
	mov al, [ebx + edi]
	push ecx
	invoke printf, chr$("%c"), al
	pop ecx
	inc edi
	.if edi == 16
		mov edi, 0
	.endif
	loop L1

@@:	
	mov ebx, [ebp + 16]
	invoke printf, chr$("队首下标为: %d"), ebx
	mov ebx, [ebp + 12]
	.if ebx != 0
		dec ebx
	.endif
	invoke printf, chr$("队尾下标为: %d", 0dh, 0ah), ebx

	mov eax, n
	pop edi
	pop esi
	pop ecx
	pop ebx
	mov esp, ebp
	pop ebp
	ret
pq endp



main proc
	invoke printf, chr$("请选择； ESC 退出； -从队列提取元素显示 +打印当前队列；0-9A-Z进入队列，其他抛弃", 0dh, 0ah)
start:
	invoke _getche
	cmp al, 1BH
	jz over
	cmp al, '+'
	jz printq
	cmp al, '-'
	jnz insert

	push offset chr
	push offset op
	push offset buf
	call oq
	add esp, 12

	.if eax != 0
		invoke printf, chr$("提取的元素为: %c", 0dh, 0ah), chr
	.else
		invoke printf, chr$("EMPTY!", 0dh, 0ah)
	.endif

jmp start

printq :
	push op
	push ip
	push offset buf
	call pq
	add esp, 12
	jmp start

insert :
	.if al >= 'A' && al <= 'Z' || al >= '0' && al <= '9'
		push eax
		push offset ip
		push offset buf
		call iq
		add esp, 12
		.if eax == 0
		invoke printf, chr$(0dh, 0ah, "FULL!", 0dh, 0ah)
		.endif
	.endif
	jmp start

over : exit

main endp
end main
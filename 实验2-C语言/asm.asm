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
incp		PROTO C : ptr dword


; PROTO C  iq, oq, pq
public C ip, op, buf, n, chr


ExitProcess	PROTO, dwExitCode:DWORD; exit program
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
buf		BYTE	16	dup(0)
ip		DWORD	0
op		DWORD	0
n		DWORD	0
chr		BYTE	0
.code
; PUBLIC iq, oq, pq
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

END	
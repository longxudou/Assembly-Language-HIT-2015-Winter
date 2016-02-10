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


iq	MACRO s, p, c
	local	iql, iov
	push	edi
	cmp	 n, 16
	jge	 iql

	mov	 edi, p
	mov	 s[edi], c
	pop	 edi
	incp   p
	inc	 n
	mov	 eax, 1;
	jmp    iov

	iql : mov eax, 0
	iov : pop edi
ENDM

oq MACRO s,p,c
	local iql,iov
	push edi
	cmp	 n,0
	je	 iql

	mov	 edi, p
	mov  dl,s[edi]
	mov  chr,dl
	pop	 edi
	incp   p
	dec	 n
	mov	 eax, 1;
	jmp   iov

	iql : mov eax, 0
	iov : pop edi
ENDM

incp MACRO  p
	inc	 p
	and	 p, 00000000FH
	ENDM

pq MACRO s,p,q
	local L1,L2,L3
	invoke printf, chr$("当前队列内容: ")
	push esi
	push edi
	push ecx
	mov esi,p
	mov edi,q
	mov ecx,n
	cmp ecx,0
	jle L2
L1:
	mov al,s[edi]
	push ecx
	invoke printf, chr$("%c"), al
	pop ecx
	inc edi
	cmp edi,16
	jnz L3
	mov edi,0
L3:	loop L1

L2: invoke printf, chr$("队首下标为: %d"), q
	invoke printf, chr$("队尾下标为: %d", 0dh, 0ah), p
	mov eax,n
	pop ecx
	pop	edi
	pop esi
ENDM

.data
	buf byte  16 dup(0)
	ip  dword 0
	op  dword 0
	n	dword 0
	chr byte  0

.code


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

	oq buf,op,chr
	.if eax != 0
		invoke printf, chr$("提取的元素为: %c", 0dh, 0ah),chr
	.else
		invoke printf, chr$("EMPTY!", 0dh, 0ah)
	.endif
	jmp start
printq:
	 pq buf,ip,op
	jmp start

insert:
	.if al >= 'A' && al <= 'Z' || al >= '0' && al <= '9'
		iq buf,ip,al
		.if eax == 0
			invoke printf, chr$(0dh, 0ah, "FULL!", 0dh, 0ah)
		.endif
	.endif
	jmp start
over :
	exit
main endp
end main
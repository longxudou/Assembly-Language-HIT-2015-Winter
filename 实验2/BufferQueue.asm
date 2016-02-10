TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

.586
.model flat,stdcall
.stack 4096

option casemap:none

includelib msvcrt.lib

printf      PROTO C :ptr byte,:vararg
scanf       PROTO C :ptr byte,:vararg
gets		PROTO C :ptr byte
getchar		PROTO C
_getche		PROTO C
incp		PROTO C
ExitProcess	PROTO,dwExitCode:DWORD	  	; exit program
exit		equ <INVOKE ExitProcess,0>

chr$ MACRO any_text:VARARG
        LOCAL txtname
        .data
          IFDEF __UNICODE__
            WSTR txtname,any_text
            align 4
            .code
            EXITM <OFFSET txtname>
          ENDIF
          txtname db any_text,0
          align 4
        .code
          EXITM <OFFSET txtname>
ENDM


.data
	buf		BYTE	16	dup	(0ffh)
	temp    DWORD   0
	ip		DWORD	0
	op		DWORD	0
	n		DWORD	0
	chr		BYTE	0
.code


iq PROC
		push ebp
		mov ebp,esp
		.IF n==16
			mov eax,0
		.ELSE
			inc n
			push esi
			push edi
			mov esi,ebp
			add esi,16
			mov edi,[ebp+8]
			add edi,ip
			movsb
			pop edi
			pop esi
			push [ebp+12]
			call incp
			mov eax,1
		.ENDIF
		pop ebp
		ret 12
	iq ENDP


oq PROC
		push ebp
		mov ebp,esp
		.IF n==0
			mov eax,0
		.ELSE
			dec n
			push ebx
			push esi
			push edi
			mov edi,[ebp+16]
			mov esi,[ebp+8]
			add esi,op
			movsb
			pop edi
			pop esi
			pop ebx

			push [ebp+12]
			call incp
			mov eax,1
		.ENDIF
		pop ebp
		ret
	oq ENDP


pq PROC
		push ebp
		mov ebp,esp

		invoke	printf,chr$(0ah,"当前队列内容: ")
		push esi
		push edi
		push ebx
		mov esi,0
		mov edi,op
		mov ebx,[ebp+8]
		.WHILE esi<n
			invoke	printf,chr$("%c "),BYTE ptr[ebx+edi]
			inc esi
			inc edi
			.IF edi==16
				mov edi,0
			.ENDIF
		.ENDW
		pop ebx
		pop edi
		pop esi
		invoke	printf,chr$("队首下标: ")
		invoke	printf,chr$("%d "),DWORD ptr[ebp+12]
		invoke	printf,chr$("队尾下标: ")
		invoke	printf,chr$("%d "),DWORD ptr[ebp+16]
		invoke	printf,chr$("元素个数: ")
		invoke	printf,chr$("%d ",0ah),n
		pop ebp
		ret 12
pq ENDP

END
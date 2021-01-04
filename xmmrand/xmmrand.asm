;calling convention
;parameters: rdi-rsi-rdx-rcx-r8-r9 - xmm0:xmm7
;return in: (rdx:)rax - (xmm1:)xmm0
;non-volatile: rbx-rbp-r12:r15
;volatile: r10-r11 - xmm8:xmm15

format ELF64

section '.text' executable align 16

public SetRandomSeed ;rdi->workspace_t* work
public RSUnif ;rdi->workspace_t* work - xmm0->a - xmm1->b


SetRandomSeed:
	align 16
	
	rdtsc
	mov dword [rdi], eax
	rol eax, 4
	mov dword [rdi+4], eax
	rol eax, 4
	mov dword [rdi+8], eax
	rol eax, 4
	mov dword [rdi+12], eax
        rol eax, 4
	mov dword [rdi+16], eax
	rol eax, 4
	mov dword [rdi+20], eax
	rol eax, 4
	mov dword [rdi+24], eax
	rol eax, 4
	mov dword [rdi+28], eax

	mov byte [rdi+40], 0	;state

	ret


RSUnif:
	align 16

	mov r8b, byte [rdi+40]	;state
	subsd xmm1, xmm0
	mulsd xmm1, qword [dueallamen63]
	test r8b, r8b
	jnz .mem

	movaps xmm7, xword [rdi]	;x
	movaps xmm5, xword [rdi+16]	;y
	movaps xword [rdi], xmm5	;work->s[0]=y
	movaps xmm4, xmm7
	psllq xmm4, 23		;x<<23
	pxor xmm4, xmm7		;x= x^(x<<23)

	movaps xmm6, xmm5	;y
	psrlq xmm6, 26		;y>>26
	pxor xmm6, xmm4		;(y>>26)^x
	psrlq xmm4, 17		;x>>17
	pxor xmm6, xmm5		;y^(y>>26)^x
	pxor xmm6, xmm4		;y^(y>>26)^x^(x>>17)

	movaps xword [rdi+16], xmm6	;y
	paddq xmm6, xmm5
	psrlq xmm6, 1

	movhpd qword [rdi+32], xmm6	;num
	;mov byte [rdi+40], 1		;state
	not byte [rdi+40]

	movq rax, xmm6
	cvtsi2sd xmm6, rax	;basso

	mulsd xmm6, xmm1
	addsd xmm0, xmm6

	ret

.mem:	mov rax, qword [rdi+32]	;num
	;mov byte [rdi+40], 0	;state
	not byte [rdi+40]

	cvtsi2sd xmm6, rax

	mulsd xmm6, xmm1
	addsd xmm0, xmm6

	ret


section '.data' writeable align 16

align 16
dueallamen63 dq 1.08420217248550804512609852693716619138442359673872e-19
;num dq 0
;state db 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;public xorshift128p ;rdi->workspace_t* work
;public xorshift128v ;rdi->workspace_t* work

;xorshift128p:
;	align 16
;	mov rsi, qword [rdi]	;*work
;	mov rcx, qword [rsi]	;x=work->s[0]
;	mov rdx, qword [rsi+8]	;y=work->s[1]
;	mov qword [rsi], rdx	;work->s[0]=y
;	mov r8, rcx
;	shl r8, 23	;x<<23
;	xor r8, rcx	;x= x^(x<<23)
;
;	mov r9, rdx     ;y
;	shr r9, 26      ;y>>26
;	xor r9, r8	;(y>>26)^x
;	shr r8, 17      ;x>>17
;	xor r9, rdx	;y^(y>>26)^x
;	xor r9, r8	;y^(y>>26)^x^(x>>17)
;
;	mov qword [rsi+8], r9	;work->s[1]=x^(x>>17)^(y>>26)^y
;	add r9, rdx
;	shr r9, 1
;
;	cvtsi2sd xmm0, r9
;	mulsd xmm0, qword [dueallamen63]
;
;	ret	
;
;
;xorshift128v:
;	align 16
;	mov rsi, qword [rdi]	;*work
;	movaps xmm1, xword [rsi]	;x
;	movaps xmm2, xword [rsi+16]	;y
;	movaps xword [rsi], xmm2	;work->s[0]=y
;	movaps xmm3, xmm1
;	psllq xmm3, 23		;x<<23
;	pxor xmm3, xmm1		;x= x^(x<<23)
;
;	movaps xmm0, xmm2	;y
;	psrlq xmm0, 26		;y>>26
;	pxor xmm0, xmm3		;(y>>26)^x
;	psrlq xmm3, 17		;x>>17
;	pxor xmm0, xmm2		;y^(y>>26)^x
;	pxor xmm0, xmm3		;y^(y>>26)^x^(x>>17)
;
;	movaps xword [rsi+16], xmm0
;	paddq xmm0, xmm2
;	psrlq xmm0, 1
;
;	movq rax, xmm0
;	pextrq rdx, xmm0, 1
;	movsd xmm2, qword [dueallamen63]
;	cvtsi2sd xmm0, rax	;basso
;	cvtsi2sd xmm1, rdx	;alto
;	mulsd xmm0, xmm2
;	mulsd xmm1, xmm2
;	movlhps xmm0, xmm1
;	;mulpd xmm0, xword [dueallamen63]
;	
;	ret


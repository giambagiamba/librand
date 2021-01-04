	.file	"random.c"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.globl	generate
	.type	generate, @function
generate:
.LFB67:
	.cfi_startproc
	lea	rcx, 32[rdi]
	sub	rsp, 8
	.cfi_def_cfa_offset 16
	mov	rdx, QWORD PTR 1048608[rdi]
	vmovdqa	xmm2, XMMWORD PTR 16[rdi]
	vmovdqa	xmm1, XMMWORD PTR [rdi]
	cmp	rcx, rdx
	je	.L11
	lea	rsi, 524288[rdx]
	vmovsd	xmm4, QWORD PTR .LC0[rip]
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L7:
	vmovdqa	xmm2, xmm3
.L5:
	vpsllq	xmm0, xmm1, 23
	add	rdx, 16
	vpxor	xmm0, xmm0, xmm1
	vpsrlq	xmm3, xmm2, 26
	vpsrlq	xmm1, xmm0, 17
	vpxor	xmm3, xmm3, xmm2
	vpxor	xmm0, xmm1, xmm0
	vpxor	xmm3, xmm3, xmm0
	vpaddq	xmm0, xmm2, xmm3
	vxorpd	xmm1, xmm1, xmm1
	vpsrlq	xmm0, xmm0, 1
	vmovq	rax, xmm0
	vcvtsi2sdq	xmm1, xmm1, rax
	vpextrq	rax, xmm0, 1
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sdq	xmm0, xmm0, rax
	vmulsd	xmm1, xmm1, xmm4
	vmulsd	xmm0, xmm0, xmm4
	vunpcklpd	xmm0, xmm1, xmm0
	vmovaps	XMMWORD PTR -16[rdx], xmm0
	vmovdqa	xmm1, xmm2
	cmp	rsi, rdx
	jne	.L7
	vmovaps	XMMWORD PTR [rdi], xmm2
	add	rdi, 1048664
	vmovaps	XMMWORD PTR -1048648[rdi], xmm3
	mov	QWORD PTR -56[rdi], rcx
	call	sem_post@PLT
	xor	eax, eax
	add	rsp, 8
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L11:
	.cfi_restore_state
	mov	rdx, rcx
	vmovsd	xmm4, QWORD PTR .LC0[rip]
	lea	rcx, 524320[rdi]
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L6:
	vmovdqa	xmm2, xmm0
.L3:
	vpsllq	xmm0, xmm1, 23
	vxorpd	xmm3, xmm3, xmm3
	add	rdx, 16
	vpxor	xmm1, xmm0, xmm1
	vpsrlq	xmm0, xmm1, 17
	vpxor	xmm0, xmm0, xmm1
	vpsrlq	xmm1, xmm2, 26
	vpxor	xmm1, xmm1, xmm2
	vpxor	xmm0, xmm0, xmm1
	vpaddq	xmm1, xmm2, xmm0
	vpsrlq	xmm1, xmm1, 1
	vmovq	rax, xmm1
	vcvtsi2sdq	xmm3, xmm3, rax
	vpextrq	rax, xmm1, 1
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vunpcklpd	xmm1, xmm3, xmm1
	vmovaps	XMMWORD PTR -16[rdx], xmm1
	vmovdqa	xmm1, xmm2
	cmp	rcx, rdx
	jne	.L6
	vmovaps	XMMWORD PTR [rdi], xmm2
	add	rdi, 1048632
	vmovaps	XMMWORD PTR -1048616[rdi], xmm0
	mov	QWORD PTR -24[rdi], rcx
	call	sem_post@PLT
	xor	eax, eax
	add	rsp, 8
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE67:
	.size	generate, .-generate
	.p2align 4,,15
	.globl	xorshift128plus
	.type	xorshift128plus, @function
xorshift128plus:
.LFB65:
	.cfi_startproc
	vmovdqa	xmm0, XMMWORD PTR [rdi]
	vmovdqa	xmm2, XMMWORD PTR 16[rdi]
	vpsllq	xmm1, xmm0, 23
	vpxor	xmm1, xmm1, xmm0
	vpsrlq	xmm0, xmm2, 26
	vmovaps	XMMWORD PTR [rdi], xmm2
	vpsrlq	xmm3, xmm1, 17
	vpxor	xmm0, xmm0, xmm2
	vpxor	xmm1, xmm3, xmm1
	vpxor	xmm1, xmm0, xmm1
	vmovaps	XMMWORD PTR 16[rdi], xmm1
	vpaddq	xmm1, xmm1, xmm2
	vpsrlq	xmm1, xmm1, 1
	vxorpd	xmm0, xmm0, xmm0
	vmovsd	xmm2, QWORD PTR .LC0[rip]
	vmovq	rax, xmm1
	vcvtsi2sdq	xmm0, xmm0, rax
	vpextrq	rax, xmm1, 1
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vmulsd	xmm0, xmm0, xmm2
	vmulsd	xmm1, xmm1, xmm2
	vunpcklpd	xmm0, xmm0, xmm1
	ret
	.cfi_endproc
.LFE65:
	.size	xorshift128plus, .-xorshift128plus
	.p2align 4,,15
	.globl	prepare
	.type	prepare, @function
prepare:
.LFB66:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	vmovdqa	ymm0, YMMWORD PTR .LC1[rip]
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r13
	vmovsd	xmm4, QWORD PTR .LC0[rip]
	push	rbx
	.cfi_offset 13, -24
	.cfi_offset 3, -32
	mov	rbx, rdi
	add	rdi, 32
	vmovups	XMMWORD PTR [rbx], xmm0
	vextractf128	XMMWORD PTR 16[rbx], ymm0, 0x1
	vmovdqa	xmm1, XMMWORD PTR [rbx]
	mov	rdx, rdi
	lea	rcx, 524320[rbx]
	vmovdqa	xmm2, XMMWORD PTR 16[rbx]
	jmp	.L14
	.p2align 4,,10
	.p2align 3
.L16:
	vmovdqa	xmm2, xmm0
.L14:
	vpsllq	xmm0, xmm1, 23
	vxorpd	xmm3, xmm3, xmm3
	add	rdx, 16
	vpxor	xmm0, xmm0, xmm1
	vpsrlq	xmm1, xmm0, 17
	vpxor	xmm0, xmm1, xmm0
	vpsrlq	xmm1, xmm2, 26
	vpxor	xmm1, xmm1, xmm2
	vpxor	xmm0, xmm0, xmm1
	vpaddq	xmm1, xmm0, xmm2
	vpsrlq	xmm1, xmm1, 1
	vmovq	rax, xmm1
	vcvtsi2sdq	xmm3, xmm3, rax
	vpextrq	rax, xmm1, 1
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vunpcklpd	xmm1, xmm3, xmm1
	vmovaps	XMMWORD PTR -16[rdx], xmm1
	vmovdqa	xmm1, xmm2
	cmp	rcx, rdx
	jne	.L16
	vmovaps	XMMWORD PTR [rbx], xmm2
	mov	rdx, rcx
	vmovaps	XMMWORD PTR 16[rbx], xmm0
	lea	rsi, 524288[rcx]
	jmp	.L15
	.p2align 4,,10
	.p2align 3
.L17:
	vmovdqa	xmm0, xmm5
.L15:
	vpsllq	xmm5, xmm2, 23
	vxorpd	xmm3, xmm3, xmm3
	add	rdx, 16
	vpxor	xmm2, xmm5, xmm2
	vpsrlq	xmm5, xmm0, 26
	vpsrlq	xmm1, xmm2, 17
	vpxor	xmm5, xmm5, xmm0
	vpxor	xmm2, xmm1, xmm2
	vpxor	xmm5, xmm5, xmm2
	vpaddq	xmm1, xmm0, xmm5
	vmovdqa	xmm2, xmm0
	vpsrlq	xmm1, xmm1, 1
	vmovq	rax, xmm1
	vcvtsi2sdq	xmm3, xmm3, rax
	vpextrq	rax, xmm1, 1
	vxorpd	xmm1, xmm1, xmm1
	vcvtsi2sdq	xmm1, xmm1, rax
	vmulsd	xmm3, xmm3, xmm4
	vmulsd	xmm1, xmm1, xmm4
	vunpcklpd	xmm1, xmm3, xmm1
	vmovaps	XMMWORD PTR -16[rdx], xmm1
	cmp	rdx, rsi
	jne	.L17
	mov	QWORD PTR 1048608[rbx], rdi
	xor	edx, edx
	xor	esi, esi
	mov	QWORD PTR 1048616[rbx], rdi
	lea	rdi, 1048632[rbx]
	vmovaps	XMMWORD PTR [rbx], xmm0
	vmovaps	XMMWORD PTR 16[rbx], xmm5
	mov	BYTE PTR 1048624[rbx], 0
	mov	QWORD PTR 1048696[rbx], rcx
	vzeroupper
	call	sem_init@PLT
	lea	rdi, 1048664[rbx]
	pop	rbx
	mov	edx, 1
	pop	r13
	xor	esi, esi
	pop	rbp
	.cfi_def_cfa 7, 8
	jmp	sem_init@PLT
	.cfi_endproc
.LFE66:
	.size	prepare, .-prepare
	.p2align 4,,15
	.globl	swbuf
	.type	swbuf, @function
swbuf:
.LFB68:
	.cfi_startproc
	cmp	BYTE PTR 1048624[rdi], 0
	lea	rax, 524320[rdi]
	je	.L21
	lea	rdx, 32[rdi]
	mov	QWORD PTR 1048696[rdi], rax
	add	rdi, 1048632
	mov	QWORD PTR -16[rdi], rdx
	mov	BYTE PTR -8[rdi], 0
	jmp	sem_wait@PLT
	.p2align 4,,10
	.p2align 3
.L21:
	mov	QWORD PTR 1048616[rdi], rax
	lea	rax, 1048608[rdi]
	add	rdi, 1048664
	mov	QWORD PTR 32[rdi], rax
	mov	BYTE PTR -40[rdi], 1
	jmp	sem_wait@PLT
	.cfi_endproc
.LFE68:
	.size	swbuf, .-swbuf
	.p2align 4,,15
	.globl	get
	.type	get, @function
get:
.LFB69:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, rdi
	mov	rax, QWORD PTR 1048616[rdi]
	cmp	rax, QWORD PTR 1048696[rdi]
	je	.L27
.L23:
	vmovsd	xmm0, QWORD PTR [rax]
	add	rax, 8
	mov	QWORD PTR 1048616[rbx], rax
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L27:
	.cfi_restore_state
	cmp	BYTE PTR 1048624[rdi], 0
	lea	rax, 524320[rdi]
	je	.L28
	lea	rdx, 32[rdi]
	mov	QWORD PTR 1048696[rdi], rax
	mov	QWORD PTR 1048616[rdi], rdx
	lea	rdi, 1048632[rdi]
	mov	BYTE PTR -8[rdi], 0
	call	sem_wait@PLT
.L25:
	lea	rdi, 1048704[rbx]
	mov	rcx, rbx
	xor	esi, esi
	lea	rdx, generate[rip]
	call	pthread_create@PLT
	mov	rax, QWORD PTR 1048616[rbx]
	jmp	.L23
	.p2align 4,,10
	.p2align 3
.L28:
	mov	QWORD PTR 1048616[rdi], rax
	lea	rax, 1048608[rdi]
	mov	QWORD PTR 1048696[rdi], rax
	lea	rdi, 1048664[rdi]
	mov	BYTE PTR -40[rdi], 1
	call	sem_wait@PLT
	jmp	.L25
	.cfi_endproc
.LFE69:
	.size	get, .-get
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"w"
.LC3:
	.string	"rand.dat"
.LC6:
	.string	"%.16le\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB70:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	lea	rsi, .LC2[rip]
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	lea	rdi, .LC3[rip]
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	sub	rsp, 1048736
	.cfi_def_cfa_offset 1048784
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR 1048728[rsp], rax
	xor	eax, eax
	call	fopen@PLT
	test	rax, rax
	je	.L30
	lea	r12, 16[rsp]
	mov	r14, rax
	mov	ebx, 100000000
	lea	r13, 1048704[r12]
	mov	rdi, r12
	xor	ebp, ebp
	call	prepare
	mov	rax, QWORD PTR 1048632[rsp]
	jmp	.L39
	.p2align 4,,10
	.p2align 3
.L31:
	vmovsd	xmm0, QWORD PTR [rax]
	add	rax, 8
	mov	QWORD PTR 1048632[rsp], rax
	cmp	rax, rdx
	je	.L48
.L34:
	vmovsd	xmm1, QWORD PTR [rax]
	vmulsd	xmm0, xmm0, xmm0
	add	rax, 8
	xor	edx, edx
	vmovsd	xmm2, QWORD PTR .LC4[rip]
	mov	QWORD PTR 1048632[rsp], rax
	vmulsd	xmm1, xmm1, xmm1
	vaddsd	xmm0, xmm0, xmm1
	vcomisd	xmm2, xmm0
	seta	dl
	add	ebp, edx
	sub	ebx, 1
	je	.L49
.L39:
	mov	rdx, QWORD PTR 1048712[rsp]
	cmp	rdx, rax
	jne	.L31
	cmp	BYTE PTR 1048640[rsp], 0
	je	.L50
	lea	rax, 32[r12]
	mov	BYTE PTR 1048640[rsp], 0
	mov	QWORD PTR 1048632[rsp], rax
	lea	rdi, 1048632[r12]
	lea	rax, 524320[r12]
	mov	QWORD PTR 1048712[rsp], rax
	call	sem_wait@PLT
.L33:
	lea	rdx, generate[rip]
	mov	rcx, r12
	xor	esi, esi
	mov	rdi, r13
	call	pthread_create@PLT
	mov	rdx, QWORD PTR 1048712[rsp]
	mov	rax, QWORD PTR 1048632[rsp]
	jmp	.L31
	.p2align 4,,10
	.p2align 3
.L48:
	cmp	BYTE PTR 1048640[rsp], 0
	vmovsd	QWORD PTR 8[rsp], xmm0
	je	.L51
	lea	rax, 32[r12]
	mov	BYTE PTR 1048640[rsp], 0
	mov	QWORD PTR 1048632[rsp], rax
	lea	rdi, 1048632[r12]
	lea	rax, 524320[r12]
	mov	QWORD PTR 1048712[rsp], rax
	call	sem_wait@PLT
	vmovsd	xmm0, QWORD PTR 8[rsp]
.L36:
	mov	rcx, r12
	xor	esi, esi
	mov	rdi, r13
	vmovsd	QWORD PTR 8[rsp], xmm0
	lea	rdx, generate[rip]
	call	pthread_create@PLT
	mov	rax, QWORD PTR 1048632[rsp]
	vmovsd	xmm0, QWORD PTR 8[rsp]
	jmp	.L34
	.p2align 4,,10
	.p2align 3
.L50:
	lea	rax, 524320[r12]
	mov	BYTE PTR 1048640[rsp], 1
	mov	QWORD PTR 1048632[rsp], rax
	lea	rdi, 1048664[r12]
	lea	rax, 1048608[r12]
	mov	QWORD PTR 1048712[rsp], rax
	call	sem_wait@PLT
	jmp	.L33
	.p2align 4,,10
	.p2align 3
.L51:
	lea	rax, 524320[r12]
	mov	BYTE PTR 1048640[rsp], 1
	mov	QWORD PTR 1048632[rsp], rax
	lea	rdi, 1048664[r12]
	lea	rax, 1048608[r12]
	mov	QWORD PTR 1048712[rsp], rax
	call	sem_wait@PLT
	vmovsd	xmm0, QWORD PTR 8[rsp]
	jmp	.L36
.L49:
	vxorpd	xmm0, xmm0, xmm0
	vcvtsi2sd	xmm0, xmm0, ebp
	mov	edi, 1
	vmulsd	xmm0, xmm0, QWORD PTR .LC5[rip]
	mov	eax, 1
	lea	rsi, .LC6[rip]
	call	__printf_chk@PLT
	mov	rdi, r14
	call	fclose@PLT
.L30:
	xor	eax, eax
	mov	rcx, QWORD PTR 1048728[rsp]
	xor	rcx, QWORD PTR fs:40
	jne	.L52
	add	rsp, 1048736
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	pop	rbx
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
.L52:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE70:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	15
	.long	1006632960
	.section	.rodata.cst32,"aM",@progbits,32
	.align 32
.LC1:
	.quad	1585020781899491925
	.quad	3463022101384604501
	.quad	-63050300919174571
	.quad	3463086880141099226
	.section	.rodata.cst8
	.align 8
.LC4:
	.long	0
	.long	1072693248
	.align 8
.LC5:
	.long	3794832442
	.long	1046837646
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits

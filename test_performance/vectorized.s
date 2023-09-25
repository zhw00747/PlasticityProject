	.file	"vectorized.cpp"
	.text
	.p2align 4
	.globl	_Z16add_c_style_simdPKdS0_Pdj
	.type	_Z16add_c_style_simdPKdS0_Pdj, @function
_Z16add_c_style_simdPKdS0_Pdj:
.LFB5498:
	.cfi_startproc
	endbr64
	testl	%ecx, %ecx
	je	.L8
	movl	%ecx, %ecx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L3:
	vmovupd	(%rdi,%rax,8), %ymm1
	vmulpd	(%rsi,%rax,8), %ymm1, %ymm0
	vmovupd	%ymm0, (%rdx,%rax,8)
	incq	%rax
	cmpq	%rax, %rcx
	jne	.L3
	vzeroupper
.L8:
	ret
	.cfi_endproc
.LFE5498:
	.size	_Z16add_c_style_simdPKdS0_Pdj, .-_Z16add_c_style_simdPKdS0_Pdj
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

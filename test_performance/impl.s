	.file	"impl.cpp"
	.text
	.p2align 4
	.globl	_Z11add_c_stylePKdS0_Pdj
	.type	_Z11add_c_stylePKdS0_Pdj, @function
_Z11add_c_stylePKdS0_Pdj:
.LFB15087:
	.cfi_startproc
	endbr64
	testl	%ecx, %ecx
	je	.L28
	leaq	8(%rsi), %r8
	movq	%rdx, %rax
	subq	%r8, %rax
	cmpq	$16, %rax
	seta	%r8b
	cmpl	$1, %ecx
	setne	%al
	testb	%al, %r8b
	je	.L3
	leaq	8(%rdi), %r8
	movq	%rdx, %rax
	subq	%r8, %rax
	cmpq	$16, %rax
	jbe	.L3
	leal	-1(%rcx), %eax
	cmpl	$2, %eax
	jbe	.L11
	movl	%ecx, %r8d
	shrl	$2, %r8d
	salq	$5, %r8
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L5:
	vmovupd	(%rdi,%rax), %ymm1
	vmulpd	(%rsi,%rax), %ymm1, %ymm0
	vmovupd	%ymm0, (%rdx,%rax)
	addq	$32, %rax
	cmpq	%r8, %rax
	jne	.L5
	movl	%ecx, %eax
	andl	$-4, %eax
	testb	$3, %cl
	je	.L26
	subl	%eax, %ecx
	cmpl	$1, %ecx
	je	.L30
	vzeroupper
.L4:
	movl	%eax, %r8d
	vmovupd	(%rdi,%r8,8), %xmm2
	vmulpd	(%rsi,%r8,8), %xmm2, %xmm0
	vmovupd	%xmm0, (%rdx,%r8,8)
	movl	%ecx, %r8d
	andl	$-2, %r8d
	addl	%r8d, %eax
	cmpl	%r8d, %ecx
	je	.L28
.L7:
	vmovsd	(%rdi,%rax,8), %xmm0
	vmulsd	(%rsi,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rdx,%rax,8)
	ret
	.p2align 4,,10
	.p2align 3
.L26:
	vzeroupper
.L28:
	ret
	.p2align 4,,10
	.p2align 3
.L3:
	movl	%ecx, %ecx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L9:
	vmovsd	(%rdi,%rax,8), %xmm0
	vmulsd	(%rsi,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rdx,%rax,8)
	incq	%rax
	cmpq	%rcx, %rax
	jne	.L9
	ret
.L11:
	xorl	%eax, %eax
	jmp	.L4
.L30:
	vzeroupper
	jmp	.L7
	.cfi_endproc
.LFE15087:
	.size	_Z11add_c_stylePKdS0_Pdj, .-_Z11add_c_stylePKdS0_Pdj
	.p2align 4
	.globl	_Z14add_std_vectorRKSt6vectorIdSaIdEES3_RS1_
	.type	_Z14add_std_vectorRKSt6vectorIdSaIdEES3_RS1_, @function
_Z14add_std_vectorRKSt6vectorIdSaIdEES3_RS1_:
.LFB15088:
	.cfi_startproc
	endbr64
	movq	(%rdi), %r8
	movq	8(%rdi), %rcx
	subq	%r8, %rcx
	sarq	$3, %rcx
	je	.L38
	movq	(%rsi), %rdi
	xorl	%eax, %eax
	movq	(%rdx), %rsi
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L33:
	vmovsd	(%r8,%rax,8), %xmm0
	vmulsd	(%rdi,%rax,8), %xmm0, %xmm0
	vmovsd	%xmm0, (%rsi,%rax,8)
	leal	1(%rdx), %eax
	movq	%rax, %rdx
	cmpq	%rcx, %rax
	jb	.L33
.L38:
	ret
	.cfi_endproc
.LFE15088:
	.size	_Z14add_std_vectorRKSt6vectorIdSaIdEES3_RS1_, .-_Z14add_std_vectorRKSt6vectorIdSaIdEES3_RS1_
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.ascii	"Ei"
	.string	"gen::DenseCoeffsBase<Derived, 0>::CoeffReturnType Eigen::DenseCoeffsBase<Derived, 0>::operator()(Eigen::Index) const [with Derived = Eigen::Matrix<double, -1, 1>; Eigen::DenseCoeffsBase<Derived, 0>::CoeffReturnType = const double&; Eigen::Index = long int]"
	.align 8
.LC1:
	.string	"/usr/include/eigen3/Eigen/src/Core/DenseCoeffsBase.h"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"index >= 0 && index < size()"
	.section	.rodata.str1.8
	.align 8
.LC3:
	.string	"Eigen::DenseCoeffsBase<Derived, 1>::Scalar& Eigen::DenseCoeffsBase<Derived, 1>::operator()(Eigen::Index) [with Derived = Eigen::Matrix<double, -1, 1>; Eigen::DenseCoeffsBase<Derived, 1>::Scalar = double; Eigen::Index = long int]"
	.text
	.p2align 4
	.globl	_Z16add_eigen_vectorRKN5Eigen6MatrixIdLin1ELi1ELi0ELin1ELi1EEES3_RS1_
	.type	_Z16add_eigen_vectorRKN5Eigen6MatrixIdLin1ELi1ELi0ELin1ELi1EEES3_RS1_, @function
_Z16add_eigen_vectorRKN5Eigen6MatrixIdLin1ELi1ELi0ELin1ELi1EEES3_RS1_:
.LFB15089:
	.cfi_startproc
	endbr64
	movq	8(%rdi), %r10
	testq	%r10, %r10
	jle	.L47
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rsi, %r9
	xorl	%ecx, %ecx
	movq	(%rdi), %rbx
	movq	8(%rsi), %r11
	xorl	%eax, %eax
	xorl	%esi, %esi
	.p2align 4,,10
	.p2align 3
.L43:
	vmovsd	(%rbx,%rax,8), %xmm0
	leaq	0(,%rax,8), %rdi
	cmpq	%rcx, %r11
	jle	.L50
	movq	(%r9), %r8
	vaddsd	(%r8,%rax,8), %xmm0, %xmm0
	cmpq	%rcx, 8(%rdx)
	jle	.L51
	movq	(%rdx), %rax
	vmovsd	%xmm0, (%rax,%rdi)
	leal	1(%rsi), %eax
	movq	%rax, %rsi
	movq	%rax, %rcx
	cmpq	%r10, %rax
	jl	.L43
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L47:
	.cfi_restore 3
	ret
.L51:
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	leaq	.LC3(%rip), %rcx
	movl	$427, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC2(%rip), %rdi
	call	__assert_fail@PLT
.L50:
	leaq	.LC0(%rip), %rcx
	movl	$181, %edx
	leaq	.LC1(%rip), %rsi
	leaq	.LC2(%rip), %rdi
	call	__assert_fail@PLT
	.cfi_endproc
.LFE15089:
	.size	_Z16add_eigen_vectorRKN5Eigen6MatrixIdLin1ELi1ELi0ELin1ELi1EEES3_RS1_, .-_Z16add_eigen_vectorRKN5Eigen6MatrixIdLin1ELi1ELi0ELin1ELi1EEES3_RS1_
	.section	.rodata.str1.1
.LC4:
	.string	"Elapset time = "
.LC6:
	.string	" sec\n"
	.section	.text.unlikely,"ax",@progbits
	.align 2
.LCOLDB8:
	.text
.LHOTB8:
	.align 2
	.p2align 4
	.globl	_ZNK5Timer16get_elapsed_timeB5cxx11Ev
	.type	_ZNK5Timer16get_elapsed_timeB5cxx11Ev, @function
_ZNK5Timer16get_elapsed_timeB5cxx11Ev:
.LFB15086:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA15086
	endbr64
	leaq	8(%rsp), %r10
	.cfi_def_cfa 10, 0
	andq	$-32, %rsp
	pushq	-8(%r10)
	pushq	%rbp
	movq	%rsp, %rbp
	.cfi_escape 0x10,0x6,0x2,0x76,0
	pushq	%r15
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	leaq	-464(%rbp), %r15
	pushq	%r14
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	leaq	-336(%rbp), %r14
	pushq	%r13
	pushq	%r12
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	movq	%rdi, %r12
	pushq	%r10
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	pushq	%rbx
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	movq	%rsi, %rbx
	subq	$448, %rsp
	vmovq	.LC7(%rip), %xmm2
	movq	%fs:40, %rax
	movq	%rax, -56(%rbp)
	xorl	%eax, %eax
	leaq	16+_ZTVSt15basic_streambufIcSt11char_traitsIcEE(%rip), %rax
	vpinsrq	$1, %rax, %xmm2, %xmm1
	vmovdqa	%xmm1, -480(%rbp)
	call	_ZNSt6chrono3_V212system_clock3nowEv@PLT
	subq	(%rbx), %rax
	movabsq	$2361183241434822607, %rdx
	movq	%rax, %rcx
	imulq	%rdx
	sarq	$63, %rcx
	movq	%r14, %rdi
	sarq	$7, %rdx
	movq	%rdx, %rbx
	subq	%rcx, %rbx
	movq	%r15, -496(%rbp)
	call	_ZNSt8ios_baseC2Ev@PLT
	leaq	16+_ZTVSt9basic_iosIcSt11char_traitsIcEE(%rip), %rax
	movq	%rax, -336(%rbp)
	xorl	%eax, %eax
	movw	%ax, -112(%rbp)
	movq	16+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %r13
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%ymm0, -104(%rbp)
	movq	-24(%r13), %rax
	movq	24+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rcx
	movq	$0, -120(%rbp)
	movq	%r13, -464(%rbp)
	movq	%rcx, -464(%rbp,%rax)
	movq	$0, -456(%rbp)
	xorl	%esi, %esi
	movq	-24(%r13), %rdi
	addq	%r15, %rdi
	vzeroupper
.LEHB0:
	call	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E@PLT
.LEHE0:
	movq	32+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	leaq	-448(%rbp), %r15
	movq	-24(%rax), %rdi
	movq	%rax, -448(%rbp)
	movq	40+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	addq	%r15, %rdi
	movq	%rax, (%rdi)
	xorl	%esi, %esi
.LEHB1:
	call	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E@PLT
.LEHE1:
	movq	8+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	48+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rdx
	movq	-24(%rax), %rax
	vmovdqa	-480(%rbp), %xmm1
	movq	%rdx, -464(%rbp,%rax)
	leaq	24+_ZTVNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	%rax, -464(%rbp)
	addq	$80, %rax
	movq	%rax, -336(%rbp)
	leaq	-384(%rbp), %rax
	vpxor	%xmm0, %xmm0, %xmm0
	movq	%rax, %rdi
	movq	$0, -400(%rbp)
	movq	$0, -392(%rbp)
	movq	%rax, -480(%rbp)
	vmovdqa	%xmm1, -448(%rbp)
	vmovdqa	%ymm0, -432(%rbp)
	vzeroupper
	call	_ZNSt6localeC1Ev@PLT
	leaq	16+_ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	%rax, -440(%rbp)
	leaq	-440(%rbp), %rsi
	leaq	-352(%rbp), %rax
	movq	%r14, %rdi
	movl	$24, -376(%rbp)
	movq	%rax, -488(%rbp)
	movq	%rax, -368(%rbp)
	movq	$0, -360(%rbp)
	movb	$0, -352(%rbp)
.LEHB2:
	call	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E@PLT
.LEHE2:
	movl	$15, %edx
	leaq	.LC4(%rip), %rsi
	movq	%r15, %rdi
.LEHB3:
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
	vxorps	%xmm0, %xmm0, %xmm0
	testq	%rbx, %rbx
	js	.L58
	vcvtsi2sdq	%rbx, %xmm0, %xmm0
.L59:
	movq	%r15, %rdi
	vdivsd	.LC5(%rip), %xmm0, %xmm0
	call	_ZNSo9_M_insertIdEERSoT_@PLT
	movq	%rax, %rdi
	movl	$5, %edx
	leaq	.LC6(%rip), %rsi
	call	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l@PLT
.LEHE3:
	movq	-400(%rbp), %rax
	leaq	16(%r12), %rbx
	movq	%rbx, (%r12)
	movq	$0, 8(%r12)
	movb	$0, 16(%r12)
	testq	%rax, %rax
	je	.L60
	movq	-416(%rbp), %r8
	testq	%r8, %r8
	je	.L75
	cmpq	%r8, %rax
	ja	.L75
.L61:
	movq	-408(%rbp), %rcx
	xorl	%edx, %edx
	subq	%rcx, %r8
	xorl	%esi, %esi
	movq	%r12, %rdi
.LEHB4:
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm@PLT
.L65:
	leaq	24+_ZTVNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	%rax, -464(%rbp)
	vmovq	.LC7(%rip), %xmm3
	addq	$80, %rax
	movq	%rax, -336(%rbp)
	movq	-368(%rbp), %rdi
	leaq	16+_ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE(%rip), %rax
	vpinsrq	$1, %rax, %xmm3, %xmm0
	vmovdqa	%xmm0, -448(%rbp)
	cmpq	-488(%rbp), %rdi
	je	.L64
	movq	-352(%rbp), %rax
	leaq	1(%rax), %rsi
	call	_ZdlPvm@PLT
.L64:
	movq	-480(%rbp), %rdi
	leaq	16+_ZTVSt15basic_streambufIcSt11char_traitsIcEE(%rip), %rax
	movq	%rax, -440(%rbp)
	call	_ZNSt6localeD1Ev@PLT
	movq	8+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	48+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rcx
	movq	-24(%rax), %rax
	movq	40+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rdx
	movq	%rcx, -464(%rbp,%rax)
	movq	32+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	24+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rbx
	movq	%rax, -448(%rbp)
	movq	-24(%rax), %rax
	movq	%r14, %rdi
	movq	%rdx, -448(%rbp,%rax)
	movq	-24(%r13), %rax
	movq	%r13, -464(%rbp)
	movq	%rbx, -464(%rbp,%rax)
	leaq	16+_ZTVSt9basic_iosIcSt11char_traitsIcEE(%rip), %rax
	movq	%rax, -336(%rbp)
	movq	$0, -456(%rbp)
	call	_ZNSt8ios_baseD2Ev@PLT
	movq	-56(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L84
	addq	$448, %rsp
	popq	%rbx
	popq	%r10
	.cfi_remember_state
	.cfi_def_cfa 10, 0
	movq	%r12, %rax
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	leaq	-8(%r10), %rsp
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L75:
	.cfi_restore_state
	movq	%rax, %r8
	jmp	.L61
	.p2align 4,,10
	.p2align 3
.L58:
	movq	%rbx, %rax
	shrq	%rax
	andl	$1, %ebx
	orq	%rbx, %rax
	vcvtsi2sdq	%rax, %xmm0, %xmm0
	vaddsd	%xmm0, %xmm0, %xmm0
	jmp	.L59
	.p2align 4,,10
	.p2align 3
.L60:
	leaq	-368(%rbp), %rsi
	movq	%r12, %rdi
	call	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_assignERKS4_@PLT
.LEHE4:
	jmp	.L65
.L84:
	call	__stack_chk_fail@PLT
.L74:
	endbr64
	movq	%rax, %r13
	jmp	.L66
.L70:
	endbr64
	movq	%rax, %r13
	vzeroupper
	jmp	.L68
.L73:
	endbr64
	movq	%rax, %rbx
	jmp	.L54
.L72:
	endbr64
	movq	%rax, %rbx
	jmp	.L56
.L71:
	endbr64
	movq	%rax, %rbx
	vzeroupper
	jmp	.L55
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA15086:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE15086-.LLSDACSB15086
.LLSDACSB15086:
	.uleb128 .LEHB0-.LFB15086
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L71-.LFB15086
	.uleb128 0
	.uleb128 .LEHB1-.LFB15086
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L73-.LFB15086
	.uleb128 0
	.uleb128 .LEHB2-.LFB15086
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L72-.LFB15086
	.uleb128 0
	.uleb128 .LEHB3-.LFB15086
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L70-.LFB15086
	.uleb128 0
	.uleb128 .LEHB4-.LFB15086
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L74-.LFB15086
	.uleb128 0
.LLSDACSE15086:
	.text
	.cfi_endproc
	.section	.text.unlikely
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDAC15086
	.type	_ZNK5Timer16get_elapsed_timeB5cxx11Ev.cold, @function
_ZNK5Timer16get_elapsed_timeB5cxx11Ev.cold:
.LFSB15086:
.L66:
	.cfi_escape 0xf,0x3,0x76,0x58,0x6
	.cfi_escape 0x10,0x3,0x2,0x76,0x50
	.cfi_escape 0x10,0x6,0x2,0x76,0
	.cfi_escape 0x10,0xc,0x2,0x76,0x60
	.cfi_escape 0x10,0xd,0x2,0x76,0x68
	.cfi_escape 0x10,0xe,0x2,0x76,0x70
	.cfi_escape 0x10,0xf,0x2,0x76,0x78
	movq	(%r12), %rdi
	cmpq	%rdi, %rbx
	je	.L82
	movq	16(%r12), %rsi
	incq	%rsi
	vzeroupper
	call	_ZdlPvm@PLT
.L68:
	movq	-496(%rbp), %rdi
	call	_ZNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEED1Ev@PLT
	movq	%r13, %rdi
.LEHB5:
	call	_Unwind_Resume@PLT
.L56:
	movq	-368(%rbp), %rdi
	leaq	16+_ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	%rax, -440(%rbp)
	cmpq	-488(%rbp), %rdi
	je	.L81
	movq	-352(%rbp), %rax
	leaq	1(%rax), %rsi
	vzeroupper
	call	_ZdlPvm@PLT
.L57:
	movq	-480(%rbp), %rdi
	leaq	16+_ZTVSt15basic_streambufIcSt11char_traitsIcEE(%rip), %rax
	movq	%rax, -440(%rbp)
	call	_ZNSt6localeD1Ev@PLT
	movq	8+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	48+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rcx
	movq	-24(%rax), %rax
	movq	%rcx, -464(%rbp,%rax)
	movq	32+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rax
	movq	40+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rcx
	movq	%rax, -448(%rbp)
	movq	-24(%rax), %rax
	movq	%rcx, -448(%rbp,%rax)
	movq	-24(%r13), %rax
	movq	24+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rcx
	movq	%r13, -464(%rbp)
	movq	%rcx, -464(%rbp,%rax)
	movq	$0, -456(%rbp)
.L55:
	leaq	16+_ZTVSt9basic_iosIcSt11char_traitsIcEE(%rip), %rax
	movq	%r14, %rdi
	movq	%rax, -336(%rbp)
	call	_ZNSt8ios_baseD2Ev@PLT
	movq	%rbx, %rdi
	call	_Unwind_Resume@PLT
.LEHE5:
.L54:
	movq	-24(%r13), %rax
	movq	24+_ZTTNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE(%rip), %rcx
	movq	%r13, -464(%rbp)
	movq	%rcx, -464(%rbp,%rax)
	movq	$0, -456(%rbp)
	vzeroupper
	jmp	.L55
.L82:
	vzeroupper
	jmp	.L68
.L81:
	vzeroupper
	jmp	.L57
	.cfi_endproc
.LFE15086:
	.section	.gcc_except_table
.LLSDAC15086:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSEC15086-.LLSDACSBC15086
.LLSDACSBC15086:
	.uleb128 .LEHB5-.LCOLDB8
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
.LLSDACSEC15086:
	.section	.text.unlikely
	.text
	.size	_ZNK5Timer16get_elapsed_timeB5cxx11Ev, .-_ZNK5Timer16get_elapsed_timeB5cxx11Ev
	.section	.text.unlikely
	.size	_ZNK5Timer16get_elapsed_timeB5cxx11Ev.cold, .-_ZNK5Timer16get_elapsed_timeB5cxx11Ev.cold
.LCOLDE8:
	.text
.LHOTE8:
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.type	_GLOBAL__sub_I__ZNK5Timer16get_elapsed_timeB5cxx11Ev, @function
_GLOBAL__sub_I__ZNK5Timer16get_elapsed_timeB5cxx11Ev:
.LFB16104:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	_ZStL8__ioinit(%rip), %rbp
	movq	%rbp, %rdi
	call	_ZNSt8ios_base4InitC1Ev@PLT
	movq	_ZNSt8ios_base4InitD1Ev@GOTPCREL(%rip), %rdi
	movq	%rbp, %rsi
	leaq	__dso_handle(%rip), %rdx
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	__cxa_atexit@PLT
	.cfi_endproc
.LFE16104:
	.size	_GLOBAL__sub_I__ZNK5Timer16get_elapsed_timeB5cxx11Ev, .-_GLOBAL__sub_I__ZNK5Timer16get_elapsed_timeB5cxx11Ev
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__ZNK5Timer16get_elapsed_timeB5cxx11Ev
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC5:
	.long	0
	.long	1093567616
	.section	.data.rel.ro,"aw"
	.align 8
.LC7:
	.quad	_ZTVNSt7__cxx1118basic_stringstreamIcSt11char_traitsIcESaIcEEE+64
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.rel.local.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align 8
	.type	DW.ref.__gxx_personality_v0, @object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.quad	__gxx_personality_v0
	.hidden	__dso_handle
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

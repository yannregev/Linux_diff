.text
	i:	.asciz "-i"
	B:	.asciz "-B"
.global _load_arguments
_load_arguments:
	pushq %rbp
	movq %rsp, %rbp
	subq $48, %rsp
	movq $0, (%rdx)
	movq $0, (%rcx)
	movq %rsi, -8(%rbp)
	movq $1, -16(%rbp)
	movq %rdi, -24(%rbp)
	movq %rdx, -32(%rbp)
	movq %rcx, -40(%rbp)	
_load_arguments_loop0:
	movq -16(%rbp), %rbx
	incq -16(%rbp)
	movq -24(%rbp), %rdi
	cmpq %rdi, %rbx
	je _load_arguments_end
	movq -8(%rbp), %rsi
	movq (%rsi, %rbx, 8), %rdi
	leaq i(%rip), %rsi
	call _strcmp
	jne _load_argument_not_i
	movq -32(%rbp), %rdx
	movq $1, (%rdx)
_load_argument_not_i:
	movq -8(%rbp), %rsi
	movq (%rsi, %rbx, 8), %rdi
	leaq B(%rip), %rsi
	call _strcmp
	jne _load_arguments_loop0
	movq -40(%rbp), %rcx
	movq $1, (%rcx)
	jmp _load_arguments_loop0

_load_arguments_end:
	addq $16, %rsp
	movq %rbp, %rsp
	popq %rbp
	retq


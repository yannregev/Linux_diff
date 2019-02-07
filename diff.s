.text
	changed: .asciz "\n%dc%d\n< %s\n------\n> %s\n"
	error:	.asciz "Could not open files\n"
	r:	.asciz "r"
.global _main
_main:
	pushq %rbp
	movq %rsp, %rbp
	subq $96, %rsp			# char *text, *text1;
					# size_t line;

	movq %rdi, -8(%rbp)
	movq %rsi, -16(%rbp)

	cmpq $2, %rdi
	jle _error

	movq 8(%rsi), %rdi
	leaq r(%rip), %rsi
	xorq %rax, %rax
	call _fopen
	cmpq $0x0, %rax
	je _error

	movq %rax, -24(%rbp)	# FILE *ptr1

	movq -8(%rbp), %rdi
	movq -16(%rbp), %rsi
	movq 16(%rsi), %rdi
	leaq r(%rip), %rsi
	xorq %rax, %rax
	call _fopen
	cmpq $0x0, %rax
	je _error

	movq %rax, -32(%rbp)	# FILE *ptr2

	movq -8(%rbp), %rdi
	subq $2, %rdi
	movq -16(%rbp), %rsi
	addq $16, %rsi

	leaq -72(%rbp), %rdx
	leaq -80(%rbp), %rcx
	call _load_arguments

	movq $0, -8(%rbp)
	movq -24(%rbp), %rdi
	movq %rdi, -24(%rbp)
	movq $0, -16(%rbp)
	movq -32(%rbp), %rdi
	movq %rdi, -48(%rbp)
	movq $0, -32(%rbp)
	movq $0, -40(%rbp)
	
	movq $0, -64(%rbp)
_main_cmp_loop0:
	incq -64(%rbp)
while_empty1:
	leaq -8(%rbp), %rdi
	leaq -16(%rbp), %rsi
	movq -24(%rbp), %rdx
	call _my_getline
	movq %rax, -56(%rbp)
	cmpq $1, -80(%rbp)
	jne end_while1
	cmpq $0, %rax
	je while_empty1
end_while1:

while_empty2:
	leaq -32(%rbp), %rdi
	leaq -40(%rbp), %rsi
	movq -48(%rbp), %rdx
	call _my_getline
	movq %rax, -88(%rbp)
	cmpq $1, -80(%rbp)
	jne end_while2
	cmpq $0, %rax
	je while_empty2
end_while2:

	cmpq $-1, -56(%rbp)
	jg _main_not_end
	cmpq $-1, -88(%rbp)
	jle _exit
_main_not_end:

	movq -8(%rbp), %rdi
	movq -32(%rbp), %rsi
	xorq %rax, %rax
	cmpq $1, -72(%rbp)
	jne _main_not_case_sensitive
_main_case_sensitive:
	call _strcasecmp
	jmp _end_compare
_main_not_case_sensitive:
	call _strcmp
_end_compare:
	cmpq $0, %rax
	je _main_cmp_loop0

	leaq changed(%rip), %rdi
	movq -64(%rbp), %rsi
	movq -64(%rbp), %rdx
	movq -8(%rbp), %rcx
	movq -32(%rbp), %r8
	xorq %rax, %rax
	call _printf

	jmp _main_cmp_loop0
_error:
	leaq error(%rip), %rdi
	xorq %rax, %rax
	call _printf
_exit:
	addq $96, %rsp
	movq %rbp, %rsp
	popq %rbp
	retq


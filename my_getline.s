.global _my_getline
_my_getline:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	leaq (%rdi), %rbx
	call _getline
	movq (%rbx), %rbx
	movq %rax, -16(%rbp)
	decq %rax
	cmpb $'\n', (%rbx, %rax)
	jne else0
if0:
	movb $' ', (%rbx, %rax)
	decq -16(%rbp)
	jmp end
else0:
	cmpq $0, %rax
	jg else1
if1:
	incq %rax
	movb $' ', (%rbx, %rax)
	incq %rax
	movb $0, (%rbx, %rax)
else1:
end:
	movq -16(%rbp), %rax
	movq %rbp, %rsp
	popq %rbp
	retq

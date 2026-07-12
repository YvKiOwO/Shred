section .data
	msg_entry	db "Entry Point: 0x"
	len_entry	equ $ - msg_entry
	hex_digits	db "0123456789abcdef"
	newline		db 10

section .bss
	statbuf		resb 144

section .text
	global _start

_start:
	pop rax
	cmp rax, 2
	jl .exit
	pop rax
	pop rdi

	mov rax, 2
	mov rsi, 0
	syscall

	cmp rax, 0
	jle .exit
	mov r8, rax

	mov rdi, r8
	mov rax, 5
	mov rsi, statbuf
	syscall

	mov rdi, 0
	mov rsi, [statbuf + 48]
	mov rdx, 1
	mov r10, 2
	mov r8, r8
	mov r9, 0
	mov rax, 9
	syscall

	cmp rax, 0
	jle .exit
	mov r9, rax

	cmp dword [r9], 0x464c457f
	jne .exit

	mov rax, 1
	mov rdi, 1
	mov rsi, msg_entry
	mov rdx, len_entry
	syscall

	mov rbx, [r9 + 0x18]
	mov rcx, 16

.loop:
	rol rbx, 4
	mov rax, rbx
	and rax, 0xF
	mov al, [hex_digits + rax]
	push rcx
	push rbx

	mov [rsp-8], al
	mov rax, 1
	mov rdi, 1
	lea rsi, [rsp-8]
	mov rdx, 1
	syscall

	pop rbx
	pop rcx
	loop .loop

	mov rax, 1
	mov rdi, 1
	mov rsi, newline
	mov rdx, 1
	syscall

.exit:
	mov rax, 60
	xor rdi, rdi
	syscall

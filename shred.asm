section .data
	msg_start	db "[!] ANALYSIS COMPLETE", 10
	len_start	equ $ - msg_start
	msg_wx		db "[!] Self-modifying segments: DETECTED", 10
	len_wx		equ $ - msg_wx
	msg_clean	db "[!] Conclusion: BINARY CLEAN", 10
	len_clean	equ $ - msg_clean
	msg_lock 	db "[!] Conclusion: PROPRIETARY LOCKDOWN DETECTED", 10
	len_lock	equ $ - msg_lock

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
	mov r9, 0
	mov rax, 9
	syscall
	mov r9, rax

	cmp dword [r9], 0x464c457f
	jne .exit

	mov rax, [r9 + 0x20]
	add rax, r9
	movzx rcx, word [r9 + 0x38]

.next_header:
	mov edx, [rax + 0x4]

	and edx, 0x3
	cmp edx, 0x3
	je .found_wx

	add rax, 56
	loop .next_header
	jmp .clean_exit

.found_wx:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_wx
	mov rdx, len_wx
	syscall

.done_scan:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_lock
	mov rdx, len_lock
	syscall
	jmp .exit

.clean_exit:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_clean
	mov rdx, len_clean
	syscall
	jmp .exit

.exit:
	mov rax, 60
	xor rdi, rdi
	syscall

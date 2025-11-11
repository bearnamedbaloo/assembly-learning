; skeleton.asm - Template for new labs
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - [Concept 1]
; - [Concept 2]

section .data
    ; Define your data here
    ; Example: msg db "Hello", 10
    ; Example: num dq 42

section .bss
    ; Define uninitialized data here
    ; Example: buffer resb 64

section .text
    global _start

_start:
    ; Your code here

    ; Exit the program
    mov rax, 60         ; syscall number for sys_exit
    mov rdi, 0          ; exit status 0 (success)
    syscall             ; invoke the kernel

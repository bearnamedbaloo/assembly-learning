; hello.asm - Classic "Hello, world!" using Linux syscalls
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - Basic program structure
; - Linux syscall convention (syscall instruction)
; - sys_write (syscall 1) and sys_exit (syscall 60)
; - String data in .data section

section .data
    ; Define our message with a newline
    msg db "Hello, world!", 10    ; 10 is ASCII for newline (\n)
    msg_len equ $ - msg            ; Calculate length of message

section .text
    global _start

_start:
    ; sys_write(fd, buf, count)
    ; syscall number 1 (sys_write)
    ; rdi = file descriptor (1 = stdout)
    ; rsi = pointer to buffer
    ; rdx = number of bytes to write
    mov rax, 1          ; syscall number for sys_write
    mov rdi, 1          ; file descriptor 1 (stdout)
    mov rsi, msg        ; address of string to write
    mov rdx, msg_len    ; number of bytes
    syscall             ; invoke the kernel

    ; sys_exit(status)
    ; syscall number 60 (sys_exit)
    ; rdi = exit status code
    mov rax, 60         ; syscall number for sys_exit
    mov rdi, 0          ; exit status 0 (success)
    syscall             ; invoke the kernel

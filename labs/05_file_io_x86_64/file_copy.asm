; file_copy.asm - Copy file and count bytes
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - File operations (open, read, write, close)
; - Error handling
; - Buffer management
; - sys_open, sys_read, sys_write, sys_close syscalls

DEFAULT REL                 ; Use RIP-relative addressing by default (recommended for modern code)

section .data
    ; Input and output filenames
    input_file db "input.txt", 0
    output_file db "output.txt", 0

    ; Messages
    msg_success db "File copied successfully!", 10
    msg_success_len equ $ - msg_success

    msg_bytes db "Bytes copied: ", 0
    msg_bytes_len equ $ - msg_bytes

    msg_error_open db "Error: Could not open file", 10
    msg_error_open_len equ $ - msg_error_open

    msg_error_read db "Error: Could not read file", 10
    msg_error_read_len equ $ - msg_error_read

    msg_error_write db "Error: Could not write file", 10
    msg_error_write_len equ $ - msg_error_write

    newline db 10

section .bss
    buffer resb 4096        ; 4KB buffer for reading/writing
    num_buffer resb 20      ; Buffer for number conversion
    total_bytes resq 1      ; Total bytes copied

section .text
    global _start

_start:
    ; Initialize total bytes counter
    mov qword [total_bytes], 0

    ; Open input file for reading
    ; sys_open(filename, flags, mode)
    ; flags: O_RDONLY = 0
    mov rax, 2              ; sys_open
    mov rdi, input_file     ; filename
    mov rsi, 0              ; O_RDONLY (read-only)
    mov rdx, 0              ; mode (not needed for reading)
    syscall

    ; Check for error
    cmp rax, 0
    jl .error_open          ; If rax < 0, error occurred

    mov r12, rax            ; Save input file descriptor

    ; Open/create output file for writing
    ; flags: O_WRONLY | O_CREAT | O_TRUNC = 1 | 64 | 512 = 577 (0x241)
    ; mode: 0644 (rw-r--r--) = octal 644 = decimal 420 = hex 0x1A4
    mov rax, 2              ; sys_open
    mov rdi, output_file    ; filename
    mov rsi, 577            ; O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, 0o644          ; Octal permissions (0o prefix for octal in NASM)
    syscall

    ; Check for error
    cmp rax, 0
    jl .error_open

    mov r13, rax            ; Save output file descriptor

.read_loop:
    ; Read from input file
    ; sys_read(fd, buffer, count)
    mov rax, 0              ; sys_read
    mov rdi, r12            ; input file descriptor
    mov rsi, buffer         ; buffer to read into
    mov rdx, 4096           ; max bytes to read
    syscall

    ; Check for error or EOF
    cmp rax, 0
    jl .error_read          ; Error if rax < 0
    je .close_files         ; EOF if rax == 0

    mov r14, rax            ; Save number of bytes read

    ; Add to total
    add [total_bytes], rax

    ; Write to output file
    ; sys_write(fd, buffer, count)
    mov rax, 1              ; sys_write
    mov rdi, r13            ; output file descriptor
    mov rsi, buffer         ; buffer to write from
    mov rdx, r14            ; number of bytes to write
    syscall

    ; Check for error
    cmp rax, 0
    jl .error_write

    ; Continue reading
    jmp .read_loop

.close_files:
    ; Close input file
    mov rax, 3              ; sys_close
    mov rdi, r12            ; input file descriptor
    syscall

    ; Close output file
    mov rax, 3              ; sys_close
    mov rdi, r13            ; output file descriptor
    syscall

    ; Print success message
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_success
    mov rdx, msg_success_len
    syscall

    ; Print "Bytes copied: "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_bytes
    mov rdx, msg_bytes_len
    syscall

    ; Print total bytes
    mov rdi, [total_bytes]
    call print_number

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit successfully
    mov rax, 60
    xor rdi, rdi
    syscall

.error_open:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_error_open
    mov rdx, msg_error_open_len
    syscall
    jmp .exit_error

.error_read:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_error_read
    mov rdx, msg_error_read_len
    syscall
    ; Close files before exit
    mov rax, 3
    mov rdi, r12
    syscall
    mov rax, 3
    mov rdi, r13
    syscall
    jmp .exit_error

.error_write:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_error_write
    mov rdx, msg_error_write_len
    syscall
    ; Close files before exit
    mov rax, 3
    mov rdi, r12
    syscall
    mov rax, 3
    mov rdi, r13
    syscall
    jmp .exit_error

.exit_error:
    mov rax, 60
    mov rdi, 1              ; Exit with error code 1
    syscall

; Function: print_number
; Description: Convert integer to string and print it
; Arguments:
;   rdi: number to print
print_number:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rax, rdi            ; Number to convert
    lea rbx, [num_buffer + 19]
    mov byte [rbx], 0
    dec rbx

    mov r12, 10

    test rax, rax
    jnz .convert_loop
    mov byte [rbx], '0'
    jmp .print

.convert_loop:
    test rax, rax
    jz .print

    xor rdx, rdx
    div r12

    add dl, '0'
    mov [rbx], dl
    dec rbx

    jmp .convert_loop

.print:
    inc rbx

    lea rdx, [num_buffer + 19]
    sub rdx, rbx

    mov rax, 1
    mov rdi, 1
    mov rsi, rbx
    syscall

    pop r12
    pop rbx
    pop rbp
    ret

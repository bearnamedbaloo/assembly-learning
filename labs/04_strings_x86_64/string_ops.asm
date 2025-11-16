; string_ops.asm - String operations (strlen and strcmp)
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - Working with null-terminated strings
; - Byte-by-byte memory access
; - String length calculation
; - String comparison
; - Character operations

DEFAULT REL                 ; Use RIP-relative addressing by default (recommended for modern code)

section .data
    str1 db "Hello, Assembly!", 0    ; Null-terminated string
    str2 db "Hello, Assembly!", 0    ; Same string
    str3 db "Hello, World!", 0       ; Different string

    msg_len db "Length of '", 0
    msg_len_len equ $ - msg_len
    msg_is db "': ", 0
    msg_is_len equ $ - msg_is

    msg_cmp1 db "Comparing '", 0
    msg_cmp1_len equ $ - msg_cmp1
    msg_cmp2 db "' and '", 0
    msg_cmp2_len equ $ - msg_cmp2
    msg_equal db "': Equal", 10, 0
    msg_equal_len equ $ - msg_equal
    msg_not_equal db "': Not equal", 10, 0
    msg_not_equal_len equ $ - msg_not_equal

    newline db 10

section .bss
    num_buffer resb 20

section .text
    global _start

_start:
    ; Test 1: Calculate and print length of str1
    mov rdi, str1
    call test_strlen

    ; Test 2: Compare str1 and str2 (should be equal)
    mov rdi, str1
    mov rsi, str2
    call test_strcmp

    ; Test 3: Compare str1 and str3 (should be not equal)
    mov rdi, str1
    mov rsi, str3
    call test_strcmp

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

; Function: test_strlen
; Description: Test strlen function and print result
; Arguments:
;   rdi: pointer to string
test_strlen:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov r12, rdi            ; Save string pointer

    ; Print "Length of '"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_len
    mov rdx, msg_len_len
    syscall

    ; Print the string
    mov rdi, r12
    call print_string

    ; Print "': "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_is
    mov rdx, msg_is_len
    syscall

    ; Calculate length
    mov rdi, r12
    call strlen

    ; Print length
    mov rdi, rax
    call print_number

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    pop r12
    pop rbx
    pop rbp
    ret

; Function: test_strcmp
; Description: Test strcmp function and print result
; Arguments:
;   rdi: pointer to first string
;   rsi: pointer to second string
test_strcmp:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13

    mov r12, rdi            ; Save first string
    mov r13, rsi            ; Save second string

    ; Print "Comparing '"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_cmp1
    mov rdx, msg_cmp1_len
    syscall

    ; Print first string
    mov rdi, r12
    call print_string

    ; Print "' and '"
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_cmp2
    mov rdx, msg_cmp2_len
    syscall

    ; Print second string
    mov rdi, r13
    call print_string

    ; Compare strings
    mov rdi, r12
    mov rsi, r13
    call strcmp

    ; Check result
    test rax, rax
    jnz .not_equal

    ; Strings are equal
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_equal
    mov rdx, msg_equal_len
    syscall
    jmp .done

.not_equal:
    ; Strings are not equal
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_not_equal
    mov rdx, msg_not_equal_len
    syscall

.done:
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

; Function: strlen
; Description: Calculate length of null-terminated string
; Arguments:
;   rdi: pointer to string
; Returns:
;   rax: length (not including null terminator)
; Algorithm:
;   length = 0
;   while *str != 0:
;       length++
;       str++
;   return length
strlen:
    push rbp
    mov rbp, rsp

    xor rax, rax            ; length = 0

.loop:
    cmp byte [rdi + rax], 0 ; Check if current char is null
    je .done                ; If null, we're done

    inc rax                 ; length++
    jmp .loop

.done:
    pop rbp
    ret

; Function: strcmp
; Description: Compare two null-terminated strings
; Arguments:
;   rdi: pointer to first string
;   rsi: pointer to second string
; Returns:
;   rax: 0 if equal, non-zero if different
; Algorithm:
;   while *s1 != 0 and *s1 == *s2:
;       s1++
;       s2++
;   return *s1 - *s2
strcmp:
    push rbp
    mov rbp, rsp

.loop:
    mov al, [rdi]           ; Load byte from first string
    mov cl, [rsi]           ; Load byte from second string

    ; Check if characters are different
    cmp al, cl
    jne .different          ; If different, return difference

    ; Check if we've reached the end
    test al, al             ; Check if al (char from str1) is null
    jz .equal               ; If null, strings are equal

    ; Move to next characters
    inc rdi
    inc rsi
    jmp .loop

.different:
    ; Return difference
    sub al, cl              ; al = al - cl
    movsx rax, al           ; Sign-extend to 64-bit
    jmp .done

.equal:
    xor rax, rax            ; Return 0 for equal strings

.done:
    pop rbp
    ret

; Function: print_string
; Description: Print a null-terminated string
; Arguments:
;   rdi: pointer to string
print_string:
    push rbp
    mov rbp, rsp
    push rbx

    mov rbx, rdi            ; Save string pointer

    ; Calculate length
    call strlen
    mov rdx, rax            ; Length in rdx

    ; Print string
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, rbx            ; String pointer
    syscall

    pop rbx
    pop rbp
    ret

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

# Lab 04: String Operations (x86-64)

## Overview

This lab teaches you how to work with strings in assembly language. You'll implement fundamental string operations like `strlen` and `strcmp`, learning about null-terminated strings, byte-level memory access, and character comparison.

## Learning Objectives

- Understand null-terminated string format
- Work with byte-sized data (8-bit operations)
- Implement string length calculation
- Implement string comparison
- Use byte addressing and character operations
- Handle string I/O

## Key Concepts

### Null-Terminated Strings

In C and assembly, strings are typically stored as arrays of characters terminated by a null byte (0):

```asm
section .data
    msg db "Hello", 0    ; 'H', 'e', 'l', 'l', 'o', 0
```

**Key points**:
- Each character is 1 byte
- String ends with null byte (value 0)
- Length does NOT include the null terminator
- Must iterate until null is found

### Byte Operations

When working with strings, use byte-sized operations:

```asm
mov al, [rdi]           ; Load 1 byte into al (lower 8 bits of rax)
mov byte [rsi], al      ; Store 1 byte
cmp byte [rdi], 0       ; Compare byte with 0
```

**Register naming for byte operations**:
- `al` - lower 8 bits of rax
- `bl` - lower 8 bits of rbx
- `cl` - lower 8 bits of rcx
- `dl` - lower 8 bits of rdx

### String Length Algorithm

```
strlen(str):
    length = 0
    while str[length] != 0:
        length++
    return length
```

**Assembly implementation**:
```asm
strlen:
    xor rax, rax            ; length = 0
.loop:
    cmp byte [rdi + rax], 0 ; if str[length] == 0
    je .done                ; exit
    inc rax                 ; length++
    jmp .loop
.done:
    ret                     ; return length in rax
```

### String Comparison Algorithm

```
strcmp(s1, s2):
    while *s1 != 0 and *s1 == *s2:
        s1++
        s2++
    return *s1 - *s2
```

**Return value**:
- 0 if strings are equal
- < 0 if s1 < s2
- > 0 if s1 > s2

**Assembly implementation**:
```asm
strcmp:
.loop:
    mov al, [rdi]       ; al = *s1
    mov cl, [rsi]       ; cl = *s2
    cmp al, cl          ; compare characters
    jne .different      ; if different, return difference
    test al, al         ; if al == 0 (end of string)
    jz .equal           ; strings are equal
    inc rdi             ; s1++
    inc rsi             ; s2++
    jmp .loop
.different:
    sub al, cl          ; return difference
    movsx rax, al       ; sign-extend to 64-bit
    ret
.equal:
    xor rax, rax        ; return 0
    ret
```

### Character ASCII Values

Characters are represented as ASCII values:

| Character | ASCII (Decimal) | ASCII (Hex) |
|-----------|----------------|-------------|
| '0' - '9' | 48 - 57        | 0x30 - 0x39 |
| 'A' - 'Z' | 65 - 90        | 0x41 - 0x5A |
| 'a' - 'z' | 97 - 122       | 0x61 - 0x7A |
| space     | 32             | 0x20        |
| newline   | 10             | 0x0A        |
| null      | 0              | 0x00        |

## Files

- `string_ops.asm`: Implements strlen and strcmp, with tests
- `Makefile`: Build configuration

## Building and Running

```bash
# Build the program
make

# Run the program
./string_ops

# Run tests
make test

# Clean up
make clean

# Disassemble
make disasm
```

## Expected Output

```
Length of 'Hello, Assembly!': 16
Comparing 'Hello, Assembly!' and 'Hello, Assembly!': Equal
Comparing 'Hello, Assembly!' and 'Hello, World!': Not equal
```

## Code Walkthrough

### String Definition

```asm
section .data
    str1 db "Hello, Assembly!", 0    ; Null-terminated
```

### strlen Implementation

```asm
strlen:
    xor rax, rax                ; length = 0
.loop:
    cmp byte [rdi + rax], 0     ; Check current character
    je .done                    ; If null, done
    inc rax                     ; length++
    jmp .loop
.done:
    ret
```

**Addressing**: `[rdi + rax]` accesses the character at position `rax` in the string.

### strcmp Implementation

```asm
strcmp:
.loop:
    mov al, [rdi]       ; Load char from first string
    mov cl, [rsi]       ; Load char from second string
    cmp al, cl          ; Compare
    jne .different      ; Exit if different
    test al, al         ; Check if end of string
    jz .equal           ; If yes, strings are equal
    inc rdi             ; Move to next char
    inc rsi
    jmp .loop
```

**Key instruction**: `test al, al` checks if `al` is zero without changing it.

## Challenge Exercises

1. **strcpy**: Implement string copy function
   ```asm
   ; strcpy(dest, src) - copy src to dest
   ```

2. **strcat**: Implement string concatenation
   ```asm
   ; strcat(dest, src) - append src to dest
   ```

3. **strchr**: Find first occurrence of character
   ```asm
   ; strchr(str, char) - return pointer to first occurrence
   ```

4. **strstr**: Find substring
   ```asm
   ; strstr(haystack, needle) - find needle in haystack
   ```

5. **toupper**: Convert string to uppercase
   ```asm
   ; toupper(str) - convert all lowercase to uppercase
   ```

6. **tolower**: Convert string to lowercase

7. **strrev**: Reverse a string in-place

8. **atoi**: Convert string to integer
   ```asm
   ; atoi(str) - parse decimal string to integer
   ```

9. **itoa**: Convert integer to string (you've already implemented this as print_number!)

10. **Case-insensitive compare**: Implement `stricmp`

## Advanced: String Optimization

Modern CPUs provide SIMD instructions for faster string operations:

```asm
; Using SSE2 for fast string length (advanced)
; Load 16 bytes at once and check for null bytes
pcmpeqb xmm0, xmm1      ; Compare 16 bytes for equality
pmovmskb eax, xmm0      ; Create mask from comparison
```

This is much faster but more complex. Stick with byte-by-byte for learning.

## Debugging Tips

```bash
# Debug with GDB
gdb ./string_ops

# Useful commands:
(gdb) break strlen
(gdb) run
(gdb) x/s $rdi              # Examine string at rdi
(gdb) x/20c $rdi            # Examine 20 characters
(gdb) x/20xb $rdi           # Examine 20 bytes in hex
(gdb) print (char*)$rdi     # Print string
(gdb) print $al             # Print value in al register
```

**View string character by character**:
```bash
(gdb) x/20xb $rdi       # Hex bytes
(gdb) x/20c $rdi        # ASCII characters
```

**Watch character comparisons**:
```bash
(gdb) break strcmp
(gdb) run
(gdb) display $al           # Character from str1
(gdb) display $cl           # Character from str2
(gdb) stepi                 # Step through comparison
```

## Common Pitfalls

1. **Forgetting null terminator**: Always include 0 at end of strings
2. **Wrong size operations**: Use byte operations (`mov al`, not `mov rax`)
3. **Not checking for null**: Always check for end of string
4. **Buffer overflows**: Ensure destination buffer is large enough
5. **Case sensitivity**: 'A' != 'a' (ASCII 65 vs 97)
6. **Sign extension**: Use `movsx` for signed, `movzx` for unsigned
7. **Register clobbering**: `al` is part of `rax` - modifying one affects the other

## String Functions Summary

| Function | Purpose | Arguments | Return |
|----------|---------|-----------|--------|
| `strlen` | Get length | rdi = string | rax = length |
| `strcmp` | Compare | rdi = str1, rsi = str2 | rax = difference |
| `strcpy` | Copy | rdi = dest, rsi = src | - |
| `strcat` | Concatenate | rdi = dest, rsi = src | - |
| `strchr` | Find char | rdi = str, rsi = char | rax = pointer or 0 |

## References

- [ASCII Table](https://www.asciitable.com/)
- [x86-64 Byte Operations](https://www.felixcloutier.com/x86/)
- [C String Functions Reference](https://en.cppreference.com/w/c/string/byte)
- [Intel Manual Vol. 1](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)

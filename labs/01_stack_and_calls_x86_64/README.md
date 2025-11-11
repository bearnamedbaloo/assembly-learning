# Lab 01: Stack and Function Calls (x86-64)

## Overview

This lab introduces you to function calls and the System V AMD64 ABI calling convention.
You'll write an assembly function that can be called from C, demonstrating interoperability
between languages.

## Learning Objectives

- Understand the System V AMD64 ABI calling convention
- Learn about the stack frame (prologue/epilogue)
- Pass arguments via registers
- Return values from functions
- Link assembly code with C code

## Key Concepts

### System V AMD64 ABI Calling Convention

The System V ABI is the standard calling convention for x86-64 on Unix-like systems.

**Integer/Pointer Arguments** (first 6):
1. `rdi` - 1st argument
2. `rsi` - 2nd argument
3. `rdx` - 3rd argument
4. `rcx` - 4th argument
5. `r8` - 5th argument
6. `r9` - 6th argument
7. Additional arguments go on the stack

**Return Value**:
- `rax` - Integer/pointer return value
- `rdx` - Second return value (for 128-bit returns)

**Register Preservation**:
- **Caller-saved** (may be clobbered by callee): `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8-r11`
- **Callee-saved** (must be preserved): `rbx`, `rsp`, `rbp`, `r12-r15`

### Stack Frame

A stack frame is a section of the stack used for:
- Local variables
- Saved registers
- Return address (pushed automatically by `call`)

**Typical prologue**:
```asm
push rbp        ; Save old base pointer
mov rbp, rsp    ; Set new base pointer
```

**Typical epilogue**:
```asm
pop rbp         ; Restore old base pointer
ret             ; Return to caller
```

## Files

- `sum_two.asm`: Assembly function that adds two integers
- `main.c`: C program that calls the assembly function
- `Makefile`: Builds both files and links them together

## Building and Running

```bash
# Build the program
make

# Run with default values (5 + 7)
make run
# or
./sum_program

# Run with custom values
./sum_program 10 20

# Run tests
make test

# Clean up
make clean

# Disassemble to see the compiled code
make disasm
```

## Expected Output

```
5 + 7 = 12
```

## Challenge Exercises

1. **More arguments**: Create a `sum_three` function that takes 3 arguments
2. **Subtraction**: Create a `sub_two` function that subtracts the second arg from the first
3. **Use callee-saved registers**: Modify `sum_two` to use `rbx` and ensure it's preserved
4. **Multiple return values**: Create a function that returns both sum and difference using `rax` and `rdx`
5. **Stack arguments**: Create a function with 7+ arguments to practice stack-based parameter passing

## Debugging Tips

```bash
# Debug with GDB
gdb ./sum_program

# Useful GDB commands:
# break sum_two       - Set breakpoint at function
# run 10 20          - Run with arguments
# info registers     - Show all registers
# stepi              - Step one instruction
# x/8xg $rsp         - Examine stack (8 quadwords in hex)
```

## References

- [System V ABI Documentation](https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)
- [Calling Convention Overview](https://wiki.osdev.org/Calling_Conventions)

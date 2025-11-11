# Lab 00: Hello, World! (x86-64)

## Overview

This is your first assembly program! It demonstrates the absolute basics:
- Program structure (sections: `.data`, `.text`)
- Linux system calls (syscalls)
- Writing to stdout
- Exiting cleanly

## Learning Objectives

- Understand the basic structure of an x86-64 assembly program
- Learn the Linux x86-64 syscall calling convention
- Use `sys_write` to output text
- Use `sys_exit` to terminate the program

## Key Concepts

### Sections
- `.data`: Contains initialized data (our message string)
- `.text`: Contains executable code

### Syscall Convention (x86-64 Linux)
System calls are invoked using the `syscall` instruction. Arguments are passed in registers:
- `rax`: Syscall number
- `rdi`: 1st argument
- `rsi`: 2nd argument
- `rdx`: 3rd argument
- `r10`: 4th argument
- `r8`: 5th argument
- `r9`: 6th argument

### Syscalls Used
1. **sys_write** (1): Write data to a file descriptor
   - `rdi`: file descriptor (1 = stdout)
   - `rsi`: pointer to buffer
   - `rdx`: number of bytes

2. **sys_exit** (60): Exit the program
   - `rdi`: exit status code (0 = success)

## Building and Running

```bash
# Build the program
make

# Run the program
make run
# or
./hello

# Run tests
make test

# Clean up
make clean
```

## Expected Output

```
Hello, world!
```

## Challenge Exercises

Once you've understood the basic program, try these modifications:

1. **Change the message**: Modify the string to print your name
2. **Multiple lines**: Add a second message and write it separately
3. **Exit with different code**: Change the exit status to 42 and verify with `echo $?`
4. **Count characters**: Manually count the message length instead of using `equ $ - msg`

## Troubleshooting

- **Segmentation fault**: Check that you're setting up registers correctly
- **Wrong output**: Verify `msg_len` is calculated correctly
- **No output**: Make sure file descriptor is 1 (stdout) not 0 (stdin)

## References

- [Linux Syscall Table](https://filippo.io/linux-syscall-table/)
- [x86-64 ABI Specification](https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)

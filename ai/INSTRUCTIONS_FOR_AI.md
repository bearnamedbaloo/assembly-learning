# Instructions for AI: Adding New Labs

This document provides step-by-step instructions for AI agents to add new assembly
programming labs to this repository.

## Prerequisites

Before adding a new lab, ensure you understand:
- The current lab progression and difficulty curve
- The concepts that have been covered in previous labs
- The target architecture (usually x86-64 Linux)
- The System V AMD64 ABI calling convention

## Step-by-Step Process

### 1. Choose Lab Number and Topic

Determine the next sequential lab number and choose a topic that:
- Builds on previous labs
- Introduces 1-2 new concepts
- Fits the learning progression

Example topics:
- Control flow (if/else, loops)
- Memory operations (arrays, strings)
- Bitwise operations
- System calls (file I/O, time)
- Data structures (linked lists, stacks)
- Floating point operations
- Multi-file projects

### 2. Copy the Template

```bash
cp -r labs/_TEMPLATE_LAB labs/NN_topic_name_x86_64
cd labs/NN_topic_name_x86_64
```

### 3. Create the Assembly Code

Replace `skeleton.asm` with your implementation:

**File naming**: Use descriptive names (e.g., `loop.asm`, `strcmp.asm`, `fibonacci.asm`)

**Essential elements**:
- Detailed header comment explaining the program
- Section declarations (`.data`, `.bss`, `.text`)
- Well-commented code explaining each step
- Proper use of calling conventions if applicable
- Clean exit (sys_exit with appropriate status)

**Comment guidelines**:
```asm
; GOOD: Explains the why and what
mov rax, 1          ; syscall number for sys_write (write to file descriptor)
mov rdi, 1          ; file descriptor 1 (stdout)

; BAD: Just repeats the instruction
mov rax, 1          ; move 1 into rax
```

### 4. Create/Update the Makefile

Update the Makefile with:
- Correct `TARGET` name (should match your binary name)
- Correct source file name(s)
- Proper dependencies
- Additional compilation flags if needed

Example:
```makefile
# Makefile for Lab 02: Loops and Control Flow

TARGET := loop_demo

include ../../tooling/Makefile.common

all: $(TARGET)

$(TARGET): loop.o
	$(LD) $(LD_FLAGS) loop.o -o $(TARGET)

loop.o: loop.asm

test: $(TARGET)
	pytest tests/ -v
```

### 5. Write Tests

Create `tests/test_*.py` with comprehensive test cases:

**Minimum requirements**:
- Test basic functionality
- Test edge cases (empty input, zero, negative numbers, etc.)
- Test exit codes
- Test output format

**Example test structure**:
```python
"""
Tests for Lab NN: Topic Name
"""
import sys
from pathlib import Path

tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_basic_case():
    """Test basic functionality"""
    binary_path = Path(__file__).parent.parent / "binary_name"
    result = run_binary(str(binary_path))
    assert result["returncode"] == 0
    assert "expected output" in result["stdout"]


def test_edge_case():
    """Test edge case"""
    # ... test code
```

### 6. Write the README

Create a comprehensive `README.md` with these sections:

**Required sections**:
1. **Overview** - What the lab teaches (2-3 sentences)
2. **Learning Objectives** - Bulleted list of goals
3. **Key Concepts** - Detailed explanations of new concepts
4. **Files** - List of files and their purposes
5. **Building and Running** - Command examples
6. **Expected Output** - Show what students should see
7. **Challenge Exercises** - 3-5 extension ideas
8. **Debugging Tips** - GDB commands or debugging strategies
9. **References** - Links to relevant documentation

**Tone**: Educational, encouraging, clear

**Example structure**:
```markdown
# Lab 02: Loops and Control Flow

## Overview
This lab introduces conditional branches and loop constructs in x86-64 assembly...

## Learning Objectives
- Understand conditional jumps (je, jne, jl, jg, etc.)
- Implement loops using comparison and jumps
- Use labels effectively
...
```

### 7. Test Locally

Before committing:

```bash
# Build the lab
make

# Run it manually
./binary_name

# Run tests
make test

# Clean and rebuild
make clean
make
```

Verify:
- ✓ Code compiles without errors
- ✓ Program runs and produces expected output
- ✓ All tests pass
- ✓ No segmentation faults or hangs
- ✓ Exit code is correct (usually 0)

### 8. Update Root README

Add your lab to the main README.md's lab listing:

```markdown
## Labs

| Lab | Topic | Concepts |
|-----|-------|----------|
| [00](labs/00_hello_x86_64/) | Hello World | Syscalls, program structure |
| [01](labs/01_stack_and_calls_x86_64/) | Functions | Calling convention, stack |
| [02](labs/02_new_lab/) | New Topic | New concepts |
```

### 9. Verify CI

Ensure the lab will pass CI:

```bash
# From repository root
pytest labs/NN_topic_name_x86_64/tests/ -v
```

All tests must pass before pushing.

### 10. Update CI Configuration (if needed)

Usually not necessary, but if your lab requires:
- Special build steps
- Additional dependencies
- Different compilation flags

Update `.github/workflows/ci.yml` accordingly.

## Best Practices

### For Different Lab Types

**Pure Assembly Labs**:
- Use `_start` as entry point
- Link with `ld` directly
- Use syscalls for I/O

**Mixed C/Assembly Labs**:
- Use `global` to export assembly functions
- Follow System V ABI precisely
- Link with `gcc`
- Use `main` in C file

**Multi-file Labs**:
- Update Makefile with all dependencies
- Document the build order
- Explain how files interact

### Common Pitfalls to Avoid

1. **Missing stack alignment** - Stack must be 16-byte aligned before `call`
2. **Wrong register preservation** - Save callee-saved registers
3. **Incorrect syscall numbers** - Double-check against syscall table
4. **Off-by-one errors** - Carefully handle loop conditions
5. **Uninitialized data** - Use `.bss` for uninitialized, `.data` for initialized
6. **Missing null terminators** - Strings need proper termination for C functions
7. **Buffer overflows** - Size buffers appropriately

### Educational Considerations

- **Progressive complexity** - Don't introduce too many concepts at once
- **Show, then challenge** - Give a working example, then suggest modifications
- **Real-world relevance** - Explain why this matters in practice
- **Multiple approaches** - Sometimes show alternative implementations
- **Common mistakes** - Warn about typical errors students make

## Example: Adding a "Fibonacci" Lab

1. Create `labs/02_fibonacci_x86_64/`
2. Write `fibonacci.asm` that calculates the Nth Fibonacci number
3. Use a loop or recursion to demonstrate control flow
4. Write tests for fib(0)=0, fib(1)=1, fib(10)=55
5. README explains loops, comparison, and conditional jumps
6. Add debugging section showing how to step through the loop
7. Challenge: Implement iteratively AND recursively

## Questions?

If you're unsure about:
- **Difficulty level**: Compare to existing labs
- **Technical approach**: Follow conventions in similar labs
- **Documentation style**: Match existing lab READMEs
- **Testing approach**: Look at existing test files

When in doubt, prioritize clarity and educational value over brevity or cleverness.

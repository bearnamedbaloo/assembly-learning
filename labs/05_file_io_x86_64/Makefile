# Makefile for Lab 05: File I/O
# This lab demonstrates file operations using Linux syscalls

# Target binary name
TARGET := file_copy

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the file_copy binary
$(TARGET): file_copy.o
	$(LD) $(LD_FLAGS) file_copy.o -o $(TARGET)

# Specify dependencies
file_copy.o: file_copy.asm

# Override clean to also remove output files
clean:
	rm -f *.o $(TARGET) output.txt

# Test target
test: $(TARGET)
	pytest tests/ -v

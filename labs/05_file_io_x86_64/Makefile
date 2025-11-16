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

# Additional clean target to remove test output files
cleantest:
	rm -f output.txt

# Make clean also run cleantest
clean: cleantest

.PHONY: cleantest

# Test target
test: $(TARGET)
	pytest tests/ -v

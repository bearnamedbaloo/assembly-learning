# Makefile for Lab 04: String Operations
# This lab demonstrates string manipulation and comparison

# Target binary name
TARGET := string_ops

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the string_ops binary
$(TARGET): string_ops.o
	$(LD) $(LD_FLAGS) string_ops.o -o $(TARGET)

# Specify dependencies
string_ops.o: string_ops.asm

# Test target
test: $(TARGET)
	pytest tests/ -v

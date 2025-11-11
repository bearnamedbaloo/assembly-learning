# Makefile for Lab 03: Working with Arrays
# This lab demonstrates array operations and memory addressing

# Target binary name
TARGET := array_max

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the array_max binary
$(TARGET): array_max.o
	$(LD) $(LD_FLAGS) array_max.o -o $(TARGET)

# Specify dependencies
array_max.o: array_max.asm

# Test target
test: $(TARGET)
	pytest tests/ -v

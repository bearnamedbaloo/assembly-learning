# Makefile for Lab 02: Control Flow and Loops
# This lab demonstrates conditional jumps and loop implementation

# Target binary name
TARGET := factorial

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the factorial binary
$(TARGET): factorial.o
	$(LD) $(LD_FLAGS) factorial.o -o $(TARGET)

# Specify dependencies
factorial.o: factorial.asm

# Test target
test: $(TARGET)
	pytest tests/ -v

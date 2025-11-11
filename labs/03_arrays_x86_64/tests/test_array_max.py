"""
Tests for Lab 03: Working with Arrays
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_array_max_runs():
    """Test that array_max program executes successfully"""
    binary_path = Path(__file__).parent.parent / "array_max"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))
    assert result["returncode"] == 0, "Program should exit with status 0"


def test_array_max_output():
    """Test that array_max produces correct output"""
    binary_path = Path(__file__).parent.parent / "array_max"
    result = run_binary(str(binary_path))

    # Array is: 42, 17, 93, 8, 56, 31, 74, 19, 65, 28
    # Maximum is 93
    assert "93" in result["stdout"], "Output should contain 93 (maximum value)"


def test_array_max_message():
    """Test that output contains appropriate message"""
    binary_path = Path(__file__).parent.parent / "array_max"
    result = run_binary(str(binary_path))

    assert "Maximum" in result["stdout"] or "maximum" in result["stdout"], \
        "Output should contain 'Maximum'"


def test_array_max_newline():
    """Test that output ends with newline"""
    binary_path = Path(__file__).parent.parent / "array_max"
    result = run_binary(str(binary_path))

    assert result["stdout"].endswith("\n"), "Output should end with newline"


def test_array_max_exit_code():
    """Test that program exits cleanly"""
    binary_path = Path(__file__).parent.parent / "array_max"
    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with code 0"

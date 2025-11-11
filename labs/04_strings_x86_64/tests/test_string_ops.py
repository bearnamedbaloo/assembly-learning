"""
Tests for Lab 04: String Operations
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_string_ops_runs():
    """Test that string_ops program executes successfully"""
    binary_path = Path(__file__).parent.parent / "string_ops"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))
    assert result["returncode"] == 0, "Program should exit with status 0"


def test_strlen_output():
    """Test that strlen calculates correct length"""
    binary_path = Path(__file__).parent.parent / "string_ops"
    result = run_binary(str(binary_path))

    # "Hello, Assembly!" has 16 characters
    assert "16" in result["stdout"], "Output should contain length 16"
    assert "Length" in result["stdout"] or "length" in result["stdout"], \
        "Output should mention 'Length'"


def test_strcmp_equal():
    """Test that strcmp detects equal strings"""
    binary_path = Path(__file__).parent.parent / "string_ops"
    result = run_binary(str(binary_path))

    assert "Equal" in result["stdout"] or "equal" in result["stdout"], \
        "Output should indicate strings are equal"


def test_strcmp_not_equal():
    """Test that strcmp detects different strings"""
    binary_path = Path(__file__).parent.parent / "string_ops"
    result = run_binary(str(binary_path))

    assert "Not equal" in result["stdout"] or "not equal" in result["stdout"] or \
           "different" in result["stdout"], \
        "Output should indicate strings are not equal"


def test_output_format():
    """Test that output contains comparing message"""
    binary_path = Path(__file__).parent.parent / "string_ops"
    result = run_binary(str(binary_path))

    assert "Comparing" in result["stdout"] or "comparing" in result["stdout"], \
        "Output should contain comparison message"


def test_exit_code():
    """Test that program exits cleanly"""
    binary_path = Path(__file__).parent.parent / "string_ops"
    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with code 0"

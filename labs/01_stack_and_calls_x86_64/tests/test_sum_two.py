"""
Tests for Lab 01: Stack and Function Calls
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_default_sum():
    """Test sum_two with default values (5 + 7)"""
    binary_path = Path(__file__).parent.parent / "sum_program"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with status 0"
    assert "5 + 7 = 12" in result["stdout"], "Output should show correct sum"


def test_custom_values():
    """Test sum_two with custom command-line arguments"""
    binary_path = Path(__file__).parent.parent / "sum_program"

    # Test 10 + 20
    result = run_binary(str(binary_path), "10", "20")
    assert result["returncode"] == 0
    assert "10 + 20 = 30" in result["stdout"], "Output should show 10 + 20 = 30"


def test_negative_numbers():
    """Test sum_two with negative numbers"""
    binary_path = Path(__file__).parent.parent / "sum_program"

    # Test -5 + 10
    result = run_binary(str(binary_path), "-5", "10")
    assert result["returncode"] == 0
    assert "-5 + 10 = 5" in result["stdout"], "Output should handle negative numbers"


def test_zero():
    """Test sum_two with zero"""
    binary_path = Path(__file__).parent.parent / "sum_program"

    # Test 0 + 0
    result = run_binary(str(binary_path), "0", "0")
    assert result["returncode"] == 0
    assert "0 + 0 = 0" in result["stdout"], "Output should handle zero"


def test_large_numbers():
    """Test sum_two with larger numbers"""
    binary_path = Path(__file__).parent.parent / "sum_program"

    # Test 1000 + 2000
    result = run_binary(str(binary_path), "1000", "2000")
    assert result["returncode"] == 0
    assert "1000 + 2000 = 3000" in result["stdout"], "Output should handle larger numbers"

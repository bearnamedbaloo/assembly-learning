"""
Tests for Lab XX: [Lab Name]
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_basic_execution():
    """Test that the program executes successfully"""
    binary_path = Path(__file__).parent.parent / "program_name"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with status 0"


def test_expected_output():
    """Test that the program produces expected output"""
    binary_path = Path(__file__).parent.parent / "program_name"
    result = run_binary(str(binary_path))

    # Modify this assertion based on expected output
    assert "expected string" in result["stdout"], "Output should contain expected string"

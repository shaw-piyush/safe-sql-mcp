"""Environment checks: Python 3.12 and the mcp 2.x MCPServer import path."""

import sys


def test_python_is_3_12():
    assert sys.version_info[:2] == (3, 12)


def test_mcp_sdk_exposes_mcpserver():
    from mcp.server.mcpserver import MCPServer

    assert MCPServer.__name__ == "MCPServer"

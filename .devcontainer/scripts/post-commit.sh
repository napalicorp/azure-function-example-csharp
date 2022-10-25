#!/bin/bash
echo "Running Sonarscan on the code. Visit http://localhost:9000 for results."

/workspace/.devcontainer/scripts/run-code-scan.sh "/workspace" >/workspace/.devcontainer/code-scan.log &
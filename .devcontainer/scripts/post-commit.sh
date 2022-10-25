#!/bin/bash
echo "Running Sonarscan on the code. Visit http://localhost:9000 for results."

/workspace/.devcontainer/scripts/run-sonar-scanner.sh "/workspace" >/workspace/.devcontainer/post-commit.log &
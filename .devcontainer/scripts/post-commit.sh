#!/bin/bash
echo "Running Sonarscan on the code. Visit http://localhost:9000 for results."

nohup /workspace/.devcontainer/scripts/run-sonar-scanner.sh -w /workspace >/workspace/.devcontainer/post-commit.log &

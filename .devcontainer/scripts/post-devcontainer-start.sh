#!/bin/bash

SQ_ACCESS_JSON_FILENAME="/workspace/.devcontainer/sq-access.local.json"

setup_sq_project() {
    project_name=$1
    echo "SQ: Checking if project: $project_name exists"
    project_key="null"
    project=$(curl -u admin:admin "http://localhost:9000/api/projects/search?q=$project_name&format=json" 2>/dev/null | jq ".components[0]")
    if [ "$project" == "null" ] 
    then
        echo "SQ: Project: $project_name does not exist. Attempt to create it."
        project=$(curl -u admin:admin "http://localhost:9000/api/projects/create" -X POST \
        --header "Content-Type: application/x-www-form-urlencoded" \
        -d "project=$project_name&name=$project_name" 2>/dev/null)
        project_key=$(echo $project | jq ".project.key")
    else
        echo "SQ: Project: $project_name already exists"
        project_key=$(echo $project | jq ".key")
    fi
    echo "SQ: Project key: $project_key"
    
    token_id=$(cat /proc/sys/kernel/random/uuid)
    user_token=$(curl -u admin:admin "http://localhost:9000/api/user_tokens/generate" -X POST \
        --header "Content-Type: application/x-www-form-urlencoded" \
        -d "name=$token_id" 2>/dev/null | jq ".token")
    echo "SQ: Generated user token: $user_token"

    echo "{\"key\":$project_key, \"token\":$user_token}" > $SQ_ACCESS_JSON_FILENAME 
    
}

if [ ! -f $SQ_ACCESS_JSON_FILENAME ]
then
    echo "SQ: Access json file not found. Setting up project"
    repo_name=$(basename -s .git `git config --get remote.origin.url`)
    setup_sq_project $repo_name
else
    echo "SQ: Access json file found. Skipping setup"
fi

echo "Scripts: Make scripts executable"
chmod +x /workspace/.devcontainer/scripts/post-commit.sh
chmod +x /workspace/.devcontainer/scripts/run-sonar-scanner.sh

echo "Git: Copying post-commit.sh as post-commit git hook"
cp /workspace/.devcontainer/scripts/post-commit.sh /workspace/.git/hooks/post-commit
chmod +x /workspace/.git/hooks/post-commit
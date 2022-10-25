#!/bin/bash

ENV_VAR_FILE=/workspace/.devcontainer/local.env

while getopts ":w:t:p:" opt; do
  case $opt in
    w) workingDir="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

cd $workingDir
cwd=$(pwd)
echo $cwd

if [ ! -f $ENV_VAR_FILE ]
then
    echo "SQ: Environment config not found. Skipping SonarScan"
else
    export $(cat $ENV_VAR_FILE | xargs) >/dev/null

    dotnet sonarscanner begin /k:$SQ_PROJECT_KEY /d:sonar.login=$SQ_AUTH_TOKEN /d:sonar.host.url=http://localhost:9000 \
    /d:sonar.cs.vscoveragexml.reportsPaths=coverage.xml
    dotnet build
    dotnet-coverage collect 'dotnet test' -f xml  -o 'coverage.xml'
    dotnet sonarscanner end /d:sonar.login=$SQ_AUTH_TOKEN
    echo "SQ: Done. SonarScan completed"
fi


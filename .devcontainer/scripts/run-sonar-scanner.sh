#!/bin/bash

SQ_ACCESS_JSON_FILENAME="sq_access.local.json"

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

if [ ! -f $SQ_ACCESS_JSON_FILENAME ]
then
    echo "SQ: Access json file not found. Skipping SonarScan"
else
    echo "SQ: Access json file found. Running SonarScan"
    token=$(cat $SQ_ACCESS_JSON_FILENAME | jq -r ".token")
    project=$(cat $SQ_ACCESS_JSON_FILENAME | jq -r ".key")
    echo "SQ: key=$project , token=$token"

    # dotnet tool install --global dotnet-sonarscanner 2>/dev/null
    # dotnet tool install --global dotnet-coverage 2>/dev/null
    export PATH=$PATH:~/.dotnet/tools

    /usr/bin/dependency-check.sh -f JSON -f HTML -s . -o .

    dotnet sonarscanner begin /k:$project /d:sonar.login=$token /d:sonar.host.url=http://localhost:9000 \
    /d:sonar.cs.vscoveragexml.reportsPaths=coverage.xml \
    /d:sonar.dependencyCheck.jsonReportPath="dependency-check-report.json" \
    /d:sonar.dependencyCheck.htmlReportPath="dependency-check-report.html"
    dotnet build
    dotnet-coverage collect 'dotnet test' -f xml  -o 'coverage.xml'
    dotnet sonarscanner end /d:sonar.login=$token
    echo "SQ: Done. SonarScan completed"
fi


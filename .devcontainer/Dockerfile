FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated6.0-core-tools

ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# jq for making rest api requests from shell scripts
RUN apt update
RUN apt install -y jq

# SonarQube tools and deps
RUN dotnet tool install --global dotnet-sonarscanner
RUN dotnet tool install --global dotnet-coverage
RUN dotnet tool update --global CycloneDX
ENV PATH="$PATH:/root/.dotnet/tools"
RUN apt install openjdk-11-jre -y

# GitLeaks tools and deps
RUN wget https://github.com/zricethezav/gitleaks/releases/download/v8.15.0/gitleaks_8.15.0_linux_x64.tar.gz
RUN tar -xzvf gitleaks_8.15.0_linux_x64.tar.gz
RUN cp gitleaks /usr/local/bin/
RUN apt update
RUN apt install -y python3-pip
RUN pip3 install pre-commit
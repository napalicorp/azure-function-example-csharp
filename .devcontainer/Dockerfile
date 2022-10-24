FROM mcr.microsoft.com/azure-functions/dotnet-isolated:4-dotnet-isolated6.0-core-tools

ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

RUN apt update
RUN apt install -y jq

RUN dotnet tool install --global dotnet-sonarscanner
RUN dotnet tool install --global dotnet-coverage

RUN apt install openjdk-11-jre -y

ENV DEPENDENCY_CHECK=7.3.0 \
    PATH="$PATH:/root/.dotnet/tools"

RUN set -x && \
    # Install dependency-check
    /usr/bin/wget -q -O /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip https://github.com/jeremylong/DependencyCheck/releases/download/v${DEPENDENCY_CHECK}/dependency-check-${DEPENDENCY_CHECK}-release.zip && \
    /usr/bin/wget -q -O /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip.asc https://github.com/jeremylong/DependencyCheck/releases/download/v${DEPENDENCY_CHECK}/dependency-check-${DEPENDENCY_CHECK}-release.zip.asc && \
    /usr/bin/gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 259A55407DD6C00299E6607EFFDE55BE73A2D1ED && \
    /usr/bin/gpg --batch --verify /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip.asc /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip && \
    /usr/bin/unzip /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip -d /opt && \
    /bin/mkdir /opt/dependency-check/data && \
    /bin/chmod g+w -R /opt/dependency-check/data && \
    /bin/ln -s /opt/dependency-check/bin/dependency-check.sh /usr/bin/dependency-check.sh && \
    /bin/rm -v /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip.asc /opt/dependency-check-${DEPENDENCY_CHECK}-release.zip
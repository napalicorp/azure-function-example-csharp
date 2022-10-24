FROM sonarqube:9.7-community

RUN wget  https://github.com/dependency-check/dependency-check-sonar-plugin/releases/download/3.0.1/sonar-dependency-check-plugin-3.0.1.jar
RUN cp sonar-dependency-check-plugin-3.0.1.jar /opt/sonarqube/extensions/plugins/
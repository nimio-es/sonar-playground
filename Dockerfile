# syntax=docker/dockerfile:1

FROM maven:3.8.1-openjdk-11 AS download
COPY ./download-plugins.sh /tmp/download-plugins.sh
RUN apt update && apt install wget -y
RUN bash -C "/tmp/download-plugins.sh"

FROM sonarqube:8.9-community 
COPY --from=download /tmp/extensions-plugins /opt/sonarqube/extensions/plugins
ENV SONAR_WEB_JAVAADDITIONALOPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-1.8.0.jar=web"
ENV SONAR_CE_JAVAADDITIONALOPTS="-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-1.8.0.jar=ce"

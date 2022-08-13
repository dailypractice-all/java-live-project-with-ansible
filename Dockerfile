FROM maven:3.6.3 as maven
LABEL COMPANY="gaurav and company"
LABEL MAINTAINER="1996gauravb@gmail.com"
LABEL APPLICATION="Sample Application"

WORKDIR /usr/src/app
RUN curl -O -L http://18.207.101.51:8081/repository/integration-local/com/javacodegeeks/SampleWebApplication/1.0-SNAPSHOT/SampleWebApplication-1.0-20220717.133631-2.war
#COPY . /usr/src/app
#RUN mvn package

FROM tomcat:8.5-jdk15-openjdk-oracle
ARG TOMCAT_FILE_PATH=/docker

#Data & Config - Persistent Mount Point
ENV APP_DATA_FOLDER=/var/lib/SampleApp
ENV SAMPLE_APP_CONFIG=${APP_DATA_FOLDER}/config/

#ENV CATALINA_OPTS="-Xms1024m -Xmx4096m -XX:MetaspaceSize=512m -	XX:MaxMetaspaceSize=512m -Xss512k"

#Move over the War file from previous build step
WORKDIR /usr/local/tomcat/webapps/
COPY --from=maven /usr/src/app/SampleWebApplication-1.0-20220717.133631-2.war /usr/local/tomcat/webapps/api.war

#COPY ${TOMCAT_FILE_PATH}/* ${CATALINA_HOME}/conf/

WORKDIR $APP_DATA_FOLDER

EXPOSE 8080
ENTRYPOINT ["catalina.sh", "run"]

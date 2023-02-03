#FROM adoptopenjdk:11.0.3_7-jdk-openj9-0.14.0

#USER root

#Run Maven
FROM maven:3.6-jdk-11-slim as BUILD
COPY . /src
WORKDIR /src
RUN mvn install -DskipTests -Dcheckstyle.skip

#Secret exposed
COPY id_rsa ~/.ssh/id_rsa
COPY evil /evil

#Virus included
COPY eicar ~/eicar.txt
RUN curl https://wildfire.paloaltonetworks.com/publicapi/test/elf -o EvilMalware-WF

#Install vulnerable os level packages
#Hashing out as it didn't install it originally....:  CMD apt-get install nmap nc
RUN apt-get update \
        && apt-get install -y nmap \
        && apt-get install -y netcat

#Expose vulnerable ports
#EXPOSE 22
EXPOSE 80

#Run App
FROM openjdk:11.0.1-jre-slim-stretch
EXPOSE 8081
WORKDIR /app
ARG JAR=spring-petclinic-2.5.0-SNAPSHOT.jar
COPY --from=BUILD /src/target/$JAR /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

#Healthcheck
HEALTHCHECK --interval=1m --timeout=3s CMD curl -f http://localhost:8081 || exit 1
FROM openjdk:11.0.1-jre-slim-stretch
FROM adoptopenjdk:11.0.3_7-jdk-openj9-0.14.0

USER root

#Secret exposed
COPY id_rsa ~/.ssh/id_rsa
COPY evil /evil

#Virus included
COPY eicar ~/eicar.txt
#CMD sed 's/999STANDARD/STANDARD' eicar.txt
#CMD sed -i 's/999STANDARD/STANDARD' ~/eicar.txt
RUN curl https://wildfire.paloaltonetworks.com/publicapi/test/elf -o EvilMalware-WF

#Install vulnerable os level packages
#Hashing out as it didn't install it originally....:  CMD apt-get install nmap nc
RUN apt-get update \
        && apt-get install -y nmap \
        && apt-get install -y netcat

#Expose vulnerable ports
EXPOSE 22
EXPOSE 80

#Expose App
EXPOSE 8081

#Exec App
ARG JAR=spring-petclinic-2.5.0-SNAPSHOT.jar
COPY target/$JAR /app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

FROM eclipse-temurin:17-jdk-jammy
 
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

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve

COPY src ./src

CMD ["./mvnw", "spring-boot:run"]
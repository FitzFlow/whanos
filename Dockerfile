FROM jenkins/jenkins:latest

USER root

RUN apt-get update && \
    apt-get install -y maven git wget && \
    rm -rf /var/lib/apt/lists/*

USER jenkins

RUN mkdir -p /var/jenkins_home && \
    wget -O /var/jenkins_home/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war

EXPOSE 8080

EXPOSE 50000

CMD ["java", "-jar", "/var/jenkins_home/jenkins.war"]

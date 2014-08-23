FROM ubuntu:14.04

RUN echo "1.574" > .lts-version-number

RUN apt-get update && apt-get install -y --no-install-recommends openjdk-7-jdk
RUN apt-get update && apt-get install -y wget git curl zip maven=3.0.5-1 ant=1.9.3-2build1 ruby rbenv make

RUN wget -q -O - http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key | sudo apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian-stable binary/ >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y jenkins
RUN mkdir -p /var/jenkins_home && chown -R jenkins /var/jenkins_home
ADD init.groovy /tmp/WEB-INF/init.groovy
RUN cd /tmp && zip -g /usr/share/jenkins/jenkins.war WEB-INF/init.groovy

#default slave port
EXPOSE 50000

# VOLUME /var/jenkins_home - bind this in via -v if you want to make this persistent.
ENV JENKINS_HOME /var/jenkins_home
VOLUME /var/jenkins_home
ADD ./home_templates /var/jenkins_home_templates

RUN mkdir /var/plugins
WORKDIR /var/plugins
RUN for i in $(cat /var/jenkins_home_templates/plugins.txt) ; do curl -O -L $i ; done
WORKDIR /var/jenkins_home
# for main web interface:
EXPOSE 8080
ADD ./start /start
RUN chmod +x /start
CMD /start



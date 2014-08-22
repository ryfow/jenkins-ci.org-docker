# Ryfow's Unofficial Jenkins Docker image

The Jenkins Continuous Integration and Delivery server. 

This is a fully functional Jenkins server, based on the Long Term Support release
http://jenkins-ci.org/


<img src="http://jenkins-ci.org/sites/default/files/jenkins_logo.png"/>

This Docker image diverges from the official one in a couple of key ways.

1. There's a list of plugins stored in plugins.txt that are installed
   by default. This allows the docker container to access Git
   repositories out of the box.
1. Some defaults are loaded into /var/jenkins_home. A maven installer
   is pre-configured, the slaveAgentPort is configured via config.xml,
   and a "BuildJenkins" job is preloaded as an example job to run.
1. Jenkins.instance.setAgentPort() was removed from init.groovy. That
   operation did not appear to work.
1. The /start script is run by root, which checks to see if the config
   defaults should be loaded and chowned to jenkins, and then runs
   `su - jenkins java -jar jenkins.jar`

# Usage

```
docker run -p 8080:8080 jenkins
```

This will store the workspace in /var/jenkins_home. All Jenkins data lives in there - including plugins and configuration. You will probably want to make that a persistent volume:

```
docker run --name myjenkins -p 8080:8080 -v /var/jenkins_home jenkins
```

The volume for the "myjenkins" named container will then be persistent.

You can also bind mount in a volume from the host: 

First, ensure that /your/home is accessible by the jenkins user in container (jenkins user - uid 102 normally - or use -u root), then: 

```
docker run -p 8080:8080 -v /your/home:/var/jenkins_home jenkins
```

## Backing up data

If you bind mount in a volume - you can simply back up that directory (which is jenkins_home) at any time. 

If your volume is inside a container - you can use ```docker cp $ID:/var/jenkins_home``` command to extract the data. 

# Attaching build executors 

You can run builds on the master (out of the box) buf if you want to attach build slave servers: make sure you map the port: ```-p 50000:50000``` - which will be used when you connect a slave agent.

<a href="https://registry.hub.docker.com/u/maestrodev/build-agent/">Here</a> is an example docker container you can use as a build server with lots of good tools installed - which is well worth trying.


# Upgrading

All the data needed is in the /var/jenkins_home directory - so depending on how you manage that - depends on how you upgrade. Generally - you can copy it out - and then "docker pull" the image again - and you will have the latest LTS - you can then start up with -v pointing to that data (/var/jenkins_home) and everything will be as you left it. 




#!/usr/bin/env bash

tar -zcvf jenkins_state.tar.gz /var/lib/jenkins/nodes /var/lib/jenkins/workspace /var/lib/jenkins/jobs /var/lib/jenkins/plugins /var/lib/jenkins/users /var/lib/jenkins/hudson.plugins* /var/lib/jenkins/config.xml /var/lib/jenkins/credentials.xml /var/lib/jenkins/github-plugin-configuration.xml /var/lib/jenkins/hudson.triggers.SCMTrigger.xml

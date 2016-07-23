#!/usr/bin/env bash

mkdir -p /var/lib/jenkins/workspace 2> /dev/null
cd /var/lib/jenkins
tar -zcvf jenkins_state.tar.gz nodes workspace jobs plugins users hudson.plugins*  *.xml --exclude 'jobs/*/builds/*'
mv jenkins_state.tar.gz /perm/jenkins_state.tar.gz

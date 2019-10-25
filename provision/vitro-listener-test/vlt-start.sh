#!/bin/sh

cd /home/vagrant/src/vitro-listener-test

nohup mvn clean spring-boot:run &

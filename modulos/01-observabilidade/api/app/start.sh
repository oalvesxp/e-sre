#!/bin/bash

#java -jar -Xms128M -Xmx128M -Dspring.profiles.active=prod target/forum.jar
java -jar -Xms128M -Dspring.profiles.active=prod target/forum.jar

#!/bin/bash

# Usage: 
# 	in ipojo-manip-*-logpresso branch
# 		$ mvn clean install
#	in ipojo-runtime-*-logpresso branch
# 		$ cd core; mvn clean install
# 	in ipojo-manip-*-logpresso branch
# 		$ bash deploy.sh


set -e

JAR_DIR=./.targets
REPO_VARS="-f deploy.xml -DrepositoryId=staging -Durl=sftp://staging.araqne.org/home/service/araqne"
VER=`grep "version>.*<\/version" manipulator/pom.xml -B1 | grep -v -- "--" | xargs -n2 -d'\n' | grep manip | grep -o -P "(?<=version>).*(?=</version)"`

# echo VER=$VER

rm -rf $JAR_DIR
mkdir -p $JAR_DIR

cp manipulator-bom/pom.xml $JAR_DIR/ipojo-manipulator-bom-$VER.xml
cp core/target/org.apache.felix.ipojo-$VER.jar $JAR_DIR
cp manipulator/target/org.apache.felix.ipojo.manipulator-$VER.jar $JAR_DIR
cp annotations/target/org.apache.felix.ipojo.annotations-$VER.jar $JAR_DIR
cp maven-ipojo-plugin/target/maven-ipojo-plugin-$VER.jar $JAR_DIR
cp bnd-ipojo-plugin/target/bnd-ipojo-plugin-$VER.jar $JAR_DIR

mvn deploy:deploy-file $REPO_VARS -Dpackaging=pom -DgroupId=org.apache.felix -DartifactId=ipojo-manipulator-bom -Dversion=$VER -Dfile=$JAR_DIR/ipojo-manipulator-bom-$VER.xml
mvn deploy:deploy-file $REPO_VARS -Dpackaging=jar -DgroupId=org.apache.felix -DartifactId=org.apache.felix.ipojo -Dversion=$VER -Dfile=$JAR_DIR/org.apache.felix.ipojo-$VER.jar
mvn deploy:deploy-file $REPO_VARS -Dpackaging=jar -DgroupId=org.apache.felix -DartifactId=org.apache.felix.ipojo.manipulator -Dversion=$VER -Dfile=$JAR_DIR/org.apache.felix.ipojo.manipulator-$VER.jar
mvn deploy:deploy-file $REPO_VARS -Dpackaging=jar -DgroupId=org.apache.felix -DartifactId=org.apache.felix.ipojo.annotations -Dversion=$VER -Dfile=$JAR_DIR/org.apache.felix.ipojo.annotations-$VER.jar
mvn deploy:deploy-file $REPO_VARS -Dpackaging=jar -DgroupId=org.apache.felix -DartifactId=maven-ipojo-plugin -Dversion=$VER -Dfile=$JAR_DIR/maven-ipojo-plugin-$VER.jar
mvn deploy:deploy-file $REPO_VARS -Dpackaging=jar -DgroupId=org.apache.felix -DartifactId=bnd-ipojo-plugin -Dversion=$VER -Dfile=$JAR_DIR/bnd-ipojo-plugin-$VER.jar

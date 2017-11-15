#!/bin/bash

: ${HADOOP_HOME:=/hadoop/hadoop}

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
#sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml


service ssh start
echo "127.0.0.1 master" >> /etc/hosts 
$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager
$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

$HADOOP_HOME/bin/hdfs dfs -mkdir /wordcount

$HADOOP_HOME/bin/hdfs dfs -mkdir /wordcount/input

echo  "hello hello  hi hi hi " >> $HADOOP_HOME/bin/input1.txt

$HADOOP_HOME/bin/hdfs dfs -copyFromLocal input1.txt  /wordcount/input/input1.txt

$HADOOP_HOME/bin/hadoop jar /hadoop/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.2.jar wordcount /wordcount/input output



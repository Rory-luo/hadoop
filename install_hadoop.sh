#!/bin/bash

UP_OWN="$1"

function StepOne() {
	echo "********** Update the system in the user of hadoop ************"
	sudo apt update && sudo apt upgrade -y
	echo "******************** Finished the operation -- update  **********************"
	echo "************ Install Vim  ***************"
	sudo apt install vim -y 
	echo "*********** Finshed vim ***************"
	echo "*********** Configure SSH  ***************"
	sudo apt install openssh-server openssh-client -y
	cd ~/.ssh
	ssh-keygen -t rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
} 

function StepTwo() {
        echo " "
        echo "********** StepTwo-1: Install java ************"
        echo " "
	sudo apt autoremove openjdk-* -y
        sudo apt install openjdk-8-jdk openjdk-8-jre -y
        echo "********** Finished install java ************"
        
	echo " "
        echo "********** StepTwo-2: Configure JAVA_HOME ************"   
	echo " "
	
        grep -q 'export JAVA_HOME' ~/.bashrc
        if [ ! $? -eq 0  ] ;then

                echo "Configure .bashrc中"

                cat ./JAVA_HOME | while read line

                do
                        echo $line
                        sed -i "1i $line" ~/.bashrc
                        echo "No.$line add sucessfully"
                done
        else
                echo " JAVA_HOME etc in .bashrc, program exit"
        fi
	
        source ~/.bashrc
        
	echo " "
	echo "******* Print the environment of JAVA *******"
	echo $JAVA_HOME
	java -version
	$JAVA_HOME/bin/java -version
}

function StepThree() {
	
	echo " "
	echo "******* StepThree: Unzip the file into environment variables  *******"
	echo " "
	wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-3.1.3/hadoop-3.1.3.tar.gz
        sudo tar zxvf hadoop* -C /usr/local
        sudo mv /usr/local/hadoop-3.1.3 /usr/local/hadoop
        sudo chown -R hadoop:hadoop /usr/local/hadoop
        echo "******* Print the version of hadoop *******"
        /usr/local/hadoop/bin/hadoop version
        echo "******* StepThree finished ******"
        sudo rm -rf *.tar.gz

}

function StepFour() {
	echo " "
	echo "******* StepFour-1: Configure Non-Distributed  *******"
	echo " "
	mkdir /usr/local/hadoop/input
        cp /usr/local/hadoop/etc/hadoop/*.xml /usr/local/hadoop/input
        /usr/local/hadoop/bin/hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.1.jar grep /usr/local/hadoop/input /usr/local/hadoop/output 'dfs[a-z.]+'
        echo '******** StepFour-1 finished: Non-Distributed had set*********'
        cat /usr/local/hadoop/output/*
	
	echo " "
	echo '******** StepFour-2: Configure Pseudo-Distributed *********'
	echo " "
	sudo mv *.xml /usr/local/hadoop/etc/hadoop
	cd /usr/local/hadoop
	./bin/hdfs namenode -format
	./sbin/start-dfs.sh
	echo '******* StepFour-2 finished: Pseudo-Distributed had set*********'
	jps
	echo "******* StepFour all finished *******"
	echo "******* All Configurations finished!  *******"
	sudo rm -rf ../hadoop/
	echo "******* Delete hadoop file successfully!  *******"
}

function printhelp() {
	echo "Some errors about input, plz confirm the operation that no enter! "
	echo "You wanna execute all of these operations: Configure ssh, Configure java, Configure hadoop, right? Y/N[ Default Y]"
	read ans
	if [ "$ans" == "Y" ];then
		StepOne
		StepTwo
		StepThree
		StepFour
	elif [ "$ans" == "N" ];then
		echo "Operation ssh / java / unzip / hadoop not be mentioned"
                exit 1

	else
		StepOne
                StepTwo
                StepThree
                StepFour
	fi
}

if [ "${UP_DOWN}" == "ssh" ];then
	StepOne
elif [ "${UP_DOWN}" == "java" ];then
	 StepTwo
elif [ "${UP_DOWN}" == "unzip" ];then
	StepThree
elif [ "${UP_DOWN}" == "hadoop" ];then
	StepFour
else
	printhelp
fi

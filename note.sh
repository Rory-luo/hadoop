#!/bin/bash

UP_DOWN="$1"

function printhelp() {
	echo "Somthing wrong, please add upload after it"
}

function upload() {
	echo "Please enter the path of documents/files:"
	read f
	echo "Please enter the explain:"
	read e
	echo "Please enter the folder in github:"
	read folder
	## Upload the file that you chosed 
	git remote rm origin
	git init   # initial the operation
	git add "$f"
	git commit -m "$e"	
	git remote add origin git@github.com:Rory-luo/$folder.git
	git push -u origin master
}

function pull() {
	git pull --rebase origin master
}

if [ "${UP_DOWN}" == "upload" ];then
	upload
elif [ "${UP_DOWN}" == "pull" ];then
	pull
else
	printhelp
fi

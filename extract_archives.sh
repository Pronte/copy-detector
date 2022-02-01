#! /bin/bash

###################################################################
#Description: PLAGIARISM DETECTION SYSTEM FOR MULTI-FILE C PROJECTS
#Author    	: Alessio Conte
#Email    	: name.lastname@unipi.it
#Main script: copy_detector.sh
#Usage		: run without arguments or read below to for help text
#Disclaimer: The software is provided "as is", without warranty of  
# any kind, express or implied, including but not limited to the  
# warranties of merchantability, fitness for a particular purpose  
# and noninfringement. In no event shall the authors or copyright
# holders be liable for any claim, damages or other liability,
# whether in an action of contract, tort or otherwise, arising 
# from, out of or in connection with the software or the use 
# or other dealings in the software.
###################################################################

# you can add extension to this array if supported by atool
# make sure the dot is included in the string or it may mess up some things
formats=(".tar.gz" ".tgz" ".tar" ".rar" ".zip" ".tar.xz" ".txz") 

if (( $# < 2 )); then
	echo "=== Utility script to generate project folders ==="
	echo "Finds archives in a folder subrtree and decompresses them, generating a list of the resulting folders"

	echo "=================================================="
	echo "USAGE: ./this.sh BASE_FOLDER LIST_OUT"
	echo "BASE_FOLDER: folder containing all projects in tar format. -- subfolders are included"
	echo "Projects will be decompressed and the list of folder saved in the LIST_OUT file"
	echo "Desired file extension and decompress command can be edited as needed"

	echo "=================================================="
	echo -n "current archive formats scanned: [ "
	for ((i=0; i<${#formats[@]}; i++)); do
		echo -n "\"${formats[i]}\" "
	done
	echo "]"
	echo "ATTENTION: any other format will be ignored."
	echo "(more formats can be added if supported by \"atool\", make sure to install corresponding packages)"

	echo "=================================================="
	echo "DEPENDENCIES: make sure to install atools (universal extractor)"
	echo "plus zip, rar (for compatibility) with the following command:"
	echo "sudo apt-get install atool zip rar"
	exit 0
fi

if [ $(dpkg-query -W -f='${Status}' atool 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "! FATAL: package atool (universal extractor) is not installed."
	echo "! Install it, plus \"zip\" and \"rar\" for compatibility"
	echo "! with the following command:"
	echo "! sudo apt-get install atool zip rar"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  	exit 0
fi

currdir="$(pwd)"

archives="TMP_LIST_TAR.txt"

base="$1"
fout="$(realpath $2)"

rm "$fout" 2> /dev/null

cd "$base"

rm $archives 2> /dev/null

# finding all archives 
for ((i=0; i<${#formats[@]}; i++)); do
	find . -maxdepth 20 -type f -name "*"${formats[i]} >> $archives
done


while read f; do 
	echo ========= DOING $f ==========
	dir="$f"
	for ((i=0; i<${#formats[@]}; i++)); do
		 dir=${dir%${formats[i]}} #trying to strip each format to remove the right one
	done
	mkdir "$dir"
	rm -r $dir/* 2> /dev/null #remove contents if already existing
	atool "$f" -X "$dir"
	echo "$dir" >> "$fout"
done < $archives

rm $archives

#!/bin/bash

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


if (($# < 3)); then 
	echo "==========================="
	echo "PLAGIARISM DETECTION SYSTEM FOR MULTI-FILE C PROJECTS"
	echo "Scripts by Alessio Conte"
	echo "Based on SIM_C By Dick Grune"
	echo "https://dickgrune.com/Programs/similarity_tester/"
	echo ""
	echo "==========================="
	echo "INSTRUCTIONS:"
	echo "The script compares \"projects\". Each must be a folder, and the script will take all .c files in it (and its subfolders)."
	echo ""
	echo "USAGE:"
	echo "./copy_detector.sh LIST_ALL LIST_TODO SUMMARY_FILE"
	echo ""
	echo "LIST_ALL should be a text file containing the list of all projects, one per line"
	echo "LIST_TODO should be a test file as above containing only the projects we want to check against all others (can be the same as LIST_ALL)"
	echo "SUMMARY is the file name where to save a list of the significant similarities (>=3 files over the threshold)"
	echo ""
	echo "IMPORTANT: if paths in the files are relative, they must work from the location from which you EXECUTE the script."
	echo ""
	echo "==========================="
	echo "OUTPUT:"
	echo "Other than SUMMARY, a file MYCOPIES.txt is created in EACH project, containing the significant similarities"
	echo "In these files, each line starts with a number: this is the similarity percentage of the two files that follow it, according to sim_c"
	echo ""
	echo "==========================="
	echo "UTILITIES:"
	echo "If starting from a collection of archives, the script extract_archives.sh can be used to generate the folders and the LIST_ALL file"
	echo ""
	echo "An example usage of the scripts, from the root of the folder tree containing all projects could be:"
	echo " $ ../location/of/extract_archives.sh . ALL.txt"
	echo " $ ../location/of/copy_detector.sh ALL.txt ALL.txt summary.txt"
	echo "==========================="
	exit 0
fi

sig_n_files=3 # how many similar files is worthy of notice? --triggers inclusion in the summary file

studs=$1
todo=$2
summary=$3

cpyfnames=MYCOPIES.txt

currdir=$(pwd)

comptwo=$(dirname $(realpath $0) )/compare_two.sh

echo ==== PREPARING C FILE LISTS ====

while read consegna; do
	cd "$consegna"
		find . -maxdepth 20 -type f -name "*.c" > MYCFILES.txt
	cd "$currdir"
done <$studs


while read consegna; do
	echo =========================== DOING $consegna =====================
	cpyfile="$consegna/$cpyfnames"
 	rm $cpyfile 2> /dev/null
	while read con2; do
		if [ "$consegna" != "$con2" ]; then # do not compare to itself
			echo comparing to === $con2 ===
			echo ==== did I copy from: $con2 \? ==== >> "$cpyfile"
			$comptwo "$consegna" "$con2" > "${cpyfile}_TMP"
			cat "${cpyfile}_TMP" >> "$cpyfile"
			echo ========= >> "$cpyfile"

			flines=$(wc -l < "${cpyfile}_TMP")
			if [ "$flines" -ge "$sig_n_files" ]; then
				echo === SIMILARITIES BETWEEN === $consegna === AND === $con2 >> "$summary"
				cat "${cpyfile}_TMP" >> "$summary"
			fi

		fi
	done <$studs 	
	rm ${cpyfile}_TMP 2>/dev/null
done <$todo



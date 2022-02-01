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


if (($# < 2)); then 
	echo "=========================================================="
	echo "support script of copy_detector.sh, compares \$1 with \$2" 
	echo "USAGE: ./compare_two.sh FOLDER1 FOLDER2"
	echo "expects existence of: FOLDER*/MYCFILES.txt containing the list of .c files"
	echo "=========================================================="
	exit 0
fi

cfname=MYCFILES.txt

# change sim_c.exe with your preferred system (be sure to update the command below if necessary)
simc="$(dirname "$(realpath "$0")" )/sim_c.exe" 

# everything with sim below this is discarded
threshold=60

# usage of simc:
# ./sim_c.exe -p "./f1.c" "./f2.c"
# 4 lines of output > files very different, no output is given
# 5 lines of output > similarity is given on line 5

# just generating a unique name for tmp file
unotrim=$(echo $1 | tr -d " " | awk -F/ '{print $NF}') #cutting over /, taking the last (file name), trimming whitespace
duetrim=$(echo $2 | tr -d " " | awk -F/ '{print $NF}')

tmpfold="tmp"
ftmp=$tmpfold/$unotrim-$duetrim.txt
mkdir $tmpfold 2> /dev/null

rm ${ftmp}* 2> /dev/null

while read fa; do
	 while read fb; do
	 	#saving sim_c output in the tmp file, appending fa and fb to the last line (the useful one)
	 	echo $($simc -p "$1/$fa" "$2/$fb") \% $fa \% $fb >> $ftmp 
	 done <"$2/$cfname"
done <"$1/$cfname"


grep consists $ftmp > ${ftmp}-2 # this will take only lines with the similarity value

# formatting each line to be "X fa fb" where X is the similarity percentage
cnt=0
while read linea; do
	simperc=$(echo $linea | cut -d \% -f 1 | awk '{print $NF}')
	if (( $simperc > $threshold)); then
		((cnt = cnt+1))
		echo $simperc $(echo $linea | cut -d \% -f 3) $(echo $linea | cut -d \% -f 4) >> ${ftmp}-3
	fi
done <${ftmp}-2

if ((cnt == 0)); then 
	echo ZERO SIGNIFICANT SIMILARITIES 
else
	sort -nr ${ftmp}-3 #output sorted similarities
fi

rm ${ftmp}* 2> /dev/null

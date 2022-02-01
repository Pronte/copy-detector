# ##################################################################
# Description: PLAGIARISM DETECTION SYSTEM FOR MULTI-FILE C PROJECTS
# Author     : Alessio Conte
# Email      : name.lastname@unipi.it
# GIT        : https://github.com/Pronte/copy-detector.git
# Disclaimer: The software is provided "as is", without warranty of  
# any kind, express or implied, including but not limited to the  
# warranties of merchantability, fitness for a particular purpose  
# and noninfringement. In no event shall the authors or copyright
# holders be liable for any claim, damages or other liability,
# whether in an action of contract, tort or otherwise, arising 
# from, out of or in connection with the software or the use 
# or other dealings in the software.
# ##################################################################

Copy Detection scripts by Alessio Conte, University of Pisa, based on SIM_C by Dick Grune (see below).

The system is meant to find potential plagiarism between projects coded in C. 

A "project" should be a folder containing the contents (nested folders are fine). 
The system will look at ONLY the files with .c extension.

The final result of running the script is a summary file containing a list of "suspicious" similarities, of the format

"""""""""
=== SIMILARITIES BETWEEN === ./folder_of/project1 === AND === ./folder_of/project_2
100 foo.c bar.c
100 x.c y.c
88 library.c library.c
"""""""""

The first number is how much of the first file is also in the second (similarity is semantic, renamed variables etc.. should be still spotted). 
Of course, some pairs may just be libraries that many students used, so suspicious cases should be still checked manually. 

In essence, given 2 projects, all C files are compared using SIM_C, then ranked, and the pairs below a given similarity threshold discarded. 
By default, the similarity threshold is 60% (good in my experience) and a project becomes suspicious when it has 3 or more similarities with another. These values can be changed in the scripts.

It should be easy to port this to other languages covered by SIM (C, C++, Java, Pascal, Modula-2, Miranda, Lisp, and 8086 assembler code), simply replacing SIM_C with the appropriate version from https://dickgrune.com/Programs/similarity_tester/

======================================

USAGE:
  $ ./copy_detector.sh LIST_ALL.txt LIST_TODO.txt SUMMARY.txt

copy_detector.sh is the main script. It expects two files:
LIST_ALL.txt - a list of all projects (each project should be a folder, with its contents already de-compressed)
LIST_TODO.txt - a list of the projects you want to check. This can be the same as LIST_ALL.txt, but if you only need to check a few (e.g. new projects) it saves you the quadratic number of comparison.

The result is a file MYCOPIES.txt in each of the folders in the second list. Each file contains a report of the similariries with other projects in a relatively easy to read format - the script ignores comparisons with a similarity below 60% -which in my experience is fine-, this can be modified in "compare_two.sh" .
(note, a support file MYCFILES.txt is also created by the script, this can be deleted)

The file SUMMARY.txt is created (or overwritten) - this will contan an excerpt of the most significant similarities (i.e., projects with 3 or more similar files)

===== UTILITY extract_archives.sh =====

If you start from a collection of .tar.gz / .tgz archives, say in a folder F/, you can run
  $ ./extract_archives.sh F list.txt
to extract all the archives in the subtree of F into marching folders, and generate the list file list.txt that can be fed to the main script. (archives will be decompressed using "tar -xf project_name.tar.gx -C project_name")

===== EXAMPLE USAGE =====

Typical usage of the scripts, given you are in the root of the folder tree containing all projects could be:
  $ ../location/of/extract_archives.sh . ALL.txt
  $ ../location/of/copy_detector.sh ALL.txt ALL.txt summary.txt

=========================================================================
=========================================================================

SIM_C.EXE is property of Dick Grune, Vrije Universiteit, The Netherlands.
https://dickgrune.com/Programs/similarity_tester/

As per its license, copyright disclaimer of SIM_C is reported below.

=========================================================================
=========================================================================

Copyright (c) 1986, 2007, Dick Grune, Vrije Universiteit, The Netherlands
All rights reserved.

Redistribution and use in source and binary forms,
with or without modification, are permitted provided
that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     disclaimer in the documentation and/or other materials provided
     with the distribution.

   * Neither the name of the Vrije Universiteit nor the names of its
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=========================================================================
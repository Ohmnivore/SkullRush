Freebyte Zip readme.txt

Program description:
Freebyte Zip is a powerful and easy to use zip/unzip program with full Windows user-interface. You can zip and unzip files, create zip archives, and also make self.extracting archives. This program is the direct successor of HJ-Zip.

Current version: 
Freeware 2.3.1

Supported platforms: 
Windows 7, XP, Vista, 200x, NT, ME, 9x, Linux/wine and all 64 bit editions of Windows.

Copyright Freebyte, 1998 - 2011

Freebyte ZIP Web location: 
http://www.freebyte.com/fbzip

Newsletter: 
To stay informed on Freebyte Zip updates and new software releases you can join the newsletter at http://www.freebyte.com/service

Freebyte Zip has been created by:
Freebyte.com
http://www.freebyte.com

License:
Freeware for commercial and non-commercial use

This package contains:
fbzip.exe (the Freebyte ZIP program)
fbzip.bin (component for creating self-extracting archives)
readme.txt (this file)

Installation:
Copy all the files into one directory. Run the program fbzip.exe by double-clicking on it.

Associating zip files with Freebyte Zip:
In Freebyte Zip, select "Menu/Options/Associate .zip files with Freebyte Zip". After that you can open zip files with Freebyte Zip by double-clicking on zip files.

Zipping files
To zip one or more files, first you have to create a zip archive, with
'Menu/File/New ZIP archive'. Freebyte Zip asks you to first specify a file location of the new zip archive. Then you can add other file(s) to this archive with "Menu/Actions/Add files or folders".

Creating self extracting archives
Freebyte Zip can create self extracting (.exe) archives from the currently opened zip archive, using 'Menu/File/Make self-extracting archive'. These self-extracting archives preserve long file names.

Adding files and directories/folders to existing zip files
First perform 'Menu/File/Open ZIP Archive'. Then you can add the file(s) to this archive with 'Menu/Actions/Add files or folders'.

Short list of other FB Zip menu functions:
  Menu/Actions/Delete selected file(s)
  Menu/Actions/Extract file(s)
  Menu/Actions/View selected file
  Menu/File/Open ZIP Archive
  Menu/File/Close ZIP Archive
  Menu/File/Make self-extracting archive 
  (creates a self-extracting .exe file from the currently open zip file, containing compressed data).


Other Freebyte Zip features
Column sorting, ascending and descending (by clicking one or two times on a column in the Freebyte Zip main window)

New features in Freebyte ZIP version 2.1 (compared to the latest HJ-Zip version):
* Added: option to view or execute files directly from inside the zip archive
* Added: file attributes and file dates are preserved during zip/unzip operations
* Added: self-extracting archives now support long file names
* Added: the ability to add and remove files directly to/from self-extracting archives
* Added: option to extract files with or without path information
* Added: option to add files with or without path information
* Added: option to add files found in contained sub-directories or not to add files in sub-directories
* Added: option to specify the compression level when adding files
* Added: many shortcut keyboard commands for frequently used functions
* Added: many new command-line switches and functions (please see below)
* Added: progressbar display during file extraction and compression
* Added: the compression and extraction process can be aborted
* Added: compression and extraction settings are saved between sessions
* Added: compression and extraction folders are saved between sessions
* Added: statusbar display of total size of zip-file in Kbytes
* Added: statusbar display of total number of items in zip-file

New features in Freebyte ZIP 2.2 and 2.3:
* Added: option to add files with relative or absolute path information
* Added: password protection/encryption. Please note that the password protection/encryption is using the standard zip method, making it compatible with other zip programs.
* Added: display of file attributes in list of files
* Added: an encrypted entry will display an 'E' in the file attributes column.
* Improved: the general speed the program
* Improved: creating a new archive will automatically show the 'add files/directories' dialog

_________________________________________


Command-line options

-e: extract files
-a: add files
-p: use path information when extracting files (create directories if necessary)
-p: store path information when adding files
-r: recurse subdirectories when adding files


command-line:

fbzip.exe [options] <zipfilename> <list of absolute paths>

* The list of absolute paths can contain file names, directories and wild-cards.
* If <zipfilename> does not exist, it will be created on harddisk.


Example 1:

fbzip.exe -a -p -r "c:\test1.zip" "i:\data\mydocument1.doc" "i:\data\mydocument2.doc"
"i:\data\mail\" "i:\data\backup\"

This statement adds these files and directories to the test1.zip zip archive:
  i:\data\mydocument1.doc
  i:\data\mydocument2.doc
  i:\data\mail\
  i:\data\backup\
to this zip file:
  c:\test1.zip
If the zip file does not exist, it will be created. Directories are recursed, and path information is stored in the zip file.


Example 2:

fbzip.exe -e -p "c:\test1.zip" "i:\data\backup\"

This statement extracts all the files inside the test1.zip zip archive to the directory i:\data\backup\
Path information is used, so directories are created on harddisk if necessary.


Example 3:

fbzip.exe -a -p -r "y:\test1.zip" "c:\temp\db_1.MDF" "y:\test\readme.txt" "y:\data\test\"

Adds the two files to the .zip archive, and one directory (including all subdirectories, and storing path information).


Example 4:

fbzip.exe -a -p -r "y:\test1.zip" "c:\temp\Nuis_Data.MDF" "y:\test9\readme.txt" "y:\data\test\*.dat"

Adds the two files to the .zip archive, and all the *.dat files found in the directory "y:\data\test\"


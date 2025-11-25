#! /bin/csh
#Script is run by cron and creates Dataset By Category pages
#EKGrover 27 Nov 2002

cd /home/datag/working/ingrid/htmlsrc/docfind/databrief
cvs -q update
cd /home/datag/Category
ll ../working/ingrid/htmlsrc/docfind/databrief > file_list
./read_thredds.pl
./order_datasets.pl
./final_table.pl
./commit_tables.pl










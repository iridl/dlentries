#!/bin/sh
#
# Script using LFTP to copy data from ftp.ncep.noaa.gov
#
ftp_server=ftp.ncep.noaa.gov
staging=/Data/data22/noaa/ncep/cfsv2/6_hourly_rotating

# temporarily set umask so group permissions are writable
umask 0002

echo -e 'Starting at\t\t' `date`
# Run the FTP Mirror, only pulling the missing files
/bin/lftp -e "set ftp:sync-mode off ; set xfer:log false ; mirror --parallel=10 --only-missing -i pgbf* -i flxf* -x /pub/data/nccf/com/cfs/prod/cfs/* -x cfs/cfs -x cdas* -x monthly* -x time_grib* -x p*.idx -x f*.idx /pub/data/nccf/com/cfs/prod/ $staging ; bye" $ftp_server
echo -e 'lftp finished at\t' `date`

# This is just a sanity check to see if all the files were copied. It creates a "Done" file in the folder to show that
# its received all the files for that 6-hour period.
for top_dirs in $staging/* ; do
    top_dir=`basename $top_dirs`
    for start_hour in 00 06 12 18 ; do
	all_done=true
	start_date="${top_dir#cfs.}"
	start_date_hour=$start_date$start_hour
	done_file=$staging/cfs.$start_date/$start_hour/done
	#if there is no done file, check if the data is there
	if [ ! -e $done_file ] ; then
	    #loop over members, leads (0-45days 1080 hours), and filesets
	    for imember in `seq 1 4` ; do #4 ensemble members
		for fhour in `seq 0 6 1080` ; do
		    vdate=`date -d "$start_date +$start_hour hour +$fhour hour" -u +%Y%m%d%H`
		    for file_set in pgbf flxf ; do
			data_file=$staging/cfs.$start_date/$start_hour/6hrly_grib_0$imember/$file_set$vdate.0$imember.$start_date_hour.grb2
			if [ ! -e $data_file ] ; then 
			    all_done=false
			    echo 'missing ' `date -d "$start_date +$start_hour hour"` $fhour
			    echo $data_file
			    break 3
			fi
		    done
		done
	    done
	    if [ "$all_done" = "true" ] ; then
		echo finished `date -d "$start_date +$start_hour hour"`
		touch $done_file #make done file if the data is there
	    fi
	fi
    done
done


# Clean up the old files
find $staging -mtime +14 -type f -delete -print
find $staging -maxdepth 3 -type d -empty -delete -print

echo -e 'Finished at\t\t' `date`

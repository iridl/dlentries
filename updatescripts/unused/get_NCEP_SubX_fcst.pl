#!/usr/bin/perl -w
# Script to update Models SubX NCEP CFSv2 forecasts 
#
#
# The contact persons at NCEP for this model are Dan Collins, dan.collins@noaa.gov , and Emerson LaJoie, emerson.lajoie@noaa.gov
#
# See the documentation.txt file in /Data/SubX/NCEP/CFSv2/dataset_documentation.txt for more information.
#
# The forecasts for this model are initialized 4 times daily and are released at least daily.
#
# The data files are downloaded from the following remote ftp locations at NCEP:
#
# Priority 1 variables:  ftp://ftp.cpc.ncep.noaa.gov/dcollins/SubX/CFS/
#
# with a separate sub-directory for each variable, named by the variable (and pressure level, if applicable).
#
# The data files are downloaded locally to /Data/SubX/NCEP/CFSv2/forecast/ 
#
# In the netCDF CFSv2 SubX files that NCEP distributes, the order of the dimensions is reversed from those distributed
# by all the other modeling centers.  In addition, this reversed ordering of the dimensions prevents the Data Library
# from generating a working time series for this dataset.  NCEP was not willing to rewrite and re-distribute the data
# files with the dimensions written in the same order as the other centers.  Therefore, this update script reads the
# original files distributed by NCEP and writes new versions of these files with the order of the dimensions reversed
# so that the Data Library can use them correctly.  This is done by using the "ncpdq" operator from the NCO suite of 
# operators.  The new files written using this script include "XYT" in the netCDF file names.  These are the files
# read by the Data Library.   
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.NCEP/.CFSv2/ 
#
# ------
#
# ROMI files based upon NCEP CFSv2 forecasts:
# ***Note:  these haven't  been updated since 2022, removed the source that downloaded these. - jeff turmelle - mar 15 2024
#   The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#   The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#   The data files are downloaded locally to /Data/SubX/NCEP/CFSv2/ROMI/ 
#
# --------
#
# More information about the SubX project and each of the models can be found here:
#
# http://cola.gmu.edu/kpegion/subx/index.html
#
#
use POSIX;
use File::Basename;
use File::Copy;


my $lcldir = '/Data/SubX/NCEP/CFSv2/forecast'; 
my $host = 'ftp.cpc.ncep.noaa.gov';
my $remotedir = '/dcollins/SubX/CFS';

my $this_month = lc(`date +%b%Y`);
my $last_month = lc(`date +%b%Y -d "last month"`);
chomp($this_month);
chomp($last_month);

@cfs_vars = qw(pr_sfc tas_2m ts ua_200 va_200 zg_200 zg_500);

foreach my $current_month ($last_month, $this_month) {

    # NOTE: On ANY failure, remove the input and output files so we'll try it again next time and won't have incomplete data.
    foreach $var (@cfs_vars) {
        my $files = "${var}_CFS_*${current_month}_*_d00_d44_m*.nc";
        # pull all the relevant files. This won't overwrite pre-existing files older than the original
        my $wget_command = "wget --timestamp --directory-prefix $lcldir -A '$files' -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedir/${var}/realtime/";
        print("${wget_command}\n");

        # open pipe, reading stderr and discarding stdout
        my $pid = open(LOGP, "${wget_command} 2>&1 1>/dev/null|");

        while (<LOGP>) {
            # sample output: 2024-03-27 12:30:19 (14.2 MB/s) - ‘/Data/SubX/NCEP/CFSv2/forecast/pr_sfc_CFS_27mar2024_00z_d00_d44_m01.nc’ saved [8212684/8212684]

            # convert any newly uploaded files, that are marked as "saved" in the logfile
            if (/(${var}_CFS_.*m0[1234])\.nc.*saved/) {
                my $basefile = $1;
                my $infile = "${lcldir}/${basefile}.nc";
                my $outfile = "${lcldir}/${basefile}_XYT.nc";
                if (${var} =~  /zg/) {
                    # move the zg files into their own directories
                    $outfile = "${lcldir}/${var}/${basefile}_XYT.nc";
                }
                if (-f $infile) {
                    my $ncpdq_cmd = "/usr/bin/ncpdq -v ${var} -a time,lat,lon ${infile} ${outfile}";
                    printf("${ncpdq_cmd}\n");
                    system($ncpdq_cmd);
                    
                    if ($? != 0) {
                        printf("ERROR, ncpdq command failed\n");
                        unlink($infile) || warn "ERROR: Couldn't remove $infile: $!\n";
                        unlink($outfile) || warn "ERROR: Couldn't remove $outfile: $!\n";
                    } elsif (${var} =~ /zg/) {
                        my $ncrename_cmd = "/usr/bin/ncrename -v ${var},zg ${outfile}";
                        print("${ncrename_cmd}\n");
                        system($ncrename_cmd);
                        if ($? != 0) {
                            printf("ERROR, ncrename command failed\n");
                            unlink($infile) || warn "ERROR: Couldn't remove $infile: $!\n";
                            unlink($outfile) || warn "ERROR: Couldn't remove $outfile: $!\n";
                        }
                    }
                } else {
                    print("ERROR: ${infile} doesn't exist\n");
                }
            }
        }
    }
}

exit;

#!/usr/bin/perl -w
#
# addsndvirgupdate.pl
# January 11, 2005
#
#This script updates dekadal NDVIrg data for Africa, downloaded from the 
#Africa Data Dissemination Service (ADDS) website.
#
#Parts of this script were taken from the script used to download
#SPOT NDVI data.  See the following:
#/home/mbell/perlscripts.d/morespot.pl

use POSIX "ctime";
use LWP::UserAgent;
use HTTP::Request;

$rootdir = "/Data/data6/usgs/adds/ndvi/ndvirg/";
chdir "/Data/data6/usgs/adds/ndvi/ndvirg" or die "Couldn't change local directory (1)\n";

# Need to generate a list of dates (yymmd -- year, month, dekad) that will be used to 
# construct a list
# of filenames to download from the ADDS site.  

# go through directory listing of present files to find the last one available 

# use the current date to construct the name of the newest year directory

%arrnexttmon = ("1","01","2","02","3","03","4","04","5","05","6","06","7","07","8","08","9","09","10","10","11","11","12","12");

$layr = `date "+%y"`;
$yrdirlast = "ndvirg"."$layr";
chomp $yrdirlast;

unless(-e $yrdirlast) { mkdir ($yrdirlast,0755) }

    $maxtdekad=1;
    $maxtmon=4;
    $maxtyear=2005;


# Need a method for searching through directories named by year

    foreach $yrdir (<ndvirg*>) {
      if(($yrdir =~ /ndvirg\d\d/) && (-d $yrdir)) {
        $tdir = "$rootdir"."$yrdir/";
        chomp $tdir;
        opendir (TDIR, "$tdir");
        while (defined ($timefile = readdir (TDIR))){
          if($timefile =~ /AC(\d\d)(\d\d)(\d\d)\.IMG/){
            $syear=$1;
            $month=$2;
	    $imonth = int($month);
            $dekad=$3;
#           if($syear>80){
#               $year="19$syear";
#           }
#           else {
            $year="20$syear";
#           }
            if($year>$maxtyear){
                $maxtdekad=$dekad;
                $maxtmon=$imonth;
                $maxtyear=$year;
            }
            elsif($year == $maxtyear){
                if($imonth > $maxtmon){
                    $maxtdekad=$dekad;
                    $maxtmon=$imonth;
                }
                elsif($month == $maxtmon){
                    if($dekad > $maxtdekad){
                        $maxtdekad=$dekad;
                    }
                }
            }
          }
        }
#       closedir TDIR;
      }
    }
    $nexttdekad = $maxtdekad;
    $nexttmon = $maxtmon;
    $nexttyear = $maxtyear;
    if($nexttdekad < 3){
        $nexttdekad += 1;
    }
    else {
        $nexttdekad = "1";
        if ($nexttmon < 12){
            $nexttmon += 1;
        }
        else {
            $nexttmon = 1;
            $nexttyear +=1;
        }
    }

    $nexttyr = substr($nexttyear, 2, 2);

    print "$nexttmon\n";

    $nyrdir = "$rootdir"."ndvirg"."$nexttyr";
    chomp $nyrdir;

    chdir($nyrdir) or die "Couldn't change local directory (2)\n";

    $filename = "a"."$nexttyr"."$arrnexttmon{$nexttmon}"."$nexttdekad"."nd.zip"; 

#   $filename = "a"."$nexttyr"."$nexttmon"."$nexttdekad"."nd.zip"; 

    chomp $filename;

    print "$filename\n";

    $ua = LWP::UserAgent->new();
    $url = "http://igskmncnwb015.cr.usgs.gov/ftp2/raster/nd/a/$nexttyear/$filename";
    $req= HTTP::Request->new(GET =>$url);
    $res = $ua->request($req,$filename);

    if($res->is_success()) {
      print "$filename has been downloaded";

    # and unzip the downloaded zip file with a system call:

      system "/usr/freeware/bin/unzip $filename"; # rm $filename";
    } else {
      print "No file downloaded";
    }

exit;

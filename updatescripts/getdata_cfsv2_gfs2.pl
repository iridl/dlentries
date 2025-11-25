#! /bin/env perl
# 20130912 adapted for installation of ingrid and version of perl on gfs2 machines

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
use English;
use strict;
use Date::Manip;
use Getopt::Std;
use vars qw($opt_d $opt_m $opt_y $opt_o);
use POSIX qw(strftime);

getopts('d:m:y:o:');

our $AUTOFLUSH = 1;
my $file;

my ( $longyear,$shortyear,$month,$day,$ingridoffset );
#deal with possible explicit time/date from command line
if(defined $opt_o){
    $ingridoffset = $opt_o;
}
else {
    $ingridoffset = "all";
}
if($opt_y or $opt_m or $opt_d) #if any of day, month, year specified...
{   
    print "processing options\n";
    unless ($opt_y or $opt_m or $opt_d) # ...must specify all!
    {die 
	 "if specifying any of day, month, year, must explicitly specify EACH!\n"}
    
    ($day,$longyear,$month) =  ($opt_d,$opt_y,$opt_m);
    
    ($shortyear) = ($longyear =~ /(\d\d)$/); # extract short_year;
}

my ($y2, $m2, $d2,$err);

my $date=DateCalc("$longyear$month$day","- 24hours 0minutes 0 seconds",\$err);
print $date, "\n";
$y2 = substr($date,0,4);
$m2 = substr($date,4,2);
$d2 = substr($date,6,2);
print $y2, $m2, $d2, "\n";



my $dataset="IRIONLY SOURCES .NOAA .NCEP .EMC .CFSv2 .MONTHLY_REALTIME .PGBF";

my ($inoffset,$omax,$omin);
if($ingridoffset eq "all"){
    $omax = 6;
    $omin = 0;
}
else {
    $omax = $ingridoffset;
    $omin = $ingridoffset;
}
for ($inoffset=$omax ; $inoffset >=$omin ; $inoffset--) {
    my $date=DateCalc("now", "- $inoffset days");
    $y2 = UnixDate($date, "%Y");
    $m2 = UnixDate($date, "%m");
    $d2 = UnixDate($date, "%d");
    print $y2, $m2, $d2, "\n";

    my $nextdate=DateCalc($date, "+ 1day",\$err);
    my $nd2 = substr($nextdate,6,2);
    #compute targetfilecount (a guess, not an algorithm yet)
    #           J  F  M  A  M  J  J  A  S  O  N  D
    my @upday=qw(27 27 27 27 27 26 27 27 26 27 27 27);
    my $targetfilecount=1000;
    if($nd2 == 1){
        $targetfilecount=1024;
    }
    elsif($d2 >= $upday[$m2-1]){
        $targetfilecount=1100;
    }

    my $dirSize = 0;
    my $dataParent = "/Data/data22/noaa/ncep/cfsv2/fcst";
    #my @members = ("01","02","03","04");
    my @members = ("00","06","12","18");
    my $member;
    my $start = time;

    foreach $member (@members){
        system("mkdir -p $dataParent/$y2/$m2/$d2/$member");
        
        chdir("$dataParent/$y2/$m2/$d2/$member") or die "Couldn't chdir to output directory\n";

        my $some_dir = "$dataParent/$y2/$m2/$d2/$member";
        
        
        
        print "Start downloading data... $start\n";
        
        grabfile($y2,$m2, $d2, $member);
        
        my $trytimes =1;
        my $looptime=0;

        my $dirsize = dirSize($some_dir); 
        print "dir size = $dirsize\n";
        if ($dirsize <2000000000){
            while ($looptime <5 && $dirsize <2000000000){
                $looptime++;
                #	    system "rm *.grb2";
                my $timeSecond= 60 * 0.5; 
                sleep $timeSecond; #sleep 60*1 seconds
                print "Sleep for $timeSecond seconds! \n" ;
                print "Load file into $some_dir \n" ;
                
                grabfile($y2, $m2, $d2, $member);
                
                $dirsize = dirSize($some_dir);
            }
        }

        my $end = time;
        my $totalTime = $end-$start;
        print "Finished downloading data at $end ";
        print "Finished downloading data in $totalTime seconds.\n";

        print "Completed loading file into $some_dir, size = $dirsize \n" ;

    } #foreach $member
    my $filecount = `find $dataParent/$y2/$m2/$d2/ -type f ! -name filecount  | wc -l`;
    chop $filecount;
    if($filecount >= $targetfilecount){
        if(! -e "$dataParent/$y2/$m2/$d2/filecount" ){
            system("echo $filecount > $dataParent/$y2/$m2/$d2/filecount");
        }
    }
    print "Have $filecount of $targetfilecount files for $y2/$m2/$d2\n";

    sub grabfile {
        foreach $file (getdatafiles("https://nomads.ncep.noaa.gov/pub/data/nccf/com/cfs/prod/cfs.$_[0]$_[1]$_[2]/$_[3]/monthly_grib_01/",qr/.grb2$/)){	
            $dirSize =+ -s $file; }
    }
    sub dirSize {
        my($dir)  = $_[0];
        my($size) = 0;
        my($fd);
        
        opendir($fd, $dir) or die "$!";
        
        for my $item ( readdir($fd) ) {
            next if ( $item =~ /^\.\.?$/ );
            
            my($path) = "$dir/$item";
            
            $size += ((-d $path) ? dirSize($path) : (-f $path ? (stat($path))[7] : 0));
        }
        
        closedir($fd);
        
        return($size);
    }
} #for $inoffset

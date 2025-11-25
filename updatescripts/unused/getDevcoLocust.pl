#!/usr/bin/perl -w
 
#Script to update Vito greenness data 
#Jan 22, 2018


#$gnudate="/ClimateGroup/network/gnu/bin/date";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("locust_vito");

my $lcldir = '/Data/data23/vito/devcolocust/'; 
my $host = 'cvbftp.vgt.vito.be';				#ftp host

$mydirurl = "ftp://$user:$passwd\@cvbftp.vgt.vito.be/"; 

#MCD_GreenArea_20180101_LocustArea.zip is filename pattern needed

#These files are found in directories by date, e.g.:  20180101  20180111 20180121 20180201, etc.

$curdate = `date +%Y%m%d`;
chomp $curdate;

$prevmon = `date -d "1 month ago" +%Y%m`;
chomp $prevmon;

$curmon = `date +%Y%m`;
chomp $curmon;

$curmon01 = $curmon . "01";
chomp $curmon01;

$curmon11 = $curmon . "11";
chomp $curmon11;

$curmon21 = $curmon . "21";
chomp $curmon21; 

$startdate = $prevmon . "21";
chomp $startdate;

@dekads = ($startdate, $curmon01, $curmon11, $curmon21);

print "@dekads\n";

chdir "/Data/data23/vito/devcolocust" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

foreach $datedir (@dekads) {
 if(($datedir + 10) < $curdate) {

  print "$datedir\n";

  $newfiles =  system ("wget --user=$user --password=$passwd -A 'MCD_GreenArea_*_LocustArea.zip' -N -r -l1 -e robots=off --no-parent -nd ftp://$host/$datedir/");

  if($newfiles == 0) {
   $fil = "MCD_GreenArea_" . $datedir . "_LocustArea.zip";
   chomp $fil;

   print "$fil\n";

   system("unzip -u $fil");
# the -u option both allows for existing unzipped files to be replaced and for new files to be unzipped without prompt

  }
 }
}

exit;

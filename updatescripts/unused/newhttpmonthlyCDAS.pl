#!/usr/bin/perl -w

#Script to update monthly NCEP/NCAR Reanalysis values. 
#Modified from script created download EPTOMS aerosol index files 
#May 26, 2005

# test this script in home directory

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
use POSIX "ctime";
#use LWP::UserAgent;
#use LWP::Simple;
#use HTTP::Response;
#use HTTP::Request;
#use HTTP::Date;
#use File::Listing;
#use Net::FTP;

#$gnudate="/ClimateGroup/network/gnu/bin/date";
my $flxdir = '/Data/data6/ncep-ncar/reanI/flux/'; 
my $d6prsdir = '/Data/data6/ncep-ncar/reanI/prs/'; 
my $host = 'nomad1.ncep.noaa.gov';				#ftp host
my $dirlola = qw(/pub/reanalysis-1/month/grb2d.lola/);               #array of directories
my $dirgau = qw(/pub/reanalysis-1/month/grb2d.gau/);               #array of directories
my $dirprs = qw(/pub/reanalysis-1/month/prs/);               #array of directories
@datelist = ();
@newfiles = ();

# get monthly lola CDAS files

chdir "/Data/data6/ncep-ncar/reanI/flux";

@newfiles =  getdatafiles("http://$host$dirlola",qr/(flx.lola.grib.mean.\d\d\d\d\d\d$)/);

if(@newfiles) {

 foreach $fil (<flx.lola.grib.mean.*>) {
    if($fil =~ /flx.lola.grib.mean.(\d\d\d\d\d\d)/) {
        push(@datelist,$1);
    }
 }

 system (" /usr/local/bin/ingrid <<eof
\\begin{ingrid}
(/Data/data6/ncep-ncar/reanI/flux/flx.lola.grib.mean.%6d)
 /tonext {dup 100 mod 12 eq {89 add}{1 add}ifelse}def
 mark $datelist[0]  $datelist[-1]  exch
    null {exch 1 index tonext 2 copy eq {pop leave}if}repeat
counttomark integerarray astore nip
readgrib
(/Data/data6/ncep-ncar/reanI/flux/flx.lola.cuf) writeCUF
\\end{ingrid}
eof") ;

}  # end if(@newfiles)

# get monthly gau CDAS files

@datelist = ();
@newfiles = ();

@newfiles = getdatafiles("http://$host$dirgau",qr/(flx.gau.grib.mean.\d\d\d\d\d\d$)/);

if(@newfiles) {

 foreach $fil (<flx.gau.grib.mean.*>) {
    if($fil =~ /flx.gau.grib.mean.(\d\d\d\d\d\d)/) {
        push(@datelist,$1);
    }
 }

 system (" /usr/local/bin/ingrid <<eof
\\begin{ingrid}
(/Data/data6/ncep-ncar/reanI/flux/flx.gau.grib.mean.%6d)
 /tonext {dup 100 mod 12 eq {89 add}{1 add}ifelse}def
 mark $datelist[0]  $datelist[-1]  exch
    null {exch 1 index tonext 2 copy eq {pop leave}if}repeat
counttomark integerarray astore nip
readgrib
(/Data/data6/ncep-ncar/reanI/flux/flx.gau.cuf) writeCUF
\\end{ingrid}
eof") ;

} # end if(@newfiles)

# get monthly prs CDAS files

chdir "/Data/data6/ncep-ncar/reanI/prs";
@datelist = ();
@newfiles = ();

@newfiles =  getdatafiles("http://$host$dirprs",qr/(prs.grib.mean.\d\d\d\d\d\d$)/);

if(@newfiles) {

 foreach $fil (<prs.grib.mean.*>) {
    if($fil =~ /prs.grib.mean.(\d\d\d\d\d\d)/) {
        push(@datelist,$1);
    }
 }

 system (" /usr/local/bin/ingrid <<eof
\\begin{ingrid}
(/Data/data6/ncep-ncar/reanI/prs/prs.grib.mean.%6d)
 /tonext {dup 100 mod 12 eq {89 add}{1 add}ifelse}def
 mark $datelist[0]  $datelist[-1]  exch
    null {exch 1 index tonext 2 copy eq {pop leave}if}repeat
counttomark integerarray astore nip
readgrib
(/Data/data6/ncep-ncar/reanI/prs/prs.cuf) writeCUF
\\end{ingrid}
eof") ;

} # end if(@newfiles) 

exit;

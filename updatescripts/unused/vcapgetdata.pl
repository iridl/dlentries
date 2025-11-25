#! /bin/env perl
use LWP;
use POSIX "ctime";
use File::Basename;

my $dirname = dirname(__FILE__);
require "$dirname/perl/getdatafiles.pl";

$ua = LWP::UserAgent->new;
  $ua->agent("Data Library Processing");

# run on iridlc5 or iridlc6
chdir "/Data/data21/usgs/edc/vcap/version200906" or die "no output directory";
@filelist = getdatafiles("http://edcftp.cr.usgs.gov/project/fews/vcap_malaria/",qr/.*\....$/);
#@filelist = getdatafiles("ftp://edcftp.cr.usgs.gov/edcuser/bklaver/Malaria/",qr/.*$/);
if($#filelist >= 0) {
    $nfile = 1 + $#filelist;
$msg = <<"EOC";
got $nfile files.
EOC
foreach $file (@filelist){
    $msg .= $file . "\n";
}
print "$nfile VCAP files copied";
print "$msg";

my $res = $ua->request($req);

  # Check the outcome of the response
  if ($res->is_success) {
      print $res->content;
  }
  else {
      print $res->status_line, "\n";
  }
}
# run realizenew on the coarse versions of the dataset
    system("/usr/bin/wget http://iridl.ldeo.columbia.edu/expert/SOURCES/.IRI/.Analyses/.USGS/.VCAP/.eight-day/.v200906/.vcap_coarse/T/last/VALUE/realizenew");
}
#EOF


#! /bin/env perl
use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";

require "$libdir/getdatafiles.pl";

my ($user, $passwd) = get_credential("glosea5");

    $mydirurl="ftp://$user:$passwd\@ftp.metoffice.gov.uk/GloSea/";
$mydir='/Data/data23/ukmo/GloSea5/1x1shift/d' . `date +%Y%m`;
chop $mydir;

$mydirnc = "$mydir" . "nc";
chomp $mydirnc;

$curmon = `date +%m`;
chomp $curmon;

$checkdir = $mydirnc;
if(-d $checkdir){
    print "have $checkdir already\n";
}
else {
    print $mydirnc;
    mkdir($mydirnc);
}

if(-d $checkdir){
    chdir($mydirnc) or die "Couldn't change local directory! (1)\n";
    @newfiles = getdatafilesdirect("$mydirurl",qr/(exeter_\d\d\d\d$curmon\d\d_\d\d\d\d\d\d\d\d_\d\d\d\d\d\d\d\d_run\d\d.nc$)/);
    if(@newfiles) {
	print "downloaded $#newfiles\n";
    }
}

exit;

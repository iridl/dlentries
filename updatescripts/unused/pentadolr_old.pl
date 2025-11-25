#!/usr/bin/perl
# ------------------
# expecting one filename as argument
# ------------------

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("anonymous");

%package = (
PerlMagick => 0,
ImageMagick => 0,
pbmplus => 0,
netpbm => 0,
djpeg => 0,
Ghostscript => 0,
TeX => 0,
dvips => 0,
'libwww-perl' => 1,
jfriedl => 0,
) ;
$sys="sgi62";
# machine that receives the file
$machine="crunch.ldeo.columbia.edu";

$ftpdir="pub/incoming";
$ftpurldir=~s./.%2F.g;
$finaldir="/Data/data8/noaa/cpc/olr";

$url="http://sgi62.wwb.noaa.gov:8080/cgi-bin/ftp2u_p_olra.sh";
&geturl($url,$file);
if(!$file){
print "Return code $code from HTTP\n";
}
else
{
unless(open(IN, '-|'))
# notice that open(IN,'-|') is 0 in the kid process,
# but it equals the kid process' ID in the dad process,
# hence the need for the "unless" above (according to the sage Camel). 
    {
# input process -- feeds ingrid
        if (open(OUT,"|/usr/local/bin/ingrid")) {
            print OUT <<"eof";
\\begin{ingrid}
SOURCES .NOAA .NCEP .CPC .GLOBAL .pentad .olra
  T last
    1 add
    cvsunits
    dup length
     4 sub
     4 getinterval
print (\\n) print
\\end{ingrid}
eof
    close(OUT);
        }
        else {
    print("ingrid failed\n");
        };          
        exit;  # you need to exit the spawned kid process
    };   
	$needyear=<IN>;
	chop $needyear;
	print "Doing year $needyear\n";
    $foundcnt=1;
    $foundfile="pent.olra.y$needyear";
    $url="http://sgi62.wwb.noaa.gov:8080/cgi-bin/ftp2u_p_olra.sh?";
    $url .= "file=$foundfile";
    $url .= "&machine=$machine";
    $url .= "&user=$user";
    $url .= "&passwd=$passwd";
    $url .= "&ftpdir=$ftpdir";
    $url .= "&prefix=";
    &geturl ($url,$file);
    $count=0;
    while($file=~m/Transfer complete/g){
	$count=$count+1;
    }
    if($count > 0){
	print "$count/$foundcnt files transfered\n";
	system("cp /usr/ftp/pub/incoming/$foundfile $finaldir");
	system("cd $finaldir;make olra");
    }
    $foundfile="pent.olr.y$needyear";
    $url="http://sgi62.wwb.noaa.gov:8080/cgi-bin/ftp2u_p_olr.sh?";
    $url .= "file=$foundfile";
    $url .= "&machine=$machine";
    $url .= "&user=$user";
    $url .= "&passwd=$passwd";
    $url .= "&ftpdir=$ftpdir";
    $url .= "&prefix=";
    &geturl ($url,$file);
    $count=0;
    while($file=~m/Transfer complete/g){
	$count=$count+1;
    }
    if($count > 0){
	print "$count/$foundcnt files transfered\n";
	system("cp /usr/ftp/pub/incoming/$foundfile $finaldir");
	system("cd $finaldir;make olr");
    }
}
exit;
sub geturl {
  local($url)=@_;
  &dbg("Retrieving $url");
  if($package{'libwww-perl'} || $package{'jfriedl'}) {
  &dbg(" using www-perl\n");
    &gu();
    if($code==401) {
      &prompt("\nDocument requires username and password\n\nUsername: ",$user);
      &prompt("Password: ",$pass);
      &gu($user,$pass);
    }
    $_[1]=$cont;
  } elsif(defined $geturl) {
    &dbg("...");
    $_[1]=`$geturl '$url'`;
    if($?) {
      &dbg("\n*** Error opening $url\n");
      return 0;
    }
    &dbg("done\n");
    if($_[1]=~/\r?\n\r?\n/) {
      $_[1]=$';
      $dhead=$`;
      ($code)=$dhead=~/HTTP\/\S+ +(\d+)/i;
      ($contyp)=$dhead=~/Content-type:\s+(.*)/i;
    } else {
      $code=500;
    }
  }
  $_[0]=$url;
  $code<300;
}
sub gu {
  if($package{'libwww-perl'}) {
    require LWP::UserAgent;
    $ua=new LWP::UserAgent;
    $ua->timeout(1000*60);
    $req = HTTP::Request->new(GET => $url);
    $req->authorization_basic(@_) if(@_);
    $ua->agent($spoof) if($spoof);
    my $res = $ua->request($req);
    $code=$res->code;
    $contyp=$res->header('content-type');
    $cont=$res->content;
  } else {
    require "www.pl";
    @opts=@_?("authorization=$_[0]:$_[1]"):();
    push(@opts,"quiet") if(!$opt_d);
    $www::useragent=$spoof if($spoof);
    ($status,$memo,%info)=&www::open_http_url(*FILE,$url,@opts);
    $code=$info{'CODE'};
    ($contyp)=$info{'HEADER'}=~/Content-type:\s+(.*)/i;
    $cont=<FILE>;
  }
}
sub dbg {
  print STDERR $_[0];
  print DBG $_[0];
}

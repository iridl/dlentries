# 
# subroutines for getting data via ftp

# getdatafiles ( "ftp://$host$directory",qr/$regexp/);
#
# where $regexp is the regexp for selecting files from the ftp listing

# returns list of changed files.  This means one can say

# foreach $newfile (getdatafiles "ftp://$host$directory",qr/$regexp/)){
# ... work on each file that has been downloaded ...
# }

# currently only parses ftp directories, but that can be fixed

# adapted from Emily's model code  12 Sep 2005  MB/MBB

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use Sys::Hostname;
use File::Listing;
# from USGS get_file.pl
    use Cwd;
    use File::Basename;
    use File::Path qw(make_path);
    use Getopt::Long;
    use HTTP::Cookies;
    use MIME::Base64;
    use Pod::Usage;

    # Set up basic configuration and retrieve command line options

    my $libdir = dirname(__FILE__);
    require "$libdir/credentials.pl";
    my ($uid, $passwd) = get_credential("earthdata_usgs");

    my $uid = "jdcorral";    # Can hard code, not secret
    my $passwd = "J0tul_08"; # Can hard code ONLY if script secured

    my @urls    = ();
    my $urs     = 'urs.earthdata.nasa.gov';

    my @input = ();
    my $quiet = 0;
    my $verbose = 1;
    my $help;
    my $netrc = 0;
    my $dir = getcwd;
    my $cookie_file = "$ENV{HOME}/.cookies.txt";
    my $netrc_file = "$ENV{HOME}/.netrc";

sub parse_dir_proxy {
  local($content)=@_;
  $parse="";
  @localfile=();
  while($content=~/([^\n]*)\n/g){
      $line=$1;
#      print "---$line---\n";
      if($line=~/<PRE>/i){
	  $parse="1";
      }
      if($line=~/<\/PRE>/i){
	  $parse="";
      }
      if($parse){
      if($line =~/^<A HREF="([^".][^"]+)".*((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) +\d+ +(\d\d\d\d|\d+:\d+)) +(\d+)(k|K|m|M)/i){
          $filename=$1;
	  $mtime=$2;
	  $size=$5;
	  $sizeunits=$6;
	  $stime= HTTP::Date::str2time($mtime,'GMT');
	  if($sizeunits eq "k"){
	      $size= $size * 1024;
	  }
	  if($sizeunits eq "K"){
	      $size= $size * 1024;
	  }
	  if($sizeunits eq "m"){
	      $size= $size * 1024 * 1024;
	  }
	  if($sizeunits eq "M"){
	      $size= $size * 1024 * 1024;
	  }
	  push @localfile,[$filename,'f',$size,$stime];
      }
      if($line =~/.+<A HREF="([^"]+)".*(\d\d-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d\d\d\d \d\d:\d\d)/i){
          $filename=$1;
	  $mtime=$2;
	  $size=$5;
	  $sizeunits=$6;
	  $stime= HTTP::Date::str2time($mtime,'GMT');
	  if($sizeunits eq "k"){
	      $size= $size * 1024;
	  }
	  if($sizeunits eq "K"){
	      $size= $size * 1024;
	  }
	  if($sizeunits eq "m"){
	      $size= $size * 1024 * 1024;
	  }
	  if($sizeunits eq "M"){
	      $size= $size * 1024 * 1024;
	  }
	  push @localfile,[$filename,'f',$size,$stime];
      }
      if($line =~/<A HREF="([^".][^"]+)".*(\d\d\d\d-(01|02|03|04|05|06|07|08|09|10|11|12)-\d\d \d\d:\d\d) +(\d+.?\d+)(k|K|m|M)/i){
          $filename=$1;
	  $mtime=$2;
	  $size=$4;
	  $sizeunits=$5;
	  $stime= HTTP::Date::str2time($mtime,'GMT');
	  if($sizeunits eq "k"){
	      $size= $size * 1024;
	  }
	  if($sizeunits eq "K"){
	      $size= $size * 1024;
	  }
	  if($sizeunits eq "m"){
	      $size= $size * 1024 * 1024;
	  }
	  if($sizeunits eq "M"){
	      $size= $size * 1024 * 1024;
	  }
	  push @localfile,[$filename,'f',$size,$stime];
      }
      }
  }
  if($#localfile < 0){
  while($content=~/([^\n]*)\n/g){
      $line = $1;
      if($line=~/<a href=\"([^\"\/]+)\">/i){
	  $filename=$1;
	  push @localfile,[$filename,'f',0,0];
  }
  }
  }
  return (@localfile);
}

sub parse_dir_proxy_dir {
  local($content)=@_;
  $parse="";
  @localfile=();
  while($content=~/([^\n]*)\n/g){
      $line=$1;
#      print "line $line\n";
      if($line=~/<PRE>/i){
	  $parse="1";
      }
      if($line=~/<\/PRE>/i){
	  $parse="";
      }
      if($parse){
      if($line =~/^<A HREF="([^".][^"]+)\/".*((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) +\d+ +(\d\d\d\d|\d+:\d+))/i){
          $filename=$1;
	  $mtime=$2;
	  $size=$5;
	  $sizeunits=$6;
	  $stime= HTTP::Date::str2time($mtime,'GMT');
	  push @localfile,[$filename,'f',$size,$stime];
      }
      if($line =~/.+<A HREF="([^".][^"]+)\/".*(\d\d-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d\d\d\d)/i){
          $filename=$1;
	  $mtime=$2;
	  $size=$5;
	  $sizeunits=$6;
	  $stime= HTTP::Date::str2time($mtime,'GMT');
	  push @localfile,[$filename,'f',$size,$stime];
      }
# check for dirs that are like <a href="2016.05.24/">2016.05.24/</a>
      if($line =~/.+<A HREF="([^".][^"]+)\/".*(\d\d\d\d\-(01|02|03|04|05|06|07|08|09|10|11|12)\-\d\d)/i){
      $filename=$1;
      $mtime=$2;
      $stime= HTTP::Date::str2time($mtime,'GMT');
      push @localfile,[$filename,'f',$size,$stime];
      }
  }
  }
  if($#localfile < 0){
  while($content=~/([^\n]*)\n/g){
      $line = $1;
      if($line=~/<a href=\"([^\"\/]+)\">/i){
	  $filename=$1;
	  push @localfile,[$filename,'f',0,0];
  }
  }
  }
  return (@localfile);
}

sub getdatafiles (&@) {

    my $mydirurl = shift;
    my $myregexp = shift;
    my $user = shift;
    my $password = shift;
    
%uselocalproxy=(
"iridlc3p.ldeo.columbia.edu" => 1,
"iridlc4p.ldeo.columbia.edu" => 1,
"iridlc3.ldeo.columbia.edu" => 1,
"iridlc4.ldeo.columbia.edu" => 1,
"iridlc5.ldeo.columbia.edu" => 1,
"iridlc6.ldeo.columbia.edu" => 1,
#"gfs2geo1.ldeo.columbia.edu" => 1,
#"gfs2geo1" => 1,
#"gfs2mon1.ldeo.columbia.edu" => 1,
#"gfs2mon1" => 1,
		);

  @changedfiles=();

    print $mydirurl,"\n";
my $agent = LWP::UserAgent->new();
$agent->agent("IRI Data Gatherer");
    $agent->timeout(600);
# if password
    if($user){
	if($mydirurl =~ /\/\/([^\/]+)/){
	$host = $1;
    }
    print "using $user for $host\n";
#$agent->credentials("$host:21","","$user" => "$password");
    }
# for running on almost all our machines
    my $host = hostname();
    my $useproxy = true;
    if(!$user){
if($uselocalproxy{$host}){
$agent->proxy(['http','ftp'],'http://localhost:3128/');
}
else {
$agent->proxy(['http','ftp'],'http://iriproxy.iri.columbia.edu:3128/');
}
}
    else {
	$useproxy=false;
    }
    my $credentials = encode_base64("$uid:$passwd", "");


    # Create a user agent to handle the request. We configure a cookie jar
    # for saving the session cookies. Note that 'ignore_discard' is required,
    # otherwise LWP immediately throws away the cookie returned by the Apache
    # URS auth module (it does not even persist it through the redirects).
    # The module gives does not specify a cookie expiration, which means that
    # it *should* last for the duration of the session - i.e. up to the point
    # that the agent object is destroyed. The advantage of this option is that
    # it allows the session to persist across multiple executions - up to the
    # point at which the application decides that the session should end, so
    # it is very efficent.
    # The cookie file is currently named '.cookies.txt', saved in the users
    # home directory. This should be given an application specific name.

    print "Using cookie file '$cookie_file'\n";
    my $agent = LWP::UserAgent->new(
        cookie_jar  => HTTP::Cookies->new(
            file => $cookie_file,
            ignore_discard => 1,
            autosave => 1)
    );


    # SSL certificate verification is disabled. This is usually not necessary in
    # properly configured production systems, but many user environments do not
    # have the necessary certificates configured.

#    $agent->ssl_opts(verify_hostname => 0);


    # Set up a redirection handle for URS. Unlike curl and wget which can be
    # configured to send credentials based entirely on a hostname (no 401
    # required), LWP cannot. Thus we use a handle to detect the redirect
    # to URS and automatically add in the credentials.

    $agent->add_handler(
        request_prepare => sub {
            my($request, $ua, $h) = @_;
            $request->header(Authorization => "Basic $credentials");
        },
        m_host => $urs,
        m_path_prefix => '/oauth/authorize');


    # Add a handler to detect the 'unauthorized' response coming back from URS,
    # and modify the response. This would normally redirect back to the
    # application, which would then return an error back to us (usually a 403).
    # However, unless the application returns very good error message that we
    # can parse, we can't really tell if a 403 response from the server is due
    # to the fact that the user has not authorized the application, or the
    # application has not authorized the user!
    # The handler can be modified as necessary to allow error handling code to
    # pick it up and act appropriately. We also repopulate the 'Location'
    # header with a web URL that can be used to approve the application (a
    # user would need to log in to urs before using this URL).

    $agent->add_handler(
        res_done => sub {
            my($res, $ua, $h) = @_;
            if ($res->code == 302 && $res->header('location') =~ /error=access_denied/) {
                $res->code(403);
                $res->message('Forbidden');
                $res->content('You have not authorized the application providing this data.');

                # Pull out the client ID needed for the application approval URL

                if ($res->request->uri =~ /client_id=([^&]+)/ ) {
                    $res->header('location' => "https://${urs}/approve_app?client_id=${1}");
                }
            }
        },
        m_host => $urs,
        m_path_prefix => '/oauth/authorize');

	$req = HTTP::Request->new(GET => $mydirurl);
#	$res = $ua->request($req);	
	$res = $agent->request($req);	
	
    # Output the response
#        print $res->is_success, "\n";

    if ($res->is_success) {
        # Check to see if there is a content disposition we can use for the
        # output filename. If not, we must use the URL

#        my $regex = '"([^"]+)"';
#        my $filename = basename($url);
#        my $cd = $response->header('Content-Disposition');
#        if ($cd && $cd =~ /filename\s*=\s*$regex/ ) {
#            $filename = $1;
#        }
    }
    else {
        if (1) {
            print STDERR "ERROR: Failed to retrieve resource '$url': ", $res->status_line, "\n";
            print STDERR $res->content, "\n";
            exit(0);
        }


        # If we detect an 'unauthorized' event, we log an error and abort

        if ($res->code == 403 && $res->header('location')) {
            print "Please log in to Earthdata Login and then use the following URL to ";
            print "approve the application.\n";
            print $res->header('location'), "\n";
            exit(0);
        }
    }


#        print $res->header('Content-Type'), "\n";

	$listing=$res->content;

#        print $listing, "\n";
# proxy version of the loop -- parse_dir_proxy is at end of file
	for (parse_dir_proxy($listing)) {	#parse directory listing to get filenames
# non proxy version of the loop
#	for (parse_dir($listing)) {	#parse directory listing to get filenames

		($filename, $type, $size, $mtime)=@$_;
if($filename =~ /$myregexp/) {

    $filenom = $filename;
    $filenom =~ s/.(gz|Z)$//;

    if ( -e $filename ){
		$modtime = (stat("$filename"))[9];	#gives modtime the time of last modification of current version of file
    }
    elsif ( -e $filenom ) {
		$modtime = (stat("$filenom"))[9];	#gives modtime the time of last modification of current version of uncompressed file
    }
    else {
	$modtime=1;	#creates generic modtime so new files will be downloaded
    }
	       

# checks time of local copy again time in directory listing
# parse dir proxy returns mtime 0 if an http url

		if($mtime && $modtime>=$mtime){
		    print "$filename not changed: " ,  HTTP::Date::time2str($modtime) , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		else {
		    if($mtime && $modtime!=1){
		    print "$filename seems changed: " ,  HTTP::Date::time2str($modtime) , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		    elsif($mtime && $modtime==1){
		    print "$filename status: " ,  "not " , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		    elsif(!$mtime){
		    print "$filename might be changed: " ,  HTTP::Date::time2str($modtime) , " here vs (not sure) there\n";
		}
		my $url = "$mydirurl$filename";
#		    print $credentials,"\n";
		my $req = HTTP::Request->new(GET => $url);
		$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime));
		$res = $agent->request($req,"$filename.tmp");	#download file based on date of modification
    # Output the response

    if ($res->is_success) {
        # Check to see if there is a content disposition we can use for the
        # output filename. If not, we must use the URL

#        my $regex = '"([^"]+)"';
#        my $filename = basename($url);
#        my $cd = $response->header('Content-Disposition');
#        if ($cd && $cd =~ /filename\s*=\s*$regex/ ) {
#            $filename = $1;
#        }
    }
    else {
        if (1) {
            print STDERR "ERROR: Failed to retrieve resource '$url': ", $res->status_line, "\n";
            print STDERR $res->content, " in getting file\n";
            exit(0);
        }


        # If we detect an 'unauthorized' event, we log an error and abort

        if ($res->code == 403 && $res->header('location')) {
            print "Please log in to Earthdata Login and then use the following URL to ";
            print "approve the application.\n";
            print $res->header('location'), "\n";
            exit(0);
        }
    }
		    if($res->last_modified){
			$mtime = $res->last_modified;
		    }
		    if($res->code eq 304){	
			print "$filename:  not modified\n";
		    }

		elsif ($res->is_success()) {
		    if ( -e $filename) {unlink $filename;}
		    link "$filename.tmp", $filename;
		    unlink "$filename.tmp";
			print "$filename : Latest version (",HTTP::Date::time2str($mtime),") has been downloaded.\n";
			if($filename =~ /\.(gz|Z)$/){
			    system("gunzip -f $filename");
			    push @changedfiles,$filenom;
			}
			else {
			    push @changedfiles,$filename;
			}
		utime $mtime, $mtime, $filenom;	#sets access and modification time to that of remote file
# try to not annoy NOAA
			sleep 2;
		}
		else {
		    if($res->last_modified == $modtime){
			print "$filename : File has not been modified.\n";
		    }
		    else {
			print "$filename : operation failed.\n";
		    }
		}
	    }

            }       #end of "if filename matches all_products.bin..."
	}						#end parse loop
  return (@changedfiles);
    }
return(1);
sub getdatafilesdirect (&@) {
    my $mydirurl = shift;
    my $myregexp = shift;
    my $user = shift;
    my $password = shift;

  @changedfiles=();
    print $mydirurl,"\n";
my $ua = LWP::UserAgent->new();
$ua->agent("IRI Data Gatherer");
    $ua->timeout(600);
# if password
    if($user){
	if($mydirurl =~ /\/\/([^\/]+)/){
	$host = $1;
    }
    print "using $user for $host\n";
$ua->credentials($host,"$user" => "$password");
    }

    my $host = hostname();
    print "Running on $host\n";
# for running on almost all our machines
#$ua->proxy(['http','ftp'],'http://iriproxy:3128/');
# for running on our data library servers (they have their own proxies, and cannot talk to iriproxy)
#$ua->proxy(['http','ftp'],'http://localhost:3128/');

	$req = HTTP::Request->new(GET => $mydirurl);
	$res = $ua->request($req);	
	
	$listing=$res->content;
    print $res->code,' ', $res->message,$listing;
# non proxy version of the loop
	for (parse_dir($listing)) {	#parse directory listing to get filenames

		($filename, $type, $size, $mtime)=@$_;
if($filename =~ /$myregexp/) {

    $filenom = $filename;
    $filenom =~ s/.(gz|Z)$//;

    if ( -e $filename ){
		$modtime = (stat("$filename"))[9];	#gives modtime the time of last modification of current version of file
    }
    elsif ( -e $filenom ) {
		$modtime = (stat("$filenom"))[9];	#gives modtime the time of last modification of current version of uncompressed file
    }
    else {
	$modtime=1;	#creates generic modtime so new files will be downloaded
    }
	       

# checks time of local copy again time in directory listing
		if($modtime>=$mtime){
		    print "$filename not changed: " ,  HTTP::Date::time2str($modtime) , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		else {
		    if($modtime!=1){
		    print "$filename seems changed: " ,  HTTP::Date::time2str($modtime) , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		my $url = "$mydirurl$filename";

		my $req = HTTP::Request->new(GET => $url);
		$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime));
		$res = $ua->request($req,"$filename.tmp");	#download file based on date of modification
		
		if ($res->is_success()) {
		    if ( -e $filename) {unlink $filename;}
		    link "$filename.tmp", $filename;
		    unlink "$filename.tmp";
			print "$filename : Latest version has been downloaded.\n";
			if($filename =~ /\.(gz|Z)$/){
			    system("gunzip -f $filename");
			    push @changedfiles,$filenom;
			}
			else {
			    push @changedfiles,$filename;
			}
		utime $res->last_modified, $res->last_modified, $filenom;	#sets access and modification time to that of remote file
# try to not annoy NOAA
			sleep 10;
		}
		else {
		    if($res->last_modified == $modtime){
			print "$filename : File has not been modified.\n";
		    }
		    else {
			print "$filename : operation failed.\n";
		    }
		}
	    }

            }       #end of "if filename matches all_products.bin..."
	}						#end parse loop
  return (@changedfiles);
}
sub getdatadirectories (&@) {

    my $mydirurl = shift;
    my $myregexp = shift;
    
%uselocalproxy=(
"iridlc3p.ldeo.columbia.edu" => 1,
"iridlc4p.ldeo.columbia.edu" => 1,
"iridlc3.ldeo.columbia.edu" => 1,
"iridlc4.ldeo.columbia.edu" => 1,
"iridlc5.ldeo.columbia.edu" => 1,
"iridlc6.ldeo.columbia.edu" => 1,
"gfs2geo1.ldeo.columbia.edu" => 1,
"gfs2mon1.ldeo.columbia.edu" => 1,
		);

  @changedfiles=();

    print "getdatadirectories $mydirurl\n";
my $ua = LWP::UserAgent->new();
$ua->agent("IRI Data Gatherer");
    $ua->timeout(600);
# for running on almost all our machines
    my $host = hostname();
if($uselocalproxy{$host}){
$ua->proxy(['http','ftp'],'http://localhost:3128/');
}
else {
$ua->proxy(['http','ftp'],'http://iriproxy.iri.columbia.edu:3128/');
}

	$req = HTTP::Request->new(GET => $mydirurl);
	$res = $ua->request($req);	
	$listing=$res->content;
# proxy version of the loop -- parse_dir_proxy is at end of file
	for (parse_dir_proxy_dir($listing)) {	#parse directory listing to get filenames
# non proxy version of the loop
#	for (parse_dir($listing)) {	#parse directory listing to get filenames

		($filename, $type, $size, $mtime)=@$_;

if($filename =~ /$myregexp/) {
    push @changedfiles,$filename;
}
	}						#end parse loop
  return (@changedfiles);
}
sub makedatadirectories (&@) {

    my $mydirurl = shift;
    my $myregexp = shift;
    
%uselocalproxy=(
"iridlc3p.ldeo.columbia.edu" => 1,
"iridlc4p.ldeo.columbia.edu" => 1,
"iridlc3.ldeo.columbia.edu" => 1,
"iridlc4.ldeo.columbia.edu" => 1,
"iridlc5.ldeo.columbia.edu" => 1,
"iridlc6.ldeo.columbia.edu" => 1,
"gfs2geo1.ldeo.columbia.edu" => 1,
"gfs2mon1.ldeo.columbia.edu" => 1,
		);

  @changedfiles=();

    print "makedatadirectories $mydirurl\n";
my $ua = LWP::UserAgent->new();
$ua->agent("IRI Data Gatherer");
    $ua->timeout(600);
# for running on almost all our machines
    my $host = hostname();
if($uselocalproxy{$host}){
$ua->proxy(['http','ftp'],'http://localhost:3128/');
}
else {
$ua->proxy(['http','ftp'],'http://iriproxy.iri.columbia.edu:3128/');
}

	$req = HTTP::Request->new(GET => $mydirurl);
	$res = $ua->request($req);	
	
	$listing=$res->content;
# proxy version of the loop -- parse_dir_proxy is at end of file
	for (parse_dir_proxy_dir($listing)) {	#parse directory listing to get filenames
# non proxy version of the loop
#	for (parse_dir($listing)) {	#parse directory listing to get filenames

		($filename, $type, $size, $mtime)=@$_;
if($filename =~ /$myregexp/) {

    if ( -e $filename ){
		$modtime = (stat("$filename"))[9];	#gives modtime the time of last modification of current version of file
    }
    elsif ( -e $filenom ) {
		$modtime = (stat("$filenom"))[9];	#gives modtime the time of last modification of current version of uncompressed file
    }
    else {
	$modtime=1;	#creates generic modtime so new files will be downloaded
    }
	       

# checks time of local copy again time in directory listing
		if($modtime>=$mtime){
		    print "$filename not changed: " ,  HTTP::Date::time2str($modtime) , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		else {
		    if($modtime!=1){
		    print "$filename seems changed: " ,  HTTP::Date::time2str($modtime) , " here vs ",HTTP::Date::time2str($mtime)," there\n";
		}
		    if (! -e $filename) {mkdir "$filename";}
		utime $mtime, $mtime, $filename;	#sets access and modification time to that of remote file
    push @changedfiles,$filename;
		}
}
	}						#end parse loop
  return (@changedfiles);
}
return(1);

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
use File::Basename;

my $libdir = dirname(__FILE__);
require "$libdir/credentials.pl";

sub parse_dir_proxy {
    local($content)=@_;
    $parse="";
    @localfile=();
    while($content=~/([^\n]*)\n/g){
        $line=$1;
        if($line=~/<PRE>/i){
            $parse="1";
        }
        if($line=~/<\/PRE>/i){
            $parse="";
        }
        if($parse){
            #      print "---$line---\n";
            if($line =~/^<A HREF="([^".][^"]+)".*((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) +\d+ +(\d\d\d\d|\d+:\d+)) +(\d+)(k|K|m|M)/){
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
            if($line =~/.*<A HREF="([^"]+)".*(\d\d-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-\d\d\d\d \d\d:\d\d)/i){
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
        }
    }
    if($#localfile < 0){
        while($content=~/([^\n]*)\n/g){
            $line = $1;
            #  changed pattern match, since usgs started added a / to the end of the dir name
            #      if($line=~/<a href=\"([^\"\/]+)\">/i){
            if($line=~/<a href=\"([^\"]+)\">/i){
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
        "gfs2geo1.ldeo.columbia.edu" => 1,
        "gfs2geo1" => 1,
        "gfs2mon1.ldeo.columbia.edu" => 1,
        "gfs2mon1" => 1,
        );

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
        $ua->credentials("$host:21","","$user" => "$password");
    }
    # for running on almost all our machines
    my $host = hostname();
    if(!$user){
        if($uselocalproxy{$host}){
            print "using proxy localhost:3128\n";
            $ua->proxy(['http','ftp'],'http://localhost:3128/');
        }
        else {
            print "using proxy iriproxy:3128\n";
            $ua->proxy(['http','ftp'],'http://iriproxy.iri.columbia.edu:3128/');
        }
    }
    else {
        print "not using proxy\n";
    }
    $req = HTTP::Request->new(GET => $mydirurl);
    $res = $ua->request($req);
    if (!$res->is_success) {
        print "failed GET $mydirurl\n";
        print $res->content, "\n";
        return ();
    }
    
    $listing=$res->content;
    my @remotefiles = parse_dir_proxy($listing); # parse directory listing to get filenames and mod times
    print "listed ", scalar(@remotefiles), " remote files\n";
    for (@remotefiles) {

        ($filename, $type, $size, $mtime)=@$_;
        if($filename =~ /$myregexp/) {
            print "filename $filename matches\n";
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

		my $req = HTTP::Request->new(GET => $url);
		$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime));
		$res = $ua->request($req,"$filename.tmp");	#download file based on date of modification
                if($res->last_modified){
                    $mtime = $res->last_modified;
                }
                if($res->code eq 304){	
                    print "$filename:  not modified\n";
                }

		elsif ($res->is_success() &&
                       ! $res->header("X-Died") &&
                       ! $res->header("Client-Abort")) {
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
                    print($res->headers_as_string, "\n");
		    if($res->last_modified == $modtime){
			print "$filename : File has not been modified.\n";
		    }
		    else {
			print "$filename : operation failed.\n";
		    }
		}
	    }

        } else { #end of "if filename matches ..."
             print "filename $filename doesn't match\n";
        }     
    }						#end parse loop
    print "end of getdatafiles\n";
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

#! /usr/bin/env perl
$dirname="modisAF";
chdir "/crunch/c7/data8/usgs/landdaac/";
$rerun="getmodisAF.rerun";
$nowfile="getmodisAF.now";
#Tiles:
#       h17v5, h18v5, h19v5, h20v5, h21v5, h22v5, h23v5, h24v5, h25v5, h26v5
#h16v6, h17v6, h18v6, h19v6, h20v6, h21v6, h22v6, h23v6, h24v6, h25v6, h26v6
#h16v7, h17v7, h18v7, h19v7, h20v7, h21v7, h22v7, h23v7, h24v7, h25v7, h26v7
#h16v8, h17v8, h18v8, h19v8, h20v8, h21v8, h22v8, h23v8,        h25v8, h26v8

@tiles=(
       "17,05", "18,05", "19,05", "20,05", "21,05", "22,05", "23,05", "24,05", "25,05", "26,05",
"16,06", "17,06", "18,06", "19,06", "20,06", "21,06", "22,06", "23,06", "24,06", "25,06", "26,06",
"16,07", "17,07", "18,07", "19,07", "20,07", "21,07", "22,07", "23,07", "24,07", "25,07", "26,07",
"16,08", "17,08", "18,08", "19,08", "20,08", "21,08", "22,08", "23,08",        "25,08", "26,08",
"19,09", "20,09", "21,09",
"19,10", "20,10", "21,10",
"19,11", "20,11", "21,11",
"19,12", "20,12",
	);

$ntiles = $#tiles + 1;

    if (-f "$nowfile"){
	unlink "$nowfile";
    }
if(@ARGV){
# dates are in format YYYY.mm.dd, e.g. 2004.11.01
    $neededdate=$ARGV[0];
    $enddate=$ARGV[1];
}
else {
#    $dataset="SOURCES .USGS .LandDAAC .MODIS .Madagascar .NDVI";
    $dataset="SOURCES .USGS .LandDAAC .MODIS .WAF .NDVI";
# if dates not given, uses ingrid entry and current time, or rerun file
    if (-f "$rerun"){
	link "$rerun", "$nowfile";
    }
    else {
# only runs if expiration time is passed
$expires=askingrid("$dataset .expires ==");
if($expires > time){
    exit;
}
    $enddate=`date +"%Y.%m.%d"`;
    chop $enddate;
#
#gets start date from ingrid
#
$neededdate=askingrid("$dataset T last dup subgrid
(%Y.%m.%d) strftimes data.ch");
}
}
print "Requesting $neededdate to $enddate\n";
if (! -f "$nowfile"){
open(out,"> $nowfile");
print out << "eof";
MOD13Q1.005	#input dataset and version
$neededdate	# start date
$enddate	# end date
eof
foreach $tile (@tiles){
$mytile=$tile;
$mytile =~ s/,/, /;
print out "$mytile\n";
}
close(out);
}
system("cat $nowfile ; mkdir $dirname");
chdir "modextract";
open(in,"./MODextract ../$nowfile ../$dirname |");
%dates=();
while(<in>){
    if(/Transferring file +(\d\d\d\d\.\d\d\.\d\d)\/[^ ]+A(\d\d\d\d)(\d\d\d)\./){
	$date=$1;
	$filename="A$2$3";
	$year="$2";
	$day="$3";
	print "Using $filename for $date\n";
	$dates{"$filename"}=$date;
    }
print ;
}
chdir "..";
foreach $set (keys %dates){
open(listin,"ls -1 $dirname/*$set* |");
$cnt=0;
%have=();
while(<listin>){
$cnt++;
print;
if(/\.h(\d\d)v(\d\d)\./){
$htile=$1;
$vtile=$2;
$tile="$htile,$vtile";
print "adding $tile\n";
$have{$tile}=$tile;
}
}
close(listin);
    if($cnt != $ntiles){
    print "only got $cnt tiles of $ntiles -- not processing\n";
unlink "$rerun";
open(out,"> $rerun");
$mydate=$dates{"$set"};
print out << "eof";
MOD13Q1.005	#input dataset and version
$mydate	# start date
$mydate	# end date
eof
foreach $tile (@tiles){
$htile="";
$vtile="";
if($tile=~/(\d\d), *(\d\d)/){
$htile=$1;
$vtile=$2;
}
if($have{$tile}){
print "already have $tile for $date ($set)\n";
}
else 
{
print "still need $tile for $date ($set)\n";
$tile =~ s/,/, /;
print out "$tile\n";
}
}
close(out);
}
else {
    if (-f "$rerun"){
    unlink "$rerun";
}
    system("./processdataAF $set");
}
}
exit;
sub askingrid {
    my ($ask) = @_;
    my $returnvalue;
#
# funky perl -- splits into two processes that talk to each other
    unless(open(IN, '-|'))
    { 
# input (kid) process: runs ingrid
# notice that open(IN,'-|') is 0 in the kid process,
# but it equals the kid process' ID in the dad process,
# hence the need for the "unless" above (according to the sage Camel).
	if (open(OUT,"|/usr/local/bin/ingrid")) {
	    print OUT <<"eof";
	print out <<"eoc";
to get beyond last known date from ingrid
\\begin{ingrid}
defHTMLwords HTMLwords
$ask
\\end{ingrid}
eof
    close(OUT);
	}
	else {
    print("ingrid failed\n");
	};
	exit;  # you need to exit the spawned kid process
    };
# output (dad) process: reads output of ingrid
# ... dad listens to the kid, but allways has the final word ...
    $returnvalue=<IN>;
    close(IN);
    $returnvalue=~ s/[\r]?[\n]?$//;
    return $returnvalue;
}

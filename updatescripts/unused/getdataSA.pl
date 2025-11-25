#! /usr/bin/env perl
$dirname="modisSA.2004";
chdir "/crunch/c7/data8/usgs/landdaac/";

@tiles=(
"09,07",
"09,08",
"09,09",
"10,07",
"10,08",
"10,09",
"10,10",
"11,07",
"11,08",
"11,09",
"11,10",
"11,11",
"11,12",
"12,07",
"12,08",
"12,09",
"12,10",
"12,11",
"12,12",
"12,13",
"13,08",
"13,09",
"13,10",
"13,11",
"13,12",
"13,13",
"13,14",
"14,09",
"14,10",
"14,11",
"14,14",
	);

    if (-f "getmodisSA.now"){
	unlink "getmodisSA.now";
    }
if(@ARGV){
# dates are in format YYYY.mm.dd, e.g. 2004.11.01
    $neededdate=$ARGV[0];
    $enddate=$ARGV[1];
}
else {
    $dataset="SOURCES .USGS .LandDAAC .MODIS .SSA .NDVI";
#    $dataset=" home .benno .USGS .landdaac .SA1 .NDVI";
# if dates not given, uses ingrid entry and current time, or rerun file
    if (-f "getmodisSA.rerun"){
	link "getmodisSA.rerun", "getmodisSA.now";
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
if (! -f "getmodisSA.now"){
open(out,"> getmodisSA.now");
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
system("cat getmodisSA.now ; mkdir $dirname");
chdir "modextract";
open(in,"./MODextract ../getmodisSA.now ../$dirname |");
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
    if($cnt != 31){
    print "only got $cnt tiles of 31 -- not processing\n";
unlink "getmodisSA.rerun";
open(out,"> getmodisSA.rerun");
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
    if (-f "getmodisSA.rerun"){
    unlink "getmodisSA.rerun";
}
    system("./processdataSA $set");
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

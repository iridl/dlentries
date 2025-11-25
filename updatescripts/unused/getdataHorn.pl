#! /usr/bin/env perl
$dirname="modisHorn.2004";
chdir "/crunch/c7/data8/usgs/landdaac/";

if(@ARGV){
# dates are in format YYYY.mm.dd, e.g. 2004.11.01
    $neededdate=$ARGV[0];
    $enddate=$ARGV[1];
}
else {
# if dates not given, uses ingrid entry and current time
# only runs if expiration time is passed
$expires=askingrid("SOURCES .USGS .LandDAAC .MODIS .Horn_of_Africa .image .expires ==");
if($expires > time){
    exit;
}
    $enddate=`date +"%Y.%m.%d"`;
    chop $enddate;
#
#gets start date from ingrid
#
$neededdate=askingrid("SOURCES .USGS .LandDAAC .MODIS .Horn_of_Africa  .image 
T last dup subgrid
(%Y.%m.%d) strftimes data.ch");
print "Requesting $neededdate to $enddate\n";
}
open(out,"> getmodisHorn.now");
print out << "eof";
MOD13Q1.005	#input dataset and version
$neededdate	# start date
$enddate	# end date
20, 07 08
21, 07 08
22, 07 08 
eof
close(out);
system("mkdir $dirname");
chdir "modextract";
open(in,"./MODextract ../getmodisHorn.now ../$dirname |");
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
$cnt = `ls -l $dirname/*$set* | wc -l`;
chop $cnt;
    if($cnt != 6){
    print "only got $cnt tiles of 6 -- not processing\n";
}
else {
    system("./processdataHorn $set");
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

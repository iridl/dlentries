# pass a string to ingrid and get back the results
# presence of  optional second argument will process result to remove \r\n and trailing spaces
sub askingrid {
    my $ask = shift;
    my $clean = shift;
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
undef $/;
    $returnvalue=<IN>;
    close(IN);
    print $clean;
if($clean){
    $returnvalue=~ s/[\r]?[\n]/ /g;
    $returnvalue=~ s/ +$//g;
}
    return $returnvalue;
}
return(1);

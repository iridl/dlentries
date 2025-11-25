#! /usr/bin/perl -w

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";


$GNUDATE="/bin/date";
@MONTHS = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
$datadir = "/Data/data5/noaa/cpc/CAMS";
chdir $datadir or die;

if (defined($ARGV[0]) and $ARGV[0] eq 'test') {
    test();
} else {
    main();
}


sub main {
    print "Updating $datadir\n";

    $check = 0;
    foreach $newfile (getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd52mh/", qr/grid\d\d\d\d$/)) {

        if($newfile =~ /grid(\d\d\d\d)$/) {
            $check = 1;
            $year = $1;
            open(my $in, "<", "grid$year") or die;
            open(my $out, "+<:raw", "gradstempgfs.bi") or die;
            my $newdate = augment($year, $in, $out);
            close($in);
            close($out);
            $olddate=`$GNUDATE -d"2 month ago" +"%b %Y"`;
            chomp $olddate;
            if( "$olddate" eq "$newdate" ){
                print "grid$year has been updated, but only goes through $newdate.\n";
            }
        }
    }
    if($check == 0) {
        print "file not yet updated\n";
    }
}


# Addds new data from a one-year file $in to an existing multi-year file $out.
sub augment {

    my $ncols = 180;
    my $nrows = 91;

    my $recl = $ncols*$nrows*4; # record length

    my ($year, $in, $out) = @_;
    my $month;
    while (<$in>) {
        my $internal_year;
        ($internal_year, $month) = unpack("a4 a4");
        $internal_year == $year or die;
        print "$year $month\n";
        $month -= 1; # change from 1-based to 0-based indexing

        my @temps;
        $#temps = $ncols * $nrows - 1;
        for my $row (0 .. $nrows-1) {
            defined($_ = <$in>) or die;
            @temps[$row*$ncols .. ($row+1)*$ncols-1] = unpack("(a7)*");
        }

        for my $row (0...$nrows-1) {
            defined($_ = <$in>) or die;
            my @xn = unpack("(a7)*");
            for my $col (0 .. $ncols-1) {
                if ($xn[$col] == 0) {
                    $temps[$row*$ncols + $col] = -9999.0;
                }
            }
        }

        my $rec = pack("f*", @temps); # l = signed long (32-bit) value
        my $offset_months = ($year - 1950)*12 + $month;
        my $offset_bytes = $offset_months * $recl;
        seek($out, $offset_bytes, 0);
        print $out $rec;
    }
    my $monthname = $MONTHS[$month];
    return "$monthname $year";
}

# Starts with a state from 2016, applies all the updates from
# 2016-2020, compares to the result of the previous update script at
# the beginning of 2021.
sub test {
    print "Running in test mode, not updating the dataset.\n";
    my $tempfile = '/tmp/test_update_tempgrid.bi';
    system("cp gradstempgfs.bi.Sep2016 $tempfile") == 0 or die;
    open(my $out, "+<:raw", $tempfile) or die;
    for my $y (2016..2020) {
        open(my $in, "<", "grid$y") or die;
        augment($y, $in, $out);
        close($in);
    }
    close($out);
    my $result = system("diff gradstempgfs.bi.Dec2020 $tempfile");
    system("rm $tempfile") == 0 or print "Warning: couldn't clean up temp file $tempfile\n";
    die "test failed" if $result != 0;
    print "success\n";
}


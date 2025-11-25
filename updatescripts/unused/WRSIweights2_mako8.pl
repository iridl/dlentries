#! /usr/bin/perl -w

use LWP::Simple qw($ua getstore get is_success is_error);
use LWP::UserAgent;

 $indextex="/Data/data1/DataCatalog/entries/IRI/FD/Seasonal_Forecast/Precipitation";

 $dataghtml="/beluga/data/datag/iri_html/WFP/RiskView";

 $gnudate="date";

# change working directory to /Data/data6

  chdir "/Data/data6/WFP/RiskView";

  system("rm $dataghtml/*Forecast.csv");

# need to specify the issue month of the IRI seasonal forecast (month and year)
# get this from the IRI seasonal forecast data set entry.  This script will be
# set to run after the latest seasonal forecast normally becomes available

 open(in5,"$indextex/index.tex") || die "cannot open index.tex for reading";
  while(<in5>){
   if(m/enddate/){
    $lastdatestuff = $_;
    $lastdatestuff =~ m/\d\d (...) (\d\d\d\d) ensotime %enddate/;
    $mon = $1;
    $yr = $2;
   }
  }
 close(in5); 

#$mon = 'Aug';
#$yr = '2010';

# start a loop through the various region/season values (7 of them)

# for each region/season, for the given IRI seasonal forecast issue date, figure
# out from the forecast schedule if forecast weights should be produced.  If so,
# 1.  correctly assign the correct region code
# 2.  correctly assign the correct X and Y ranges to use in the forecast and observations
#     sections of the code based upon the region selected
# 3.  determine the correct forecast leads to use
# 4.  determine the correct multiplying factor (0, 1, 2, etc.) to multiply by 33.333
#     for the number of 3-month seasons past the 4th IRI seasonal forecast lead that
#     are within the agricultural season of interest.  These are needed in the 
#     calculation of average forecast probabilities when the agri. season is longer
#     than the reach provided by the IRI seasonal forecast leads
# 5.  determine the value of the denominator to use in the calculation of the average
#     forecast probabilities for the agricultural season of interest
# 6.  use the issue month and year of the IRI seasonal forecast to determine the 
#     month and year range edges to use in the Net Assessment Observations section
#     of the code
# 7.  use the issue month to determine the month edges to
#     use in the seasonalAverage commands
# 8.  Generate the URL for the csv file for a given season/region
# 9.  Once the csv file for a season/region has been generated, read it in and split
#     it out into separate files for each country, using the Perl filehandle to 
#     direct these files to /beluga/data/datag/iri_html/WFP/RiskView
#
# Can use hashes to do most of this

 my @regs = qw(EA1 EAR1 EA2 EAR2 EA3 WA SA);

 foreach $region (@regs){

  if (($region =~ /EA1/) || ($region =~ /EAR1/)) {

   # EA1 runs from 1 Feb to 20 Jul; EAR1 from 1 Feb to 31 Jul - fcst seasons FMA,MAM,AMJ,MJJ; partial JJA
   # need to check the forecast issue date here and specify if a set of weights should be
   # calculated; if so, continue; if not, go on to the next region

   if (($mon =~ /Jan/) || ($mon =~ /Feb/) || ($mon =~ /Mar/) || ($mon =~ /Apr/) || ($mon =~ /May/) || ($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {

    print "$region\n";

    # assign region code to use in geometry data set specification
    $reggeom = "ea";

    # assign values for range edges of spatial domain
    $xw = "12.";
    $xe = "54.";
    $ys = "-18.";
    $yn = "31.";

    # assign values for range edges in evengridAverage commands
    $xwev = 11.25;
    $xeev = 53.75;
    $ysev = -17.75;
    $ynev = 30.75; 

    # determine range edges of leads to use based upon forecast date
    %firstlead = qw(Jan 1 Feb 1 Mar 1 Apr 1 May 1 Oct 4 Nov 3 Dec 2);
    %lastlead = qw(Jan 4 Feb 3 Mar 2 Apr 1 May 1 Oct 4 Nov 4 Dec 4);

    # determine the factor to multiply by 33.333 for each $mon
    %ecfactor = qw(Jan 0 Feb 0 Mar 0 Apr 0 May 0 Oct 3 Nov 2 Dec 1);

    # determine the denominator that specifies the number of seasons over which the average forecast
    # probabilities are being taken
    %denom = qw(Jan 4 Feb 3 Mar 2 Apr 1 May 1 Oct 4 Nov 4 Dec 4);

    # determine the start and end months to specify before taking seasonal average of historical data
    #$stmonhist = "Jan";

    %stmonhist = qw(Jan Mar Feb Apr Mar May Apr Jun May Jul Oct Mar Nov Mar Dec Mar);
    $styrhist = 1995; 
    $endmonhist = "Jul";
    if(($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {
     $endyrhist = $yr;
    } else {
     $endyrhist = $yr - 1;
    }

    # determine the start and end months to specify within the seasonal average itself
    %stmonseas = qw(Jan Feb Feb Mar Mar Apr Apr May May Jun Oct Feb Nov Feb Dec Feb);
    $endmonseas = "Jul";

    # for final file output, associate number of month with start and end months of season
    %stmonseasnum = qw(Jan 2 Feb 3 Mar 4 Apr 5 May 6 Oct 2 Nov 2 Dec 2);
    $endmonseasnum = 7;

    # determine the start and end months and years to specify for base period
    $stmonbp = "Jan";
    $styrbp = 1981;
    $endmonbp = "Jul";
    $endyrbp = 2010;

    print "$stmonseas{$mon}\n";
    print "$endmonseas\n";
#   print "$firstlead{$mon}\n";
#   print "$lastlead{$mon}\n";

    # construct URL with help of variables, and use LWP to download as csv table

    my $url = "http://iridl.ldeo.columbia.edu/expert/ds:/SOURCES/.IRI/.FD/.Seasonal_Forecast/.Precipitation/.prob/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/F/%28$mon%20$yr%29VALUE/L/$firstlead{$mon}/$lastlead{$mon}/RANGE/33.33333/replaceNaN%5BL%5Dsum/33.33333/$ecfactor{$mon}/mul/add/$denom{$mon}/div/0.01/mul/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/T/%28$stmonhist{$mon}%20$styrhist%29%28$endmonhist%20$endyrhist%29RANGE/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonbp%20$styrbp%29%28$endmonbp%20$endyrbp%29RANGE/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage%5BT%5D0/0.33/0.67/1./0.8/replacebypercentile%5Bpercentile%5Dboundedtablefunction/%7BBelow_Normal/0.33/Normal/0.67/Above_Normal%7D//C/classify/a:/:a:%5BT%5Dsum/0/maskle/:a/mul/a:%5BC%5D1./average/dataflag/0/maskle/:a:/0/maskle/4/index/exch/div%5BC%5Dmaxover/:a/mul/T/npts/nip/1./exch/div/replaceNaN/X/$xwev/0.5/$xeev/evengridAverage/Y/$ysev/0.5/$ynev/evengridAverage/home/.mbell/.GISupload/.RiskView/.Mar2010shapes/.val_ea_20100317_final/.geometry/.the_geom%5BX/Y%5Dweighted-average//name//weights/def//long_name/%28Weights%29def/dup%5BT%5Dsum/div/T/npts/nip/1./exch/div/replaceNaN/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.area//long_name/%28Area%29def/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.country//long_name/%28Country%29def/home/.mbell/.WFP/.RiskView/.Season/N/%28$region%29VALUE/:ds/mark/Season/T/country/area/weights/table:/mark/:table/.csv";


    $fname = "weights_" .  "$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "fcst.csv";
    print "$fname\n";

    chdir "/Data/data6/WFP/RiskView";

    $ua->timeout(1000);   
    my $status = getstore("$url","$fname");
    die "Error $status on $url" unless is_success($status);

# insert code to read from the region/season csv file and generate csv files for
# each country in the region. It also re-arranges the columns and adds a year column.
# This section of code comes from "cntrysplit.pl".

    open(in0,"$fname") || die "cannot open $fname for reading"; 
     $a = 0;
     while(<in0>){
      $a++;
# make sure you're not parsing the header
      if ($a > 1) {
       $linestuff = $_;
       @stuff = split(/,/, $linestuff);
       $seas[$a] = $stuff[0];
       $time[$a] = $stuff[1];
       $cntry[$a] = $stuff[2];
       $area[$a] = $stuff[3];
       $weight[$a] = $stuff[4];
       $time[$a] =~ m/[A-Z][a-z][a-z] (\d\d\d\d)/;
       $year[$a] = $1;
      } # end of $a > 1 check
     } # end of while loop
    close(in0);

# loop through file of country names and assign names to an array

    open(in1,"EA_country_names.tsv") || die "cannot open EA_country_names.tsv for reading";
     $b = 0;
     while(<in1>){
      $b++;
      $cntrynames[$b] = $_;
      chomp $cntrynames[$b];
     }
    close(in1);

#begin loop through country names
    for ($b = 1; $b <= $#cntrynames; $b++) {

#use country name variable, season, etc., to define a country file name
     $cntryfname = "$cntrynames[$b]" . "_$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "_Forecast.csv";

     print "$cntryfname\n";

#for a given country open filehandle for output
     open(out0,">$dataghtml/$cntryfname") || die "cannot create $cntryfname";

# start at $a = 2 so that you don't include the header
     for ($a = 2; $a <= $#seas; $a++) {

# check to see if $cntry[$a] matches country name in list

      if ($cntry[$a] =~ /$cntrynames[$b]/) {

# if so, write line to file

#      print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$time[$a],$weight[$a]";
       print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$stmonseasnum{$mon},$endmonseasnum,$weight[$a]";
      }
     }
     close(out0);

    } # end country loop

# end of country file creation code from "cntrysplit.pl"

   } # end of if month matches check

  } # end of if region matches check

# check for next region

  if ($region =~ /EA2/) {

   # EA2 runs from 1 Apr to 30 Oct - fcst seasons AMJ,MJJ,JJA,JAS,ASO ; partial SON 
   # need to check the forecast issue date here and specify if a set of weights should be
   # calculated; if so, continue; if not, go on to the next region

   if (($mon =~ /Jan/) || ($mon =~ /Feb/) || ($mon =~ /Mar/) || ($mon =~ /Apr/) || ($mon =~ /May/) || ($mon =~ /Jun/) || ($mon =~ /Jul/) || ($mon =~ /Aug/)) {

    print "$region\n";

    # assign region code to use in geometry data set specification
    $reggeom = "ea";

    # assign values for range edges of spatial domain
    $xw = "12.";
    $xe = "54.";
    $ys = "-18.";
    $yn = "31.";

    # assign values for range edges in evengridAverage commands
    $xwev = 11.25;
    $xeev = 53.75;
    $ysev = -17.75;
    $ynev = 30.75; 

    # determine range edges of leads to use based upon forecast date
    %firstlead = qw(Jan 3 Feb 2 Mar 1 Apr 1 May 1 Jun 1 Jul 1 Aug 1);
    %lastlead = qw(Jan 4 Feb 4 Mar 4 Apr 4 May 3 Jun 2 Jul 1 Aug 1);

    # determine the factor to multiply by 33.333 for each $mon
    %ecfactor = qw(Jan 3 Feb 2 Mar 1 Apr 0 May 0 Jun 0 Jul 0 Aug 0);

    # determine the denominator that specifies the number of seasons over which the average forecast
    # probabilities are being taken
    %denom = qw(Jan 5 Feb 5 Mar 5 Apr 4 May 3 Jun 2 Jul 1 Aug 1);

    # determine the start and end months to specify before taking seasonal average of historical data
    #$stmonhist = "Apr";
    %stmonhist = qw(Jan May Feb May Mar May Apr Jun May Jul Jun Aug Jul Sep Aug Oct);
    $styrhist = 1995; 
    $endmonhist = "Oct";
#   if(($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {
#    $endyrhist = $yr;
#   } else {
     $endyrhist = $yr - 1;
#   }

    # determine the start and end months to specify within the seasonal average itself
    %stmonseas = qw(Jan Apr Feb Apr Mar Apr Apr May May Jun Jun Jul Jul Aug Aug Sep);
    $endmonseas = "Oct";

    # for final file output, associate number of month with start and end months of season
    %stmonseasnum = qw(Jan 4 Feb 4 Mar 4 Apr 5 May 6 Jun 7 Jul 8 Aug 9);
    $endmonseasnum = "10";

    # determine the start and end months and years to specify for base period
    $stmonbp = "Jan";
    $styrbp = 1981;
    $endmonbp = "Oct";
    $endyrbp = 2010;

    print "$stmonseas{$mon}\n";
    print "$endmonseas\n";
#   print "$firstlead{$mon}\n";
#   print "$lastlead{$mon}\n";

    # construct URL with help of variables, and use LWP to download as csv table

    my $url = "http://iridl.ldeo.columbia.edu/expert/ds:/SOURCES/.IRI/.FD/.Seasonal_Forecast/.Precipitation/.prob/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/F/%28$mon%20$yr%29VALUE/L/$firstlead{$mon}/$lastlead{$mon}/RANGE/33.33333/replaceNaN%5BL%5Dsum/33.33333/$ecfactor{$mon}/mul/add/$denom{$mon}/div/0.01/mul/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/T/%28$stmonhist{$mon}%20$styrhist%29%28$endmonhist%20$endyrhist%29RANGE/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonbp%20$styrbp%29%28$endmonbp%20$endyrbp%29RANGE/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage%5BT%5D0/0.33/0.67/1./0.8/replacebypercentile%5Bpercentile%5Dboundedtablefunction/%7BBelow_Normal/0.33/Normal/0.67/Above_Normal%7D//C/classify/a:/:a:%5BT%5Dsum/0/maskle/:a/mul/a:%5BC%5D1./average/dataflag/0/maskle/:a:/0/maskle/4/index/exch/div%5BC%5Dmaxover/:a/mul/T/npts/nip/1./exch/div/replaceNaN/X/$xwev/0.5/$xeev/evengridAverage/Y/$ysev/0.5/$ynev/evengridAverage/home/.mbell/.GISupload/.RiskView/.Mar2010shapes/.val_ea_20100317_final/.geometry/.the_geom%5BX/Y%5Dweighted-average//name//weights/def//long_name/%28Weights%29def/dup%5BT%5Dsum/div/T/npts/nip/1./exch/div/replaceNaN/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.area//long_name/%28Area%29def/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.country//long_name/%28Country%29def/home/.mbell/.WFP/.RiskView/.Season/N/%28$region%29VALUE/:ds/mark/Season/T/country/area/weights/table:/mark/:table/.csv";


    $fname = "weights_" .  "$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "fcst.csv";
    print "$fname\n";

    chdir "/Data/data6/WFP/RiskView";

    $ua->timeout(1000);   
    my $status = getstore("$url","$fname");
    die "Error $status on $url" unless is_success($status);

# insert code to read from the region/season csv file and generate csv files for
# each country in the region. It also re-arranges the columns and adds a year column.
# This section of code comes from "cntrysplit.pl".

    open(in0,"$fname") || die "cannot open $fname for reading"; 
     $a = 0;
     while(<in0>){
      $a++;
# make sure you're not parsing the header
      if($a > 1) {
       $linestuff = $_;
       @stuff = split(/,/, $linestuff);
       $seas[$a] = $stuff[0];
       $time[$a] = $stuff[1];
       $cntry[$a] = $stuff[2];
       $area[$a] = $stuff[3];
       $weight[$a] = $stuff[4];
       $time[$a] =~ m/[A-Z][a-z][a-z] (\d\d\d\d)/;
       $year[$a] = $1;
      } # end of $a > 1 check
     } # end of while loop
    close(in0);

# loop through file of country names and assign names to an array

    open(in1,"EA_country_names.tsv") || die "cannot open EA_country_names.tsv for reading";
     $b = 0;
     while(<in1>){
      $b++;
      $cntrynames[$b] = $_;
      chomp $cntrynames[$b];
     }
    close(in1);

#begin loop through country names
    for ($b = 1; $b <= $#cntrynames; $b++) {

#use country name variable, season, etc., to define a country file name
     $cntryfname = "$cntrynames[$b]" . "_$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "_Forecast.csv";

     print "$cntryfname\n";

#for a given country open filehandle for output
     open(out0,">$dataghtml/$cntryfname") || die "cannot create $cntryfname";

# start at $a = 2 so that you don't include the header
     for ($a = 2; $a <= $#seas; $a++) {

# check to see if $cntry[$a] matches country name in list

      if ($cntry[$a] =~ /$cntrynames[$b]/) {

# if so, write line to file

#      print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$time[$a],$weight[$a]";
       print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$stmonseasnum{$mon},$endmonseasnum,$weight[$a]";
      }
     }
     close(out0);

    } # end country loop

# end of country file creation code from "cntrysplit.pl"


   } # end of if month matches check

  } # end of if region matches check

# check for next region

  if ($region =~ /EAR2/) {

   # EAR2 runs from 1 Aug to 31 Jan - fcst seasons ASO,SON,OND,NDJ; partial DJF 
   # need to check the forecast issue date here and specify if a set of weights should be
   # calculated; if so, continue; if not, go on to the next region

   if (($mon =~ /Apr/) || ($mon =~ /May/) || ($mon =~ /Jun/) || ($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/) || ($mon =~ /Nov/)) {

    print "$region\n";

    # assign region code to use in geometry data set specification
    $reggeom = "ea";

    # assign values for range edges of spatial domain
    $xw = "12.";
    $xe = "54.";
    $ys = "-18.";
    $yn = "31.";

    # assign values for range edges in evengridAverage commands
    $xwev = 11.25;
    $xeev = 53.75;
    $ysev = -17.75;
    $ynev = 30.75; 

    # determine range edges of leads to use based upon forecast date
    %firstlead = qw(Apr 4 May 3 Jun 2 Jul 1 Aug 1 Sep 1 Oct 1 Nov 1);
    %lastlead = qw(Apr 4 May 4 Jun 4 Jul 4 Aug 3 Sep 2 Oct 1 Nov 1);

    # determine the factor to multiply by 33.333 for each $mon
    %ecfactor = qw(Apr 3 May 2 Jun 1 Jul 0 Aug 0 Sep 0 Oct 0 Nov 0);

    # determine the denominator that specifies the number of seasons over which the average forecast
    # probabilities are being taken
    %denom = qw(Apr 4 May 4 Jun 4 Jul 4 Aug 3 Sep 2 Oct 1 Nov 1);

    # determine the start and end months to specify before taking seasonal average of historical data
    #$stmonhist = "Aug";
    %stmonhist = qw(Apr Sep May Sep Jun Sep Jul Sep Aug Oct Sep Nov Oct Dec Nov Jan);
    $styrhist = 1995; 
    $endmonhist = "Jan";
#   if(($mon =~ /Oct/) || ($mon =~ /Nov/)) {
     $endyrhist = $yr;
#   } else {
#    $endyrhist = $yr - 1;
#   }

    # determine the start and end months to specify within the seasonal average itself
    %stmonseas = qw(Apr Aug May Aug Jun Aug Jul Aug Aug Sep Sep Oct Oct Nov Nov Dec);
    $endmonseas = "Jan";

    # for final file output, associate number of month with start and end months of season
    %stmonseasnum = qw(Apr 8 May 8 Jun 8 Jul 8 Aug 9 Sep 10 Oct 11 Nov 12);
    $endmonseasnum = 1;

    # determine the start and end months and years to specify for base period
    $stmonbp = "Aug";
    $styrbp = 1981;
    $endmonbp = "Jan";
    $endyrbp = 2011;

    print "$stmonseas{$mon}\n";
    print "$endmonseas\n";
#   print "$firstlead{$mon}\n";
#   print "$lastlead{$mon}\n";

    # construct URL with help of variables, and use LWP to download as csv table

    my $url = "http://iridl.ldeo.columbia.edu/expert/ds:/SOURCES/.IRI/.FD/.Seasonal_Forecast/.Precipitation/.prob/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/F/%28$mon%20$yr%29VALUE/L/$firstlead{$mon}/$lastlead{$mon}/RANGE/33.33333/replaceNaN%5BL%5Dsum/33.33333/$ecfactor{$mon}/mul/add/$denom{$mon}/div/0.01/mul/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/T/%28$stmonhist{$mon}%20$styrhist%29%28$endmonhist%20$endyrhist%29RANGE/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonbp%20$styrbp%29%28$endmonbp%20$endyrbp%29RANGE/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage%5BT%5D0/0.33/0.67/1./0.8/replacebypercentile%5Bpercentile%5Dboundedtablefunction/%7BBelow_Normal/0.33/Normal/0.67/Above_Normal%7D//C/classify/a:/:a:%5BT%5Dsum/0/maskle/:a/mul/a:%5BC%5D1./average/dataflag/0/maskle/:a:/0/maskle/4/index/exch/div%5BC%5Dmaxover/:a/mul/T/npts/nip/1./exch/div/replaceNaN/X/$xwev/0.5/$xeev/evengridAverage/Y/$ysev/0.5/$ynev/evengridAverage/home/.mbell/.GISupload/.RiskView/.Mar2010shapes/.val_ea_20100317_final/.geometry/.the_geom%5BX/Y%5Dweighted-average//name//weights/def//long_name/%28Weights%29def/dup%5BT%5Dsum/div/T/npts/nip/1./exch/div/replaceNaN/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.area//long_name/%28Area%29def/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.country//long_name/%28Country%29def/home/.mbell/.WFP/.RiskView/.Season/N/%28$region%29VALUE/:ds/mark/Season/T/country/area/weights/table:/mark/:table/.csv";


    $fname = "weights_" .  "$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "fcst.csv";
    print "$fname\n";

    chdir "/Data/data6/WFP/RiskView";

    $ua->timeout(1000);   
    my $status = getstore("$url","$fname");
    die "Error $status on $url" unless is_success($status);

# insert code to read from the region/season csv file and generate csv files for
# each country in the region. It also re-arranges the columns and adds a year column.
# This section of code comes from "cntrysplit.pl".

    open(in0,"$fname") || die "cannot open $fname for reading"; 
     $a = 0;
     while(<in0>){
      $a++;
# make sure you're not parsing the header
      if($a > 1) {
       $linestuff = $_;
       @stuff = split(/,/, $linestuff);
       $seas[$a] = $stuff[0];
       $time[$a] = $stuff[1];
       $cntry[$a] = $stuff[2];
       $area[$a] = $stuff[3];
       $weight[$a] = $stuff[4];
       $time[$a] =~ m/[A-Z][a-z][a-z] (\d\d\d\d)/;
       $year[$a] = $1;
      } # end of $a > 1 check
     } # end of while loop
    close(in0);

# loop through file of country names and assign names to an array

    open(in1,"EA_country_names.tsv") || die "cannot open EA_country_names.tsv for reading";
     $b = 0;
     while(<in1>){
      $b++;
      $cntrynames[$b] = $_;
      chomp $cntrynames[$b];
     }
    close(in1);

#begin loop through country names
    for ($b = 1; $b <= $#cntrynames; $b++) {

#use country name variable, season, etc., to define a country file name
     $cntryfname = "$cntrynames[$b]" . "_$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "_Forecast.csv";

     print "$cntryfname\n";

#for a given country open filehandle for output
     open(out0,">$dataghtml/$cntryfname") || die "cannot create $cntryfname";

# start at $a = 2 so that you don't include the header
     for ($a = 2; $a <= $#seas; $a++) {

# check to see if $cntry[$a] matches country name in list

      if ($cntry[$a] =~ /$cntrynames[$b]/) {

# if so, write line to file

#      print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$time[$a],$weight[$a]";
       print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$stmonseasnum{$mon},$endmonseasnum,$weight[$a]";
      }
     }
     close(out0);

    } # end country loop

# end of country file creation code from "cntrysplit.pl"


   } # end of if month matches check

  } # end of if region matches check

# check for next region

  if ($region =~ /EA3/) {

   # EA3 runs from 1 Sep to 30 Apr - fcst seasons SON,OND,NDJ,DJF,JFM,FMA; partial MAM 
   # need to check the forecast issue date here and specify if a set of weights should be
   # calculated; if so, continue; if not, go on to the next region

   if (($mon =~ /Jan/) || ($mon =~ /Feb/) || ($mon =~ /Jun/) || ($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {

    print "$region\n";

    # assign region code to use in geometry data set specification
    $reggeom = "ea";

    # assign values for range edges of spatial domain
    $xw = "12.";
    $xe = "54.";
    $ys = "-18.";
    $yn = "31.";

    # assign values for range edges in evengridAverage commands
    $xwev = 11.25;
    $xeev = 53.75;
    $ysev = -17.75;
    $ynev = 30.75; 

    # determine range edges of leads to use based upon forecast date
    %firstlead = qw(Jan 1 Feb 1 Jun 3 Jul 2 Aug 1 Sep 1 Oct 1 Nov 1 Dec 1);
    %lastlead = qw(Jan 1 Feb 1 Jun 4 Jul 4 Aug 4 Sep 4 Oct 4 Nov 3 Dec 2);

    # determine the factor to multiply by 33.333 for each $mon
    %ecfactor = qw(Jan 0 Feb 0 Jun 4 Jul 3 Aug 2 Sep 1 Oct 0 Nov 0 Dec 0);

    # determine the denominator that specifies the number of seasons over which the average forecast
    # probabilities are being taken
    %denom = qw(Jan 1 Feb 1 Jun 6 Jul 6 Aug 6 Sep 5 Oct 4 Nov 3 Dec 2);

    # determine the start and end months to specify before taking seasonal average of historical data
    #$stmonhist = "Jan";
    %stmonhist = qw(Jan Mar Feb Apr Jun Oct Jul Oct Aug Oct Sep Nov Oct Dec Nov Jan Dec Feb);

# Need to include this condition for styrhist for EA3 and SA to ensure that you are correctly
# specifying the year when, depending upon the forecast issue date, the remainder of the agri/
# pastoral season starts in a month after the year boundary.  This is also important for
# ensuring that the Year label will correctly use the year of the start of the agri/pastoral
# season in the final individual country files.

    if(($mon =~ /Jun/) || ($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/)) {
     $styrhist = 1995;
    } else {
     $styrhist = 1996;
    }

    $endmonhist = "Apr";
    if(($mon =~ /Jun/) || ($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {
     $endyrhist = $yr;
    } else {
     $endyrhist = $yr - 1;
    }

    # determine the start and end months to specify within the seasonal average itself
    %stmonseas = qw(Jan Feb Feb Mar Jun Sep Jul Sep Aug Sep Sep Oct Oct Nov Nov Dec Dec Jan);
    $endmonseas = "Apr";

    # for final file output, associate number of month with start and end months of season
    %stmonseasnum = qw(Jan 2 Feb 3 Jun 9 Jul 9 Aug 9 Sep 10 Oct 11 Nov 12 Dec 1);
    $endmonseasnum = 4;

    # determine the start and end months and years to specify for base period
    $stmonbp = "Sep";
    $styrbp = 1981;
    $endmonbp = "Apr";
    $endyrbp = 2011;

    print "$stmonseas{$mon}\n";
    print "$endmonseas\n";
#   print "$firstlead{$mon}\n";
#   print "$lastlead{$mon}\n";

    # construct URL with help of variables, and use LWP to download as csv table

    my $url = "http://iridl.ldeo.columbia.edu/expert/ds:/SOURCES/.IRI/.FD/.Seasonal_Forecast/.Precipitation/.prob/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/F/%28$mon%20$yr%29VALUE/L/$firstlead{$mon}/$lastlead{$mon}/RANGE/33.33333/replaceNaN%5BL%5Dsum/33.33333/$ecfactor{$mon}/mul/add/$denom{$mon}/div/0.01/mul/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/T/%28$stmonhist{$mon}%20$styrhist%29%28$endmonhist%20$endyrhist%29RANGE/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonbp%20$styrbp%29%28$endmonbp%20$endyrbp%29RANGE/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage%5BT%5D0/0.33/0.67/1./0.8/replacebypercentile%5Bpercentile%5Dboundedtablefunction/%7BBelow_Normal/0.33/Normal/0.67/Above_Normal%7D//C/classify/a:/:a:%5BT%5Dsum/0/maskle/:a/mul/a:%5BC%5D1./average/dataflag/0/maskle/:a:/0/maskle/4/index/exch/div%5BC%5Dmaxover/:a/mul/T/npts/nip/1./exch/div/replaceNaN/X/$xwev/0.5/$xeev/evengridAverage/Y/$ysev/0.5/$ynev/evengridAverage/home/.mbell/.GISupload/.RiskView/.Mar2010shapes/.val_ea_20100317_final/.geometry/.the_geom%5BX/Y%5Dweighted-average//name//weights/def//long_name/%28Weights%29def/dup%5BT%5Dsum/div/T/npts/nip/1./exch/div/replaceNaN/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.area//long_name/%28Area%29def/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_ea_20100317_final/.country//long_name/%28Country%29def/home/.mbell/.WFP/.RiskView/.Season/N/%28$region%29VALUE/:ds/mark/Season/T/country/area/weights/table:/mark/:table/.csv";


    $fname = "weights_" .  "$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "fcst.csv";
    print "$fname\n";

    chdir "/Data/data6/WFP/RiskView";

    $ua->timeout(1000);   
    my $status = getstore("$url","$fname");
    die "Error $status on $url" unless is_success($status);

# insert code to read from the region/season csv file and generate csv files for
# each country in the region. It also re-arranges the columns and adds a year column.
# This section of code comes from "cntrysplit.pl".

    open(in0,"$fname") || die "cannot open $fname for reading"; 
     $a = 0;
     while(<in0>){
      $a++;
# make sure you're not parsing the header
      if($a > 1) {
       $linestuff = $_;
       @stuff = split(/,/, $linestuff);
       $seas[$a] = $stuff[0];
       $time[$a] = $stuff[1];
       $cntry[$a] = $stuff[2];
       $area[$a] = $stuff[3];
       $weight[$a] = $stuff[4];
       $time[$a] =~ m/[A-Z][a-z][a-z] (\d\d\d\d)/;
       $year1[$a] = $1;

# since EA3 seasons evolve over the year boundary, you need to make sure that the
# year variable is always printed as the year in which the full agri season begins,
# not the year in which the remainder of the season starts given the current 
# forecast date 

       if(($mon =~ /Dec/) || ($mon =~ /Jan/) || ($mon =~ /Feb/)) {
         $year[$a] = $year1[$a] - 1;
       } else {
         $year[$a] = $year1[$a];
       }
      } # end of $a > 1 check

     } # end of while loop
    close(in0);

# loop through file of country names and assign names to an array

    open(in1,"EA_country_names.tsv") || die "cannot open EA_country_names.tsv for reading";
     $b = 0;
     while(<in1>){
      $b++;
      $cntrynames[$b] = $_;
      chomp $cntrynames[$b];
     }
    close(in1);

#begin loop through country names
    for ($b = 1; $b <= $#cntrynames; $b++) {

#use country name variable, season, etc., to define a country file name
     $cntryfname = "$cntrynames[$b]" . "_$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "_Forecast.csv";

     print "$cntryfname\n";

#for a given country open filehandle for output
     open(out0,">$dataghtml/$cntryfname") || die "cannot create $cntryfname";

# start at $a = 2 so that you don't include the header
     for ($a = 2; $a <= $#seas; $a++) {

# check to see if $cntry[$a] matches country name in list

      if ($cntry[$a] =~ /$cntrynames[$b]/) {

# if so, write line to file

#      print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$time[$a],$weight[$a]";
       print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$stmonseasnum{$mon},$endmonseasnum,$weight[$a]";
      }
     }
     close(out0);

    } # end country loop

# end of country file creation code from "cntrysplit.pl"


   } # end of if month matches check

  } # end of if region matches check

# check for next region

  if ($region =~ /WA/) {

   # WA runs from 1 Apr to 31 Oct - fcst seasons AMJ,MJJ,JJA,JAS,ASO; partial SON 
   # need to check the forecast issue date here and specify if a set of weights should be
   # calculated; if so, continue; if not, go on to the next region

   if (($mon =~ /Jan/) || ($mon =~ /Feb/) || ($mon =~ /Mar/) || ($mon =~ /Apr/) || ($mon =~ /May/) || ($mon =~ /Jun/) || ($mon =~ /Jul/) || ($mon =~ /Aug/)) {

    print "$region\n";

    # assign region code to use in geometry data set specification
    $reggeom = "wa";

    # assign values for range edges of spatial domain
    $xw = "-22.5";
    $xe = "35.";
    $ys = "-5.";
    $yn = "27.5";

    # assign values for range edges in evengridAverage commands
    $xwev = -22.25;
    $xeev = 34.75;
    $ysev = -4.75;
    $ynev = 27.25; 

    # determine range edges of leads to use based upon forecast date
    %firstlead = qw(Jan 3 Feb 2 Mar 1 Apr 1 May 1 Jun 1 Jul 1 Aug 1);
    %lastlead = qw(Jan 4 Feb 4 Mar 4 Apr 4 May 3 Jun 2 Jul 1 Aug 1);

    # determine the factor to multiply by 33.333 for each $mon
    %ecfactor = qw(Jan 3 Feb 2 Mar 1 Apr 0 May 0 Jun 0 Jul 0 Aug 0);

    # determine the denominator that specifies the number of seasons over which the average forecast
    # probabilities are being taken
    %denom = qw(Jan 5 Feb 5 Mar 5 Apr 4 May 3 Jun 2 Jul 1 Aug 1);

    # determine the start and end months to specify before taking seasonal average of historical data
    #$stmonhist = "Apr";
    %stmonhist = qw(Jan May Feb May Mar May Apr Jun May Jul Jun Aug Jul Sep Aug Oct);
    $styrhist = 1995; 
    $endmonhist = "Oct";
#   if(($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {
#    $endyrhist = $yr;
#   } else {
     $endyrhist = $yr - 1;
#   }

    # determine the start and end months to specify within the seasonal average itself
    %stmonseas = qw(Jan Apr Feb Apr Mar Apr Apr May May Jun Jun Jul Jul Aug Aug Sep);
    $endmonseas = "Oct";

    # for final file output, associate number of month with start and end months of season
    %stmonseasnum = qw(Jan 4 Feb 4 Mar 4 Apr 5 May 6 Jun 7 Jul 8 Aug 9);
    $endmonseasnum = 10;

    # determine the start and end months and years to specify for base period
    $stmonbp = "Jan";
    $styrbp = 1981;
    $endmonbp = "Oct";
    $endyrbp = 2010;

    print "$stmonseas{$mon}\n";
    print "$endmonseas\n";
#   print "$firstlead{$mon}\n";
#   print "$lastlead{$mon}\n";

    # construct URL with help of variables, and use LWP to download as csv table

    my $url = "http://iridl.ldeo.columbia.edu/expert/ds:/SOURCES/.IRI/.FD/.Seasonal_Forecast/.Precipitation/.prob/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/F/%28$mon%20$yr%29VALUE/L/$firstlead{$mon}/$lastlead{$mon}/RANGE/33.33333/replaceNaN%5BL%5Dsum/33.33333/$ecfactor{$mon}/mul/add/$denom{$mon}/div/0.01/mul/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/T/%28$stmonhist{$mon}%20$styrhist%29%28$endmonhist%20$endyrhist%29RANGE/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonbp%20$styrbp%29%28$endmonbp%20$endyrbp%29RANGE/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage%5BT%5D0/0.33/0.67/1./0.8/replacebypercentile%5Bpercentile%5Dboundedtablefunction/%7BBelow_Normal/0.33/Normal/0.67/Above_Normal%7D//C/classify/a:/:a:%5BT%5Dsum/0/maskle/:a/mul/a:%5BC%5D1./average/dataflag/0/maskle/:a:/0/maskle/4/index/exch/div%5BC%5Dmaxover/:a/mul/T/npts/nip/1./exch/div/replaceNaN/X/$xwev/0.5/$xeev/evengridAverage/Y/$ysev/0.5/$ynev/evengridAverage/home/.mbell/.GISupload/.RiskView/.Mar2010shapes/.val_wa_20100317_final/.geometry/.the_geom%5BX/Y%5Dweighted-average//name//weights/def//long_name/%28Weights%29def/dup%5BT%5Dsum/div/T/npts/nip/1./exch/div/replaceNaN/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_wa_20100317_final/.area//long_name/%28Area%29def/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_wa_20100317_final/.country//long_name/%28Country%29def/home/.mbell/.WFP/.RiskView/.Season/N/%28$region%29VALUE/:ds/mark/Season/T/country/area/weights/table:/mark/:table/.csv";


    $fname = "weights_" .  "$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "fcst.csv";
    print "$fname\n";

    chdir "/Data/data6/WFP/RiskView";

    $ua->timeout(1000);   
    my $status = getstore("$url","$fname");
    die "Error $status on $url" unless is_success($status);

# insert code to read from the region/season csv file and generate csv files for
# each country in the region. It also re-arranges the columns and adds a year column.
# This section of code comes from "cntrysplit.pl".

    open(in0,"$fname") || die "cannot open $fname for reading"; 
     $a = 0;
     while(<in0>){
      $a++;
# make sure you're not parsing the header
      if($a > 1) {
       $linestuff = $_;
       @stuff = split(/,/, $linestuff);
       $seas[$a] = $stuff[0];
       $time[$a] = $stuff[1];
       $cntry[$a] = $stuff[2];
       $area[$a] = $stuff[3];
       $weight[$a] = $stuff[4];
       $time[$a] =~ m/[A-Z][a-z][a-z] (\d\d\d\d)/;
       $year[$a] = $1;
      } # end of $a > 1 check
     } # end of while loop
    close(in0);

# loop through file of country names and assign names to an array

    open(in1,"WA_country_names.tsv") || die "cannot open WA_country_names.tsv for reading";
     $b = 0;
     while(<in1>){
      $b++;
      $cntrynames[$b] = $_;
      chomp $cntrynames[$b];
     }
    close(in1);

#begin loop through country names
    for ($b = 1; $b <= $#cntrynames; $b++) {

#use country name variable, season, etc., to define a country file name
     $cntryfname = "$cntrynames[$b]" . "_$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "_Forecast.csv";

     print "$cntryfname\n";

#for a given country open filehandle for output
     open(out0,">$dataghtml/$cntryfname") || die "cannot create $cntryfname";

# start at $a = 2 so that you don't include the header
     for ($a = 2; $a <= $#seas; $a++) {

# check to see if $cntry[$a] matches country name in list

      if ($cntry[$a] =~ /$cntrynames[$b]/) {

# if so, write line to file

#      print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$time[$a],$weight[$a]";
       print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$stmonseasnum{$mon},$endmonseasnum,$weight[$a]";
      }
     }
     close(out0);

    } # end country loop

# end of country file creation code from "cntrysplit.pl"


   } # end of if month matches check

  } # end of if region matches check

# check for next region

  if ($region =~ /SA/) {

   # SA runs from 1 Oct to 31 May - fcst seasons OND,NDJ,DJF,JFM,FMA,MAM; partial AMJ 
   # need to check the forecast issue date here and specify if a set of weights should be
   # calculated; if so, continue; if not, go on to the next region

   if (($mon =~ /Jan/) || ($mon =~ /Feb/) || ($mon =~ /Mar/) || ($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {

    print "$region\n";

    # assign region code to use in geometry data set specification
    $reggeom = "sa";

    # assign values for range edges of spatial domain
    $xw = "2.5";
    $xe = "60.";
    $ys = "-40.";
    $yn = "10.";

    # assign values for range edges in evengridAverage commands
    $xwev = 2.75;
    $xeev = 59.75;
    $ysev = -39.75;
    $ynev = 9.75; 

    # determine range edges of leads to use based upon forecast date
    %firstlead = qw(Jan 1 Feb 1 Mar 1 Jul 3 Aug 2 Sep 1 Oct 1 Nov 1 Dec 1);
    %lastlead = qw(Jan 2 Feb 1 Mar 1 Jul 4 Aug 4 Sep 4 Oct 4 Nov 4 Dec 3);

    # determine the factor to multiply by 33.333 for each $mon
    %ecfactor = qw(Jan 0 Feb 0 Mar 0 Jul 4 Aug 3 Sep 2 Oct 1 Nov 0 Dec 0);

    # determine the denominator that specifies the number of seasons over which the average forecast
    # probabilities are being taken
    %denom = qw(Jan 2 Feb 1 Mar 1 Jul 6 Aug 6 Sep 6 Oct 5 Nov 4 Dec 3);

    # determine the start and end months to specify before taking seasonal average of historical data
    #$stmonhist = "Jan";
    %stmonhist = qw(Jan Mar Feb Apr Mar May Jul Nov Aug Nov Sep Nov Oct Dec Nov Jan Dec Feb);

# Need to include this condition for styrhist for EA3 and SA to ensure that you are correctly
# specifying the year when, depending upon the forecast issue date, the remainder of the agri/
# pastoral season starts in a month after the year boundary.  This is also important for
# ensuring that the Year label will correctly use the year of the start of the agri/pastoral
# season in the final individual country files.

    if(($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/)) {
     $styrhist = 1995;
    } else {
     $styrhist = 1996;
    }

    $endmonhist = "May";
    if(($mon =~ /Jul/) || ($mon =~ /Aug/) || ($mon =~ /Sep/) || ($mon =~ /Oct/) || ($mon =~ /Nov/) || ($mon =~ /Dec/)) {
     $endyrhist = $yr;
    } else {
     $endyrhist = $yr - 1;
    }

    # determine the start and end months to specify within the seasonal average itself
    %stmonseas = qw(Jan Feb Feb Mar Mar Apr Jul Oct Aug Oct Sep Oct Oct Nov Nov Dec Dec Jan);
    $endmonseas = "May";

    # for final file output, associate number of month with start and end months of season
    %stmonseasnum = qw(Jan 2 Feb 3 Mar 4 Jul 10 Aug 10 Sep 10 Oct 11 Nov 12 Dec 1);
    $endmonseasnum = 5;

    # determine the start and end months and years to specify for base period
    $stmonbp = "Oct";
    $styrbp = 1981;
    $endmonbp = "May";
    $endyrbp = 2011;

    print "$stmonseas{$mon}\n";
    print "$endmonseas\n";
#   print "$firstlead{$mon}\n";
#   print "$lastlead{$mon}\n";

    # construct URL with help of variables, and use LWP to download as csv table

    my $url = "http://iridl.ldeo.columbia.edu/expert/ds:/SOURCES/.IRI/.FD/.Seasonal_Forecast/.Precipitation/.prob/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/F/%28$mon%20$yr%29VALUE/L/$firstlead{$mon}/$lastlead{$mon}/RANGE/33.33333/replaceNaN%5BL%5Dsum/33.33333/$ecfactor{$mon}/mul/add/$denom{$mon}/div/0.01/mul/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/T/%28$stmonhist{$mon}%20$styrhist%29%28$endmonhist%20$endyrhist%29RANGE/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage/home/.mbell/.Net_Assessment/.Observations/.monthly/.merged/.TS2p1_CMAP_OPI/.prcp/X/$xw/$xe/RANGEEDGES/Y/$ys/$yn/RANGEEDGES/T/%28$stmonbp%20$styrbp%29%28$endmonbp%20$endyrbp%29RANGE/T/%28$stmonseas{$mon}-$endmonseas%29seasonalAverage%5BT%5D0/0.33/0.67/1./0.8/replacebypercentile%5Bpercentile%5Dboundedtablefunction/%7BBelow_Normal/0.33/Normal/0.67/Above_Normal%7D//C/classify/a:/:a:%5BT%5Dsum/0/maskle/:a/mul/a:%5BC%5D1./average/dataflag/0/maskle/:a:/0/maskle/4/index/exch/div%5BC%5Dmaxover/:a/mul/T/npts/nip/1./exch/div/replaceNaN/X/$xwev/0.5/$xeev/evengridAverage/Y/$ysev/0.5/$ynev/evengridAverage/home/.mbell/.GISupload/.RiskView/.Mar2010shapes/.val_sa_20100317_final/.geometry/.the_geom%5BX/Y%5Dweighted-average//name//weights/def//long_name/%28Weights%29def/dup%5BT%5Dsum/div/T/npts/nip/1./exch/div/replaceNaN/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_sa_20100317_final/.area//long_name/%28Area%29def/home/.mbell/.WFP/.RiskView/.Mar2010names/.val_sa_20100317_final/.country//long_name/%28Country%29def/home/.mbell/.WFP/.RiskView/.Season/N/%28$region%29VALUE/:ds/mark/Season/T/country/area/weights/table:/mark/:table/.csv";


    $fname = "weights_" .  "$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "fcst.csv";
    print "$fname\n";

    chdir "/Data/data6/WFP/RiskView";

    $ua->timeout(1000);   
    my $status = getstore("$url","$fname");
    die "Error $status on $url" unless is_success($status);

# insert code to read from the region/season csv file and generate csv files for
# each country in the region. It also re-arranges the columns and adds a year column.
# This section of code comes from "cntrysplit.pl".

    open(in0,"$fname") || die "cannot open $fname for reading"; 
     $a = 0;
     while(<in0>){
      $a++;
# make sure you're not parsing the header
      if($a > 1) {
       $linestuff = $_;
       @stuff = split(/,/, $linestuff);
       $seas[$a] = $stuff[0];
       $time[$a] = $stuff[1];
       $cntry[$a] = $stuff[2];
       $area[$a] = $stuff[3];
       $weight[$a] = $stuff[4];
       $time[$a] =~ m/[A-Z][a-z][a-z] (\d\d\d\d)/;
       $year1[$a] = $1;

# since SA seasons evolve over the year boundary, you need to make sure that the
# year variable is always printed as the year in which the full agri season begins,
# not the year in which the remainder of the season starts given the current 
# forecast date 

       if(($mon =~ /Dec/) || ($mon =~ /Jan/) || ($mon =~ /Feb/) || ($mon =~ /Mar/)) {
         $year[$a] = $year1[$a] - 1;
       } else {
         $year[$a] = $year1[$a];
       }
      } # end of $a > 1 check

     } # end of while loop
    close(in0);

# loop through file of country names and assign names to an array

    open(in1,"SA_country_names.tsv") || die "cannot open SA_country_names.tsv for reading";
     $b = 0;
     while(<in1>){
      $b++;
      $cntrynames[$b] = $_;
      chomp $cntrynames[$b];
     }
    close(in1);

#begin loop through country names
    for ($b = 1; $b <= $#cntrynames; $b++) {

#use country name variable, season, etc., to define a country file name
     $cntryfname = "$cntrynames[$b]" . "_$region" . "_$stmonseas{$mon}-$endmonseas" . "_$mon$yr" . "_Forecast.csv";

     print "$cntryfname\n";

#for a given country open filehandle for output
     open(out0,">$dataghtml/$cntryfname") || die "cannot create $cntryfname";

# start at $a = 2 so that you don't include the header
     for ($a = 2; $a <= $#seas; $a++) {

# check to see if $cntry[$a] matches country name in list

      if ($cntry[$a] =~ /$cntrynames[$b]/) {

# if so, write line to file

#      print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$time[$a],$weight[$a]";
       print out0 "$seas[$a],$cntry[$a],$area[$a],$year[$a],$stmonseasnum{$mon},$endmonseasnum,$weight[$a]";
      }
     }
     close(out0);

    } # end country loop

# end of country file creation code from "cntrysplit.pl"


   } # end of if month matches check

  } # end of if region matches check

 } # end of regions foreach

 open(out3,">$dataghtml/dateupdated.txt") || die "cannot create dateupdated.txt";
  $todaysdate = `$gnudate +%Y%m%d`;
  print out3 "$todaysdate"; 
 close(out3);

exit;

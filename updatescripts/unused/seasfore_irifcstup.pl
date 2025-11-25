#!/usr/bin/perl -w

# Michael Bell
# March 22, 2004
# Script to update IRI seasonal precipitation and temperature forecasts --
# to make improvements on the cshell script that already exists.

$lockname = '/Data/data8/iri/seasfore/lockfile';

if(-e $lockname){
 print "Seasonal forecast update script already running\n";
 exit;
} else {
 system("touch $lockname");

$GNUDATE = "/ClimateGroup/network/gnu/bin/date";
$currtim = `$GNUDATE +%s`;
$datadir = '/Data/data1/iri/fd/seasfore';
$idxdirP = '/Data/data1/DataCatalog/entries/IRI/FD/Seasonal_Forecast/Precipitation';
$idxdirPx = '/Data/data1/DataCatalog/entries/IRI/FD/Seasonal_Forecast/Extreme_Precipitation';
$idxdirT = '/Data/data1/DataCatalog/entries/IRI/FD/Seasonal_Forecast/Temperature';
$idxdirTx = '/Data/data1/DataCatalog/entries/IRI/FD/Seasonal_Forecast/Extreme_Temperature';
$fcstdir = '/c16/ftp/pub/tonyb/iriforecasts';
$workdir = '/Data/data8/iri/seasfore';
@flistP = ();
@flistPx = ();
@flistT = ();
@flistTx = ();

%mon = ("01","Nov","02","Dec","03","Jan","04","Feb","05","Mar","06","Apr","07","May","08","Jun","09","Jul","10","Aug","11","Sep","12","Oct");

# @flistP & @flistT are arrays containing the file names currently in the ftp directory

 chdir $workdir;

# or use the "stat" function to see if the last modified time is more recent than
# about 70 minutes ago, and make sure the program runs at night as well.

#Go to $fcstdir and find and read the names of the current (updated?) 
#seasonal precipitation and temperature forecast files, and put the names
#and modification times for these files into arrays.

foreach $filP (<$fcstdir/P*>) {
  if($filP =~ /$fcstdir\/(P[1-4]y\d\d\d\ds[0-1][0-9]\w\w\w)$/) {
    $mtimP = (stat($filP))[9];
    if($mtimP > $currtim - 4200) {
      push(@flistP,$1);
    }
  }
  if($filP =~ /$fcstdir\/(P1y\d\d\d\ds[0-1][0-9]\w\w\wx)$/) {
    $mtimPx = (stat($filP))[9];
    if($mtimPx > $currtim - 4200) {
      push(@flistPx,$1);
    }
  }
}

foreach $filT (<$fcstdir/T*>) {
  if($filT =~ /$fcstdir\/(T[1-4]y\d\d\d\ds[0-1][0-9]\w\w\w)$/) {
    $mtimT = (stat($filT))[9];
    if($mtimT > $currtim - 4200) {
      push(@flistT,$1);
    }
  }
  if($filT =~ /$fcstdir\/(T1y\d\d\d\ds[0-1][0-9]\w\w\wx)$/) {
    $mtimTx = (stat($filT))[9];
    if($mtimTx > $currtim - 4200) {
      push(@flistTx,$1);
    }
  }
}

# Open the files that contain the previously-existing forecast filenames
# and modification times and read the values into arrays.

# get the lengths of the @flistT and @flistP arrays -- number of filenames
# in the arrays

$lnT = @flistT;
$lnP = @flistP;
$lnTx = @flistTx;
$lnPx = @flistPx;

# Define a test value for the precip. record numbers

  $trmo = `$GNUDATE +%m`; # trmo is current month at script execution time
  $tryr = `$GNUDATE +%Y`; # tryr is current year at script execution time

# Using information in the file names, calculate the record numbers
# each set of data should occupy in the binary file.

# Extract lead time, forecast valid year, and central month of forecast valid season 
# Use the "substr" command to extract these -- remember that perl begins counting at 0.

# "if $lnP > 0" then update the precipitation forecast

#PRECIPITATION

if($lnP > 0) {

# for each updated precip file, extract the lead time, fcast year and fcast month 
# from the filename so that you can calculate the correct record number range
# for each entry

 foreach $newP (@flistP) {
  $ltP = substr($newP, 1, 1);
  $yrP = substr($newP, 3, 4);
  $moP = substr($newP, 8, 2);

# Based upon lead time, calculate $rmoP and $ryrP to help correctly calculate the
# record number

  if($ltP == 1) {
    if($moP == 1 || $moP == 2) {
      $rmoP = $moP + 10;
      $ryrP = $yrP - 1;
    } else {
      $rmoP = $moP - 2;
      $ryrP = $yrP; 
    }
  }
  if($ltP == 2) {
    if($moP == 1 || $moP == 2 || $moP == 3) {
      $rmoP = $moP + 9;
      $ryrP = $yrP - 1;
    } else {
      $rmoP = $moP - 3;
      $ryrP = $yrP;
    }
  }
  if($ltP == 3) {
    if($moP == 1 || $moP == 2 || $moP == 3 || $moP == 4) {
      $rmoP = $moP + 8;
      $ryrP = $yrP - 1;
    }  else {
      $rmoP = $moP - 4;
      $ryrP = $yrP;
    }
  }
  if($ltP == 4) {
    if($moP == 1 || $moP == 2 || $moP == 3 || $moP == 4 || $moP == 5) {
      $rmoP = $moP + 7;
      $ryrP = $yrP - 1;
    } else {
      $rmoP = $moP - 5;
      $ryrP = $yrP;
    }
  }

  $irecP = (12*(($rmoP-7)+(12*($ryrP-2001))))+(2*($ltP-1))+$ltP+192;

# Append the calculated record numbers to the @recsP array.

  push(@recsP,$irecP);

 } #end of foreach $newP

# Define a test value for the precip. record numbers -- $irecPmax gives the
# maximum value a record number can take.

 $irecPmax=(12*(($trmo-7)+(12*($tryr-2001))))+12+192;

# make safe copies of the data file before updating

  system("cp $datadir/P1_4monthirifcst.bin $workdir/P1_4monthirifcst.bin.old");

# So, now compare the value of $irecP to $irecPmax -- if $irecPmax is exceeded,
# don't allow the update to occur for that record number. 

 $ctP=-1;
 $upP = -1;
 foreach $irecP (@recsP) {
   ++$ctP;
   if($irecP <= $irecPmax) {
     system("$workdir/irifcstupdateedt5P $fcstdir/$flistP[$ctP]"); #run program
     print "Updating $flistP[$ctP]\n";
     push(@updatP,$flistP[$ctP]);
     push(@irecupP,$irecP);
     ++$upP;
   } else {
     print "The record number for $flistP[$ctP] exceeded the maximum allowable\n";
   }
 }

# if $upP > -1 then at least one file was updated and you need to update the index.tex file

 if($upP > -1) { 

# check through the names of the updated files for a file with a lead time of "1"
# but also check that one of the files with a lead time of "1"
# was a brand new file, not just an update of a file from a previous month's fore-
# cast (even though an update of a previous month's forecast is very unlikely).
# One way to do this is to check if its record number is within 12 of the 
# maximum allowable.
   
   for($iP = 0 ; $iP <= $upP ; $iP++) {

# Now check each member of the arrays @updatP and @irecupP for conditions
# and update the index.tex file

# extract the lead time, year, and month

     $ltupP = substr($updatP[$iP], 1, 1);
     $yrupP = substr($updatP[$iP], 3, 4);
     $moupP = substr($updatP[$iP], 8, 2);

# deal only with file names with leadtime of 1 and a record number within 12 of the
# maximum allowable

     if($ltupP == 1 && (($irecPmax - $irecupP[$iP]) <= 12)) {

# specify the month and year for the index.tex file using $moupP and $yroP

       if(($moupP == 1) || ($moupP == 2)) {
         $yroP = $yrupP - 1;  
       } else {
         $yroP = $yrupP;
       }

# To update the index.tex file, read the current index.tex file, substitute in the 
# new month and year info., but save this new file as tmpP.  Then, copy the current
# index.tex file to index.tex.old.prcp, and move the updated tmpP to replace the
# original index.tex file.

       open(IN1,"$idxdirP/index.tex") || die "cannot open $idxdirP/index.tex for reading: $!";
       open(OUT1,">$workdir/tmpP") || die "cannot open $workdir/tmpP for writing: $!";
       while(<IN1>){
         if(m/enddate/){
           s/16 [a-zA-Z]{3} \d\d\d\d/16 $mon{$moupP} $yroP/;
         }
         print OUT1;
       }
       close(IN1);
       close(OUT1);

       system("cp $idxdirP/index.tex $workdir/index.tex.old.prcp ; mv $workdir/tmpP $idxdirP/index.tex; chmod g+w $idxdirP/index.tex");

     } # end if leadtime = 1 etc. -- if conditions not met, the index.tex file is not updated.
   } # end for
 } # end of if $upP > 0 
         
} #end of if $lnP > 0

#EXTREME PRECIPITATION

# if $lnPx > 0 then update the extreme precipitation forecast

if($lnPx > 0) {

# for each updated exteme precip. file, get the forecast year and month from
# the filename in order to calculate the correct record number range

 foreach $newPx (@flistPx) {
  $ltPx = substr($newPx, 1, 1);  #$ltPx should always be "1"
  $yrPx = substr($newPx, 3, 4);
  $moPx = substr($newPx, 8, 2);

  if($ltPx == 1) {
    if($moPx == 1 || $moPx == 2) {
      $rmoPx = $moPx + 10;
      $ryrPx = $yrPx - 1;
    } else {
      $rmoPx = $moPx - 2;
      $ryrPx = $yrPx; 
    }
  }

  $irecPx = (3*(($rmoPx-2)+(12*($ryrPx-2004))))+$ltPx;

  push(@recsPx,$irecPx);

 } #end of foreach $newPx

# Define a test value for the precip. record numbers -- $irecPxmax gives the
# maximum value a record number can take.

 $irecPxmax=(3*(($trmo-2)+(12*($tryr-2004))))+3;

# make safe copies of the data file before updating

  system("cp $datadir/extrmfcstP.i1 $workdir/extrmfcstP.i1.old");

# So, now compare the value of $irecPx to $irecPxmax -- if $irecPxmax is exceeded,
# don't allow the update to occur for that record number. 

 $ctPx=-1;
 $upPx = -1;
 foreach $irecPx (@recsPx) {
   ++$ctPx;
   if($irecPx <= $irecPxmax) {
     system("$workdir/iriextrmPfcst $fcstdir/$flistPx[$ctPx]"); #run program
     print "Updating $flistPx[$ctPx]\n";
     push(@updatPx,$flistPx[$ctPx]);
     push(@irecupPx,$irecPx);
     ++$upPx;
   } else {
     print "The record number for $flistPx[$ctPx] exceeded the maximum allowable\n";
   }
 }

# if $upPx > -1 then at least one file was updated and you need to update the index.tex file

 if($upPx > -1) { 

# check through the names of the updated files for a file with a lead time of "1"
# but also check that one of the files with a lead time of "1"
# was a brand new file, not just an update of a file from a previous month's fore-
# cast (even though an update of a previous month's forecast is very unlikely).
# One way to do this is to check if its record number is within 3 of the 
# maximum allowable.
   
   for($iPx = 0 ; $iPx <= $upPx ; $iPx++) {

# Now check each member of the arrays @updatPx and @irecupPx for conditions
# and update the index.tex file

# extract the lead time, year, and month

     $ltupPx = substr($updatPx[$iPx], 1, 1);
     $yrupPx = substr($updatPx[$iPx], 3, 4);
     $moupPx = substr($updatPx[$iPx], 8, 2);

# deal only with file names with leadtime of 1 and a record number within 3 of the
# maximum allowable

     if($ltupPx == 1 && (($irecPxmax - $irecupPx[$iPx]) <= 3)) {

# specify the month and year for the index.tex file using $moupP and $yroP

       if(($moupPx == 1) || ($moupPx == 2)) {
         $yroPx = $yrupPx - 1; 
       } else {
         $yroPx = $yrupPx;
       }

# To update the index.tex file, read the current index.tex file, substitute in the
# new month and year info., but save this new file as tmpPx.  Then, copy the current
# index.tex file to index.tex.old.prcpx, and move the updated tmpPx to replace the
# original index.tex file.

       open(IN3,"$idxdirPx/index.tex") || die "Cannot open $idxdirPx/index.tex for reading: $!";
       open(OUT3,">$workdir/tmpPx") || die "Cannot open $workdir/tmpPx for writing: $!";
       while(<IN3>){
         if(m/enddate/){
           s/16 [a-zA-Z]{3} \d\d\d\d/16 $mon{$moupPx} $yroPx/;
         }
         print OUT3;
       }
       close(IN3);
       close(OUT3);
       system("cp $idxdirPx/index.tex $workdir/index.tex.old.prcpx ; mv $workdir/tmpPx $idxdirPx/index.tex; chmod g+w $idxdirPx/index.tex");

     } # end if leadtime = 1 etc. -- if conditions not met, the index.tex file is not updated.
   } # end for
 } # end of if $upPx > 0

} #end of if $lnPx > 0


# TEMPERATURE

if($lnT > 0) {
 foreach $newT (@flistT) {
  $ltT = substr($newT, 1, 1);
  $yrT = substr($newT, 3, 4);
  $moT = substr($newT, 8, 2);

  if($ltT == 1) {
    if($moT == 1 || $moT == 2) {
      $rmoT = $moT + 10;
      $ryrT = $yrT - 1;
    } else {
      $rmoT = $moT - 2;
      $ryrT = $yrT; 
    }
  }
  if($ltT == 2) {
    if($moT == 1 || $moT == 2 || $moT == 3) {
      $rmoT = $moT + 9;
      $ryrT = $yrT - 1;
    } else {
      $rmoT = $moT - 3;
      $ryrT = $yrT;
    }
  }
  if($ltT == 3) {
    if($moT == 1 || $moT == 2 || $moT == 3 || $moT == 4) {
      $rmoT = $moT + 8;
      $ryrT = $yrT - 1;
    }  else {
      $rmoT = $moT - 4;
      $ryrT = $yrT;
    }
  }
  if($ltT == 4) {
    if($moT == 1 || $moT == 2 || $moT == 3 || $moT == 4 || $moT == 5) {
      $rmoT = $moT + 7;
      $ryrT = $yrT - 1;
    } else {
      $rmoT = $moT - 5;
      $ryrT = $yrT;
    }
  }

  $irecT=(12*(($rmoT-7)+(12*($ryrT-2001))))+(2*($ltT-1))+$ltT+180;

  push(@recsT,$irecT);

 } #end of foreach $newT

  $irecTmax=(12*(($trmo-7)+(12*($tryr-2001))))+12+180;

# make safe copies of the data file before updating

  system("cp $datadir/T1_4monthirifcst.bin $workdir/T1_4monthirifcst.bin.old");

# So, now compare the value of $irecT to $irecTmax -- if $irecTmax is exceeded,
# don't allow the update to occur for that record number. 

 $ctT=-1;
 $upT = -1;
 foreach $irecT (@recsT) {
   ++$ctT;
   if($irecT <= $irecTmax) {
     system("$workdir/irifcstupdateedt5T $fcstdir/$flistT[$ctT]"); 
     print "Updating $flistT[$ctT]\n";
     push(@updatT,$flistT[$ctT]);
     push(@irecupT,$irecT);
     ++$upT;
   } else {
     print "The record number for $flistT[$ctT] exceeded the maximum allowable\n";
   }
 }

# if $upT > -1 then at least one temperature file was updated and you need to update the index.tex file.

 if($upT > -1) { 

# check through the names of the updated files for a file with a lead time of "1"
# but also check that one of the files with a lead time of "1"
# was a brand new file, not just an update of a file from a previous month's fore-
# cast (even though an update of a previous month's forecast is very unlikely).
# One way to do this is to check if its record number is within 12 of the 
# maximum allowable.
   
   for($iT = 0 ; $iT <= $upT ; $iT++) {

# Now check each member of the arrays @updatT and @irecupT for conditions
# and update the index.tex file

# extract the lead time, year, and month

     $ltupT = substr($updatT[$iT], 1, 1);
     $yrupT = substr($updatT[$iT], 3, 4);
     $moupT = substr($updatT[$iT], 8, 2);

# deal only with file names with leadtime of 1 and a record number within 12 of the
# maximum allowable

     if($ltupT == 1 && (($irecTmax - $irecupT[$iT]) <= 12)) {

# specify the month and year for the index.tex file using $moupT and $yroT

       if(($moupT == 1) || ($moupT == 2)) {
         $yroT = $yrupT - 1;
       } else {
         $yroT = $yrupT;
       }

# To update the index.tex file, read the current index.tex file, substitute in the 
# new month and year info., but save this new file as tmpT.  Then, copy the current
# index.tex file to index.tex.old.prcp, and move the updated tmpT to replace the
# original index.tex file.

       open(IN2,"$idxdirT/index.tex") || die "Cannot open $idxdirT/index.tex for reading: $!";
       open(OUT2,">$workdir/tmpT") || die "Cannot open $workdir/tmpT for writing: $!";
       while(<IN2>){
         if(m/enddate/){
           s/16 [a-zA-Z]{3} \d\d\d\d/16 $mon{$moupT} $yroT/;
         }
         print OUT2;
       }
       close(IN2);
       close(OUT2);

       system("cp $idxdirT/index.tex $workdir/index.tex.old.temp ; mv $workdir/tmpT $idxdirT/index.tex; chmod g+w $idxdirT/index.tex");

     } # end if leadtime = 1 etc. -- if conditions not met, the index.tex file is not updated.
   } # end for
 } # end of if $upT > 0 

} #end of if $lnT > 0

# EXTREME TEMPERATURE

# if $lnTx > 0 then update the extreme precipitation forecast

if($lnTx > 0) {

# for each updated exteme precip. file, get the forecast year and month from
# the filename in order to calculate the correct record number range

 foreach $newTx (@flistTx) {
  $ltTx = substr($newTx, 1, 1);  #$ltTx should always be "1"
  $yrTx = substr($newTx, 3, 4);
  $moTx = substr($newTx, 8, 2);

  if($ltTx == 1) {
    if($moTx == 1 || $moTx == 2) {
      $rmoTx = $moTx + 10;
      $ryrTx = $yrTx - 1;
    } else {
      $rmoTx = $moTx - 2;
      $ryrTx = $yrTx; 
    }
  }

  $irecTx = (3*(($rmoTx-2)+(12*($ryrTx-2004))))+$ltTx;

  push(@recsTx,$irecTx);

 } #end of foreach $newTx

# Define a test value for the precip. record numbers -- $irecTxmax gives the
# maximum value a record number can take.

 $irecTxmax=(3*(($trmo-2)+(12*($tryr-2004))))+3;

# make safe copies of the data file before updating

  system("cp $datadir/extrmfcstT.i1 $workdir/extrmfcstT.i1.old");

# So, now compare the value of $irecTx to $irecTxmax -- if $irecTxmax is exceeded,
# don't allow the update to occur for that record number. 

 $ctTx=-1;
 $upTx = -1;
 foreach $irecTx (@recsTx) {
   ++$ctTx;
   if($irecTx <= $irecTxmax) {
     system("$workdir/iriextrmTfcst $fcstdir/$flistTx[$ctTx]"); #run program
     print "Updating $flistTx[$ctTx]\n";
     push(@updatTx,$flistTx[$ctTx]);
     push(@irecupTx,$irecTx);
     ++$upTx;
   } else {
     print "The record number for $flistTx[$ctTx] exceeded the maximum allowable\n";
   }
 }

# if $upTx > -1 then at least one file was updated and you need to update the index.tex file

 if($upTx > -1) { 

# check through the names of the updated files for a file with a lead time of "1"
# but also check that one of the files with a lead time of "1"
# was a brand new file, not just an update of a file from a previous month's fore-
# cast (even though an update of a previous month's forecast is very unlikely).
# One way to do this is to check if its record number is within 3 of the 
# maximum allowable.
   
   for($iTx = 0 ; $iTx <= $upTx ; $iTx++) {

# Now check each member of the arrays @updatTx and @irecupTx for conditions
# and update the index.tex file

# extract the lead time, year, and month

     $ltupTx = substr($updatTx[$iTx], 1, 1);
     $yrupTx = substr($updatTx[$iTx], 3, 4);
     $moupTx = substr($updatTx[$iTx], 8, 2);

# deal only with file names with leadtime of 1 and a record number within 3 of the
# maximum allowable

     if($ltupTx == 1 && (($irecTxmax - $irecupTx[$iTx]) <= 3)) {

# specify the month and year for the index.tex file using $moupTx and $yroTx

       if(($moupTx == 1) || ($moupTx == 2)) {
         $yroTx = $yrupTx - 1;
       } else {
         $yroTx = $yrupTx;
       }

# To update the index.tex file, read the current index.tex file, substitute in the
# new month and year info., but save this new file as tmpTx.  Then, copy the current
# index.tex file to index.tex.old.tempx, and move the updated tmpTx to replace the
# original index.tex file.

       open(IN4,"$idxdirTx/index.tex") || die "Cannot open $idxdirTx/index.tex for reading: $!";
       open(OUT4,">$workdir/tmpTx") || die "Cannot open $workdir/tmpTx for writing: $!";
       while(<IN4>){
         if(m/enddate/){
           s/16 [a-zA-Z]{3} \d\d\d\d/16 $mon{$moupTx} $yroTx/;
         }
         print OUT4;
       }
       close(IN4);
       close(OUT4);
       system("cp $idxdirTx/index.tex $workdir/index.tex.old.tempx ; mv $workdir/tmpTx $idxdirTx/index.tex; chmod g+w $idxdirTx/index.tex");

     } # end if leadtime = 1 etc. -- if conditions not met, the index.tex file is not updated.
   } # end for
 } # end of if $upTx > 0

} #end of if $lnTx > 0

# Remember that a record is written
# for each tercile, and that the records calculated above are for the first tercile.
# So, there is a difference of 3 between calculated record numbers.

 system("rm $lockname");
}  #end of lockfile check

exit; 

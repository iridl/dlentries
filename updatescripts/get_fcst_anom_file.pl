#!/usr/bin/perl -w

# Script to download SubX ESRL FIMr1p1 forecast anomaly files 
# March 15, 2018 
# Nov 13 2023 - Migrated to dlupdates - jeff turmelle
#

@datelist = ();
@newfiles = ();
@dates = ();

$curdate = `date +%Y%m%d`;
chomp $curdate;

$startdate = '20180314';
chomp $startdate;

$checkdate = $startdate;
chomp $checkdate;

$plus1 = "+1 week";

$ict = 0;

# from a known starting date that has a forecast for this model, step forward through dates one week at a time

# Check the forecast dataset in Ingrid for the latest forecast start date, and save it and its day, month, and year
# components to variables

chdir "/Data/SubX/ESRL/FIMr1p1/fcst_anom9916bp" or die "Couldn't change local directory! (1)\n";

system("wget http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/.forecast/.tas/S/last/VALUE/.S/%28%25d%20%25b%20%25Y%29/strftimes/data.ch ; mv data.ch fcstlastdate.txt");

open(in1,"fcstlastdate.txt") || die "cannot open fcstlastdate.txt for reading";
while(<in1>){
    $lastdatestuff = $_;
    $lastdatestuff =~ m/(\d\d) (...) (\d\d\d\d)/;
    $fcstday = $1;
    $fcstmon = $2;
    $fcstyr = $3;
}
$fcstdate = "$fcstday" . "$fcstmon" . "$fcstyr"; 
print "$fcstdate\n";
close(in1);

# make sure that the date for the most recent forecast has passed before trying to generate forecast anomalies from the forecast for that date 

while ($checkdate <= $curdate) {
    ++$ict;

    # get a variable in the form of YYYYmmdd for the next date 7 days ahead from previous date specified

    $nextdate = `date -d "$checkdate $plus1" +%Y%m%d`;
    chomp $nextdate;
    print "$nextdate\n";

    # get next date variables in the form of Mmm for month, dd for day and YYYY for year to use in an Ingrid date
    # in a Data Library URL that checks for forecast data availability for that date

    $nextmon = `date -d "$checkdate $plus1" +%b`;
    chomp $nextmon;

    $nextday = `date -d "$checkdate $plus1" +%d`;
    chomp $nextday;

    $nextyr = `date -d "$checkdate $plus1" +%Y`;
    chomp $nextyr;

    # check FIMr1p1 SubX forecast temperature dataset to see if new, latest data are available -- might use one URL each for 2-meter temperature and precipitation to see if data for a point is non-missing,
    # and also check for existence of forecast anomaly data files for week of interest.  Forecast anomaly files have name of form "pr_sfc_weekly_fcst_anom_FIM_06Dec2017_mavg.nc" and
    # "tas_2m_weekly_fcst_anom_FIM_03Jan2018_mavg.nc"
    #
    # URL to get latest start date as dd Mmm YYYY in a file:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/.forecast/.tas/S/last/VALUE/.S/%28%25d%20%25b%20%25Y%29/strftimes/data.ch

    $nextfildate = "$nextday" . "$nextmon" . "$nextyr";
    chomp $nextfildate;
    print "$nextfildate\n";

    $nextprintdate = "$nextday" . " " . "$nextmon" . " " . "$nextyr"; 
    chomp $nextprintdate;

    if($nextfildate eq $fcstdate) {

	chdir "/Data/SubX/ESRL/FIMr1p1/fcst_anom9916bp/tas_2m" or die "Couldn't change local directory! (2)\n";

	$whatdir = `pwd`;
	print "$whatdir\n";

	# temperature anomaly:

	$nexttasfil = "tas_2m_weekly_fcst_anom_FIM_" . "$nextfildate" . "_mavg.nc"; 
	chomp $nexttasfil;

	print "$nexttasfil\n";

	system("wget http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/.forecast/.tas/S/7/STEP/[X/Y/M/L/S]REORDER/2/RECHUNK/[M]average/S/%280000%20${nextday}%20${nextmon}%20${nextyr}%29/VALUE/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/.hindcast/.dc9916/.tas/S/%280000%20${nextday}%20${nextmon}%29/VALUE/S/removeGRID/sub/%28Celsius_scale%29/unitconvert//long_name/%282-meter%20Mean%20Air%20Temperature%20Anomaly%29/def/L/7/boxAverage/S//long_name/%28Forecast%20Start%20Time%29/def/pop/data.nc ; mv data.nc $nexttasfil");

	chdir "/Data/SubX/ESRL/FIMr1p1/fcst_anom9916bp/pr_sfc" or die "Couldn't change local directory! (3)\n";

	$whatdir = `pwd`;
	print "$whatdir\n";

	# precipitation anomaly:

	$nextprfil = "pr_sfc_weekly_fcst_anom_FIM_" . "$nextfildate" . "_mavg.nc";
	chomp $nextprfil;
	print "$nextprfil\n";

	system("wget http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/.forecast/.pr/S/7/STEP/[X/Y/M/L/S]REORDER/2/RECHUNK/[M]average/S/%280000%20${nextday}%20${nextmon}%20${nextyr}%29/VALUE/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/.hindcast/.dc9916/.pr/S/%280000%20${nextday}%20${nextmon}%29/VALUE/S/removeGRID/sub/c:/0.001/%28m3%20kg-1%29/:c/mul/c:/1000/%28mm%20m-1%29/:c/mul/c:/86400/%28s%20day-1%29/:c/mul/prcp_anomaly//long_name/%28Precipitation%20Anomaly%29/def/L/7/boxAverage/S//long_name/%28Forecast%20Start%20Time%29/def/pop/data.nc ; mv data.nc $nextprfil");

    } # end if

    $checkdate = $nextdate;
    chomp $checkdate;

} # end of while loop

exit;


#!/usr/bin/perl -w

# HadCRUT3update2.pl
# Modified from script used to download SST and pseudo-stress data
# from FUNCEME "funcemetropatl.pl"

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;

my $browser = LWP::UserAgent->new();

#$local="/Data/data7/uea/cru/Jones/HadCRUT3";

chdir "/Data/data7/uea/cru/Jones/HadCRUT3";

$fil1 = $browser -> mirror("http://hadobs.metoffice.com/hadcrut3/data/HadCRUT3.nc", 'HadCRUT3.nc');

if($fil1->is_success()) {
  print "Successfully retrieved HadCRUT3.nc\n";
} else {
  print "Didn't get HadCRUT3.nc\n";
}

$fil2 = $browser -> mirror("http://hadobs.metoffice.com/hadcrut3/data/HadCRUT3_m+s_error.nc", 'HadCRUT3_m+s_error.nc');

if($fil2->is_success()) {
  print "Successfully retrieved HadCRUT3_m+s_error.nc\n";
} else {
  print "Didn't get HadCRUT3_m+s_error.nc\n";
}

$fil3 = $browser -> mirror("http://hadobs.metoffice.com/hadcrut3/data/HadCRUT3_station_error.nc", 'HadCRUT3_station_error.nc');

if($fil3->is_success()) {
  print "Successfully retrieved HadCRUT3_station_error.nc\n";
} else {
  print "Didn't get HadCRUT3_station_error.nc\n";
}

$fil4 = $browser -> mirror("http://hadobs.metoffice.com/hadcrut3/data/HadCRUT3_biased_2.5pc.nc", 'HadCRUT3_biased_2.5pc.nc');

if($fil4->is_success()) {
  print "Successfully retrieved HadCRUT3_biased_2.5pc.nc\n";
} else {
  print "Didn't get HadCRUT3_biased_2.5pc.nc\n";
}

$fil5 = $browser -> mirror("http://hadobs.metoffice.com/hadcrut3/data/HadCRUT3_biased_97.5pc.nc", 'HadCRUT3_biased_97.5pc.nc');

if($fil5->is_success()) {
  print "Successfully retrieved HadCRUT3_biased_97.5pc.nc\n";
} else {
  print "Didn't get HadCRUT3_biased_97.5pc.nc\n";
}

$fil6 = $browser -> mirror("http://hadobs.metoffice.com/hadcrut3/data/HadCRUT3v.nc", 'HadCRUT3v.nc');

if($fil6->is_success()) {
  print "Successfully retrieved HadCRUT3v.nc\n";
} else {
  print "Didn't get HadCRUT3v.nc\n";
}

exit;


#!/usr/bin/perl -w

# CRUTEM3update2.pl
# Modified from script used to download SST and pseudo-stress data
# from FUNCEME "funcemetropatl.pl"

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;

my $browser = LWP::UserAgent->new();

$local="/crunch/c14/benno/Data/data7/uea/cru/Jones/CRUTEM3";

chdir "/crunch/c14/benno/Data/data7/uea/cru/Jones/CRUTEM3";

$fil1 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3.nc", 'CRUTEM3.nc');

if($fil1->is_success()) {
  print "Successfully retrieved CRUTEM3.nc\n";
} else {
  print "Didn't get CRUTEM3.nc\n";
}

$fil2 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3_nobs.nc", 'CRUTEM3_nobs.nc');

if($fil2->is_success()) {
  print "Successfully retrieved CRUTEM3_nobs.nc\n";
} else {
  print "Didn't get CRUTEM3_nobs.nc\n";
}

$fil3 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3_sampling_error.nc", 'CRUTEM3_sampling_error.nc');

if($fil3->is_success()) {
  print "Successfully retrieved CRUTEM3_sampling_error.nc\n";
} else {
  print "Didn't get CRUTEM3_sampling_error.nc\n";
}

$fil4 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3_station_error.nc", 'CRUTEM3_station_error.nc');

if($fil4->is_success()) {
  print "Successfully retrieved CRUTEM3_station_error.nc\n";
} else {
  print "Didn't get CRUTEM3_station_error.nc\n";
}

$fil5 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3_biased_97.5pc.nc", 'CRUTEM3_biased_97.5pc.nc');

if($fil5->is_success()) {
  print "Successfully retrieved CRUTEM3_biased_97.5pc.nc\n";
} else {
  print "Didn't get CRUTEM3_biased_97.5pc.nc\n";
}

$fil6 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3_biased_2.5pc.nc", 'CRUTEM3_biased_2.5pc.nc');

if($fil6->is_success()) {
  print "Successfully retrieved CRUTEM3_biased_2.5pc.nc\n";
} else {
  print "Didn't get CRUTEM3_biased_2.5pc.nc\n";
}

$fil7 = $browser -> mirror("http://hadobs.metoffice.com/crutem3/data/CRUTEM3v.nc", 'CRUTEM3v.nc');

if($fil7->is_success()) {
  print "Successfully retrieved CRUTEM3v.nc\n";
} else {
  print "Didn't get CRUTEM3v.nc\n";
}

exit;


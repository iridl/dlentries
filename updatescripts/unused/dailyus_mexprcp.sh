#! /bin/csh
set stagedir='/Data/data8/noaa/ncep/regional/us_mexico'
set datadir='/Data/data6/noaa/cpc/regional/US_Mexico/realtime'
set ingriddir='/Data/data1/DataCatalog/entries/NOAA/NCEP/CPC/REGIONAL/US_Mexico/daily/gridded/realtime'
#
#update data files
#
cd $stagedir
/usr/local/bin/webcopy -r http://www.cpc.ncep.noaa.gov/products/precip/realtime/US_MEX/precip_data/ http://iriproxy:3128 
find . -name '*.ll' -newer $datadir/US_Mex_daily_prcp.r4  -type f  -exec ./us_mexdaily \{} \;
./us_mexdaily `date +./%Y%m%d.ll`
#cp US_Mex_daily_prcp.r4 $datadir
#
#update ingrid description file
#
cat <<EOF > $ingriddir/index.tex
\begin{ingrid}
continuedataset:
grid:
/name /X def
degE
-140 0.25 -60
:grid
grid:
/name /Y def
degN
10 0.25 60
:grid
grid:
/name /T def
/units (days since 2001-05-01 12:00:00) def
/defaultvalue {last} def
0 1 `date +'%d %b %Y'` julian_day 1 sub
01 May 2001 julian_day sub
:grid
variable:
/name /prcp def
/units (in/day) def
/missing_value -9999. def
grids:
X Y | T
:grids
file: 
/name ($datadir/US_Mex_daily_prcp.r4) def
direct
:file
:variable
:dataset
\end{ingrid}
EOF


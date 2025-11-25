#!/bin/sh
/usr/bin/wget -N http://www.inia.org.uy/disciplinas/agroclima/banco_met/sa2005.txt
/usr/bin/wget -N http://www.inia.org.uy/disciplinas/agroclima/banco_met/le2005.txt
/usr/bin/wget -N http://www.inia.org.uy/disciplinas/agroclima/banco_met/tb2005.txt
/usr/bin/wget -N http://www.inia.org.uy/disciplinas/agroclima/banco_met/tt2005.txt
/usr/bin/wget -N http://www.inia.org.uy/disciplinas/agroclima/banco_met/lb2005.txt

if [ `find . -name '*.txt' -newer enddate | wc -l` != 0 ]; then
./concat.pl
mv -f enddate* /beluga/data/datag/INIA/GRAS/Daily/
mv -f data* /beluga/data/datag/INIA/GRAS/Daily/
fi




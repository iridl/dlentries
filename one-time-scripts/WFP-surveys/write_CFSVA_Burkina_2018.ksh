#!/bin/ksh

#writes DC entries for WFP VAM Burkina 2016 Bobo survey
#uses data exported from licensed SPSS sav file
#data is then loaded in IRID DB sql
#Before rerunning, remove Section01/index.tex

#Defines data and metadata files to read
#file_data="/Data/data6/WFP/BurkinaFaso/VAMU/Bases_VAMUOB2016/ENSAS2016_WFP.dat"
file_val="/Data/data6/WFP/BurkinaFaso/VAMU/vamu2018/Base_principale_menage_var_val.csv"
file_var="/Data/data6/WFP/BurkinaFaso/VAMU/vamu2018/Base_principale_menage_var.txt"
#Defines DC files to write
#Sections are motivated by:
#-- sections of the questionnaire -- provided separately
#-- number of variables Ingrid can handle in one dataset
file_Section01="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section01/index.tex"
file_Section02="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section02/index.tex"
file_Section02b="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section02b/index.tex"
file_Section03="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section03/index.tex"
file_Section04="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section04/index.tex"
file_Section04b="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section04b/index.tex"
file_Section05="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section05/index.tex"
file_Section06="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section06/index.tex"
file_Section07="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section07/index.tex"
file_Section08="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section08/index.tex"
file_Section09="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2018/Section09/index.tex"

#Initialize first file to write

if [[ -e "$file_Section01" ]] ; then
  rm $file_Section01
fi

echo '\begin{ingrid}

continuedataset:
' >> $file_Section01;

#Initialize other files to write
for myindex in $file_Section02 $file_Section02b $file_Section03 $file_Section04 $file_Section04b $file_Section05 $file_Section06 $file_Section07 $file_Section08 $file_Section09
do
  cp $file_Section01 $myindex
  case $myindex in
    $file_Section02)
      echo "/description (GENERALITES) def
" >> $myindex ;;
    $file_Section02)
      echo "/description (HABITAT) def
" >> $myindex ;;
    $file_Section03)
      echo "/description (DEMOGRAPHIE) def
" >> $myindex ;;
    $file_Section04)
      echo "/description (CONSOMMATION ALIMENTAIRE) def
" >> $myindex ;;
    $file_Section04b)
      echo "/description (CONSOMMATION ALIMENTAIRE - AUTRES) def
" >> $myindex ;;
    $file_Section05)
      echo "/description (INSECURITE ALIMENTAIRE) def
" >> $myindex ;;
    $file_Section06)
      echo "/description (ANTHROPOMETRIE) def
" >> $myindex ;;
    $file_Section07)
      echo "/description (TRANSFERT ET DEPENSES) def
" >> $myindex ;;
    $file_Section08)
      echo "/description (CHOCS) def
" >> $myindex ;;
    $file_Section09)
      echo "/description (CALCULS) def
" >> $myindex ;;
    *)
      ;;
  esac
done

echo "/description (IDENTIFICATION) def
" >> $file_Section01

#Loop on lines of file listing variables

while IFS= read -r "myline"; do
  #Defines what to use for name and long_name
  myvar=$(echo "$myline" | cut -f 1 )
  myvarlc=$(echo "$myline" | cut -f 1 | tr 'A-Z' 'a-z')
  echo "$myvar"
  mylongname=$(echo "$myline" | cut -f 3 )
  if [ "$mylongname" == "NA" ] ; then
    mylongname=$myvar
  fi

  #Switch which file to write to based on variable
  case $myvar in
    ZD)
      myindex=$file_Section01 ;;
    QG01)
      myindex=$file_Section02 ;;
    QG19)
      myindex=$file_Section02b ;;
    QD0b)
      myindex=$file_Section03 ;;
    QDM0b)
      myindex=$file_Section04 ;;
    CONS_OEUF1)
      myindex=$file_Section04b ;;
    QVR2)
      myindex=$file_Section05 ;;
    Date_entretien)
      myindex=$file_Section06 ;;
    QT01)
      myindex=$file_Section07 ;;
    QCE1__1)
      myindex=$file_Section08 ;;
    interview__id)
      myindex=$file_Section09 ;;
    *)
      ;;
  esac

  #writes the entry for the variable definition  
  printf "/" >> $myindex
  if [ "$myvar" == "GPS__Latitude" ] ; then
    myvar="lat"
  fi
  if [ "$myvar" == "GPS__Longitude" ] ; then
    myvar="lon"
  fi
  printf $myvar >> $myindex
  printf " { IRIDB (BF_VAMU_2018) (" >> $myindex
  printf "$myvarlc" >> $myindex
  echo ') [(hhid)] open_column_by' >> $myindex
  printf "/long_name (" >> $myindex
  printf "$mylongname" >> $myindex
  echo ') def ' >> $myindex
  printf "/missing_value -999999999 def
" >> $myindex
  if [ "$myvar" == "lat" ] ; then
    printf "/units /degree_north def" >> $myindex
    printf "/scale_min 9. def" >> $myindex
    printf "/scale_max 15.5 def" >> $myindex
  fi
  if [ "$myvar" == "lon" ] ; then
    printf "/units /degree_east def" >> $myindex
    printf "/scale_min -6. def" >> $myindex
    printf "/scale_max 2.5 def" >> $myindex
  fi 

  #Writes CLIST for categorical variables
  myvar2change=""
  myvar2k="QG01"
  myscalemax=0
  mymax=""
  #Loop on the file to read to get CLIST keys
  while IFS2= read -r "myline2"; do
    myvar2=$(echo "$myline2" | cut -f 1)
    myvalue=$(echo "$myline2" | cut -f 2)
    myCLIST=$(echo "$myline2" | cut -f 3)
    if [ "$myCLIST" != "missing" ] ; then
      if [ "$myvar2" == "idem" ] ; then
        myvar2=$myvar2k
      fi
    
      if [ "$myvar" == "$myvar2" ] ; then
        if [ "$myvar2change" != "$myvar2" ] ; then
          printf "/units /ids def
" >> $myindex
          printf "/CLIST [" >> $myindex
          myvar2change=$myvar2
          myscalemin=$myvalue
        fi
        printf "(" >> $myindex
        printf "$myCLIST" >> $myindex
        echo ')' >> $myindex
          myscalemax=$myvalue
          mymax=""
      fi
    fi
    myvar2k=$myvar2
  done <"$file_val"
  
  if [ "$myvar2change" != "" ] ; then
    echo '] def' >> $myindex
#    case $myvar in
#      Q222_*|Q225)
#        echo $mymax >> $myindex ;;
#      *)
#        ;;
#     esac
    printf "/scale_min " >> $myindex
    printf $myscalemin >> $myindex
    printf " def
" >> $myindex
    printf "/scale_max " >> $myindex
    printf $myscalemax >> $myindex
    printf " def
" >> $myindex
  fi

  echo '}defasvarsilentnoreuse
' >> $myindex

done <"$file_var"

#Prints the definition of the hh grid for all DC files
for myindex in $file_Section01 $file_Section02 $file_Section02b $file_Section03 $file_Section04 $file_Section04b $file_Section05 $file_Section06 $file_Section07 $file_Section08 $file_Section09
do
  echo '/zdummy {c: 0 :c}defasvar
:dataset
' >> $myindex;

  case $myindex in
    $file_Section01)
      printf 'ZD .hhid name exch def
' >> $myindex ;;
    $file_Section02)
      printf 'QG01 .hhid name exch def
' >> $myindex ;;
    $file_Section02b)
      printf 'QG19 .hhid name exch def
' >> $myindex ;;
    $file_Section03)
      printf 'QD0b .hhid name exch def
' >> $myindex ;;
    $file_Section04)
      printf 'QDM0b .hhid name exch def
' >> $myindex ;;
    $file_Section04b)
      printf 'CONS_OEUF1 .hhid name exch def
' >> $myindex ;;
    $file_Section05)
      printf 'QVR2 .hhid name exch def
' >> $myindex ;;
    $file_Section06)
      printf 'Date_entretien .hhid name exch def
' >> $myindex ;;
    $file_Section07)
      printf 'QT01 .hhid name exch def
' >> $myindex ;;
    $file_Section08)
      printf 'QCE1__1 .hhid name exch def
' >> $myindex ;;
    $file_Section09)
      printf 'interview__id .hhid name exch def
' >> $myindex ;;
    *)
      ;;
  esac

  #Wrap up DC entry file
  echo '\end{ingrid}
' >> $myindex;
done

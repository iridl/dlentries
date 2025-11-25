#!/bin/ksh

#writes DC entries for WFP VAM Burkina 2016 Bobo survey
#uses data exported from licensed SPSS sav file
#data is then loaded in IRID DB sql
#Before rerunning, remove Section01/index.tex

#Defines data and metadata files to read
#file_data="/Data/data6/WFP/BurkinaFaso/VAMU/Bases_VAMUOB2016/ENSAS2016_WFP.dat"
file_val="/Data/data6/WFP/BurkinaFaso/VAMU/Bases_VAMUOB2016/Main_VAMUB_var_val.csv"
file_var="/Data/data6/WFP/BurkinaFaso/VAMU/Bases_VAMUOB2016/Main_VAMUB_var.txt"
#Defines DC files to write
#Sections are motivated by:
#-- sections of the questionnaire -- provided separately
#-- number of variables Ingrid can handle in one dataset
file_Section01="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section01/index.tex"
file_Section02="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section02/index.tex"
file_Section03="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section03/index.tex"
file_Section04="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section04/index.tex"
file_Section05="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section05/index.tex"
file_Section06="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section06/index.tex"
file_Section07a="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionA/index.tex"
file_Section07b1="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/CEREALES/index.tex"
file_Section07b2="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/RACINES_ET_TUBERCULES/index.tex"
file_Section07b3="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/PROTEAGINEUX/index.tex"
file_Section07b4="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/OLEAGINEUX/index.tex"
file_Section07b5="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/LEGUMES_RICHES_EN_VIT_A/index.tex"
file_Section07b6="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/LEGUMES_FEUILLES/index.tex"
file_Section07b7="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/LEGUMES_AUTRES/index.tex"
file_Section07b8="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/FRUITS_RICHES_EN_VIT_A/index.tex"
file_Section07b9="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/FRUITS_AUTRES/index.tex"
file_Section07b10="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/HUILE_RICHE_EN_VIT_A/index.tex"
file_Section07b11="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/AUTRES_HUILES_ET_GRAISSES/index.tex"
file_Section07b12="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/OEUFS/index.tex"
file_Section07b13="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/PRODUITS_LAITIERS/index.tex"
file_Section07b14="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/FOIES_ABATS_PLEINS/index.tex"
file_Section07b15="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/AUTRES_ABATS_INSECTES/index.tex"
file_Section07b16="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/VIANDES_ET_VOLAILLES/index.tex"
file_Section07b17="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/POISSONS_ET_FRUITS_DE_MER/index.tex"
file_Section07b18="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/SUCRES_SIMPLES/index.tex"
file_Section07b19="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/BOISSONS_ALCOOLISEES/index.tex"
file_Section07b20="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/CONDIMENTS/index.tex"
file_Section07b21="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section07/SectionB/AUTRE/index.tex"
file_Section08="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section08/index.tex"
file_Section09="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section09/index.tex"
file_Section101="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH01/index.tex"
file_Section102="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH02/index.tex"
file_Section103="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH03/index.tex"
file_Section104="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH04/index.tex"
file_Section105="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH05/index.tex"
file_Section106="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH06/index.tex"
file_Section107="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH07/index.tex"
file_Section108="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH08/index.tex"
file_Section109="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH09/index.tex"
file_Section1010="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH10/index.tex"
file_Section1011="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH11/index.tex"
file_Section1012="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH12/index.tex"
file_Section1013="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH13/index.tex"
file_Section1014="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH14/index.tex"
file_Section1016="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH16/index.tex"
file_Section1017="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH17/index.tex"
file_Section1018="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH18/index.tex"
file_Section1019="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH19/index.tex"
file_Section1020="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH20/index.tex"
file_Section1021="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section10/CH21/index.tex"
file_Section11="/data/remic/DataCatalogdev/dlentries/entries/UN/WFP/VAM/CFSVA/BurkinaFaso/VAMU2016/Bobo/Section11/index.tex"

#Initialize first file to write
echo '\begin{ingrid}

continuedataset:
' >> $file_Section01;

#Initialize other files to write
for myindex in $file_Section02 $file_Section03 $file_Section04 $file_Section05 $file_Section06 $file_Section07a $file_Section07b1 $file_Section07b2 $file_Section07b3 $file_Section07b4 $file_Section07b5 $file_Section07b6 $file_Section07b7 $file_Section07b8 $file_Section07b9 $file_Section07b10 $file_Section07b11 $file_Section07b12 $file_Section07b13 $file_Section07b14 $file_Section07b15 $file_Section07b16 $file_Section07b17 $file_Section07b18 $file_Section07b19 $file_Section07b20 $file_Section07b21 $file_Section08 $file_Section09 $file_Section101 $file_Section102 $file_Section103 $file_Section104 $file_Section105 $file_Section106 $file_Section107 $file_Section108 $file_Section109 $file_Section1010 $file_Section1011 $file_Section1012 $file_Section1013 $file_Section1014 $file_Section1016 $file_Section1017 $file_Section1018 $file_Section1019 $file_Section1020 $file_Section1021
do
  cp $file_Section01 $myindex
  case $myindex in
    $file_Section02)
      echo "/description (GENERALITES) def
" >> $myindex ;;
    $file_Section03)
      echo "/description (HABITATION) def
" >> $myindex ;;
    $file_Section04)
      echo "/description (BIENS DE CONSOMMATION COURANTE) def
" >> $myindex ;;
    $file_Section05)
      echo "/description (ANIMAUX) def
" >> $myindex ;;
    $file_Section06)
      echo "/description (VEGETATION ET AGRICULTURE URBAINE) def
" >> $myindex ;;
    $file_Section07a)
      echo "/description (DIVERSITE ALIMENTAIRE) def
" >> $myindex ;;
    $file_Section07b1)
      echo "/description (CEREALES) def
" >> $myindex ;;
    $file_Section07b2)
      echo "/description (RACINES ET TUBERCULES) def
" >> $myindex ;;
    $file_Section07b3)
      echo "/description (PROTEAGINEUX) def
" >> $myindex ;;
    $file_Section07b4)
      echo "/description (OLEAGINEUX) def
" >> $myindex ;;
    $file_Section07b5)
      echo "/description (LEGUMES RICHES EN VIT. A) def
" >> $myindex ;;
    $file_Section07b6)
      echo "/description (LEGUMES FEUILLES) def
" >> $myindex ;;
    $file_Section07b7)
      echo "/description (LEGUMES AUTRES) def
" >> $myindex ;;
    $file_Section07b8)
      echo "/description (FRUITS RICHES EN VIT A) def
" >> $myindex ;;
    $file_Section07b9)
      echo "/description (FRUITS AUTRES) def
" >> $myindex ;;
    $file_Section07b10)
      echo "/description (HUILE RICHE EN VIT A) def
" >> $myindex ;;
    $file_Section07b11)
      echo "/description (AUTRES HUILES ET GRAISSES) def
" >> $myindex ;;
    $file_Section07b12)
      echo "/description (OEUFS) def
" >> $myindex ;;
    $file_Section07b13)
      echo "/description (PRODUITS LAITIERS) def
" >> $myindex ;;
    $file_Section07b14)
      echo "/description (FOIES/ ABATS PLEINS) def
" >> $myindex ;;
    $file_Section07b15)
      echo "/description (AUTRES ABATS/ INSECTES) def
" >> $myindex ;;
    $file_Section07b16)
      echo "/description (VIANDES ET VOLAILLES) def
" >> $myindex ;;
    $file_Section07b17)
      echo "/description (POISSONS ET FRUITS DE MER) def
" >> $myindex ;;
    $file_Section07b18)
      echo "/description (SUCRES SIMPLES) def
" >> $myindex ;;
    $file_Section07b19)
      echo "/description (BOISSONS ALCOOLISEES) def
" >> $myindex ;;
    $file_Section07b20)
      echo "/description (CONDIMENTS) def
" >> $myindex ;;
    $file_Section07b21)
      echo "/description (AUTRE) def
" >> $myindex ;;
    $file_Section08)
      echo "/description (INSECURITE ALIMENTAIRE) def
" >> $myindex ;;
    $file_Section09)
      echo "/description (TRANSFERT ET ENVOI) def
" >> $myindex ;;
    $file_Section101)
      echo "/description (Perte d'emploi d'un membre) def
" >> $myindex ;;
    $file_Section102)
      echo "/description (Réduction de revenu des membres) def
" >> $myindex ;;
    $file_Section103)
      echo "/description (Arrivée imprévue d'autres personnes) def
" >> $myindex ;;
    $file_Section104)
      echo "/description (Maladies ou accident graves d'un membre) def
" >> $myindex ;;
    $file_Section105)
      echo "/description (Décès du Chef de ménage) def
" >> $myindex ;;
    $file_Section106)
      echo "/description (Décès d'un membre actif) def
" >> $myindex ;;
    $file_Section107)
      echo "/description (Décès d'un autre membre / proche) def
" >> $myindex ;;
    $file_Section108)
      echo "/description (Départ forcé/séparation) def
" >> $myindex ;;
    $file_Section109)
      echo "/description (Des prix anormalement élevés des aliments) def
" >> $myindex ;;
    $file_Section1010)
      echo "/description (Des prix anormalement élevés  du carb./transp.) def
" >> $myindex ;;
    $file_Section1011)
      echo "/description (Des prix anormalement élevés de l'électricité) def
" >> $myindex ;;
    $file_Section1012)
      echo "/description (Des prix anormalement élevés de location/construction) def
" >> $myindex ;;
    $file_Section1013)
      echo "/description (Sécheresse/pluies irrégulières, pause prolongée) def
" >> $myindex ;;
    $file_Section1014)
      echo "/description (Inondation/fortes pluies/vents violents) def
" >> $myindex ;;
    $file_Section1016)
      echo "/description (Incendies) def
" >> $myindex ;;
    $file_Section1017)
      echo "/description (Des niveaux élevés anormalement des nuisibles/maladies) def
" >> $myindex ;;
    $file_Section1018)
      echo "/description (Epidémies) def
" >> $myindex ;;
    $file_Section1019)
      echo "/description (Vol des ressources productives) def
" >> $myindex ;;
    $file_Section1020)
      echo "/description (Insécurité/violence) def
" >> $myindex ;;
    $file_Section1021)
      echo "/description (Autre choc) def
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
    SubmissionDate|id_merge)
      myindex=$file_Section01 ;;
    QG01_37)
      myindex=$file_Section02 ;;
    QH02_114|QH01_1130001)
      myindex=$file_Section03 ;;
    QBC011_134)
      myindex=$file_Section04 ;;
    QA011_338)
      myindex=$file_Section05 ;;
    QVAU01_3904000)
      myindex=$file_Section06 ;;
    QDA00_442)
      myindex=$file_Section07a ;;
    QDA0601_481)
      myindex=$file_Section07b1 ;;
    QDA0701_495)
      myindex=$file_Section07b2 ;;
    QDA0801_509)
      myindex=$file_Section07b3 ;;
    QDA0901_523)
      myindex=$file_Section07b4 ;;
    QDA01001_537)
      myindex=$file_Section07b5 ;;
    QDA1101_551)
      myindex=$file_Section07b6 ;;
    QDA1201_565)
      myindex=$file_Section07b7 ;;
    QDA1301_579)
      myindex=$file_Section07b8 ;;
    QDA1401_593)
      myindex=$file_Section07b9 ;;
    QDA1501_607)
      myindex=$file_Section07b10 ;;
    QDA1601_621)
      myindex=$file_Section07b11 ;;
    QDA1701_635)
      myindex=$file_Section07b12 ;;
    QDA1801_649)
      myindex=$file_Section07b13 ;;
    QDA1901_663)
      myindex=$file_Section07b14 ;;
    QDA2001_677)
      myindex=$file_Section07b15 ;;
    QDA2101_691)
      myindex=$file_Section07b16 ;;
    QDA2201_705)
      myindex=$file_Section07b17 ;;
    QDA2301_719)
      myindex=$file_Section07b18 ;;
    QDA2401_733)
      myindex=$file_Section07b19 ;;
    QDA2501_747)
      myindex=$file_Section07b20 ;;
    QDA2507_75335000)
      myindex=$file_Section07b21 ;;
    QV001_774)
      myindex=$file_Section08 ;;
    QT01_948)
      myindex=$file_Section09 ;;
    CH01*)
      myindex=$file_Section101 ;;
    CH02*)
      myindex=$file_Section102 ;;
    CH03*)
      myindex=$file_Section103 ;;
    CH04*)
      myindex=$file_Section104 ;;
    CH05*)
      myindex=$file_Section105 ;;
    CH06*)
      myindex=$file_Section106 ;;
    CH07*)
      myindex=$file_Section107 ;;
    CH08*)
      myindex=$file_Section108 ;;
    CH09*)
      myindex=$file_Section109 ;;
    CH10*)
      myindex=$file_Section1010 ;;
    CH11*)
      myindex=$file_Section1011 ;;
    CH12*)
      myindex=$file_Section1012 ;;
    CH13*)
      myindex=$file_Section1013 ;;
    CH14*)
      myindex=$file_Section1014 ;;
    CH16*)
      myindex=$file_Section1016 ;;
    CH17*)
      myindex=$file_Section1017 ;;
    CH18*)
      myindex=$file_Section1018 ;;
    CH19*)
      myindex=$file_Section1019 ;;
    CH20*)
      myindex=$file_Section1020 ;;
    CH21*)
      myindex=$file_Section1021 ;;
    *)
      ;;
  esac

  #writes the entry for the variable definition  
  printf "/" >> $myindex
  printf $myvar >> $myindex
  printf " { IRIDB (BF_VAMUB_2016) (" >> $myindex
  printf "$myvarlc" >> $myindex
  echo ') [(hhid)] open_column_by' >> $myindex
  printf "/long_name (" >> $myindex
  printf "$mylongname" >> $myindex
  echo ') def ' >> $myindex
  printf "/missing_value -999 def
" >> $myindex

  #Writes CLIST for categorical variables
  myvar2change=""
  myvar2k="ID05_1434000"
  myscalemax=0
  mymax=""
  #Loop on the file to read to get CLIST keys
  while IFS2= read -r "myline2"; do
    myvar2=$(echo "$myline2" | cut -f 1)
    myvalue=$(echo "$myline2" | cut -f 2)
    myCLIST=$(echo "$myline2" | cut -f 3)
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
#      if [ $myvalue == 8 ] ; then
#        ((myscalemax+=1))
#        mymax="$(($myscalemax)) min"
#      else
        myscalemax=$myvalue
        mymax=""
#      fi
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
for myindex in $file_Section01 $file_Section02 $file_Section03 $file_Section04 $file_Section05 $file_Section06 $file_Section07a $file_Section07b1 $file_Section07b2 $file_Section07b3 $file_Section07b4 $file_Section07b5 $file_Section07b6 $file_Section07b7 $file_Section07b8 $file_Section07b9 $file_Section07b10 $file_Section07b11 $file_Section07b12 $file_Section07b13 $file_Section07b14 $file_Section07b15 $file_Section07b16 $file_Section07b17 $file_Section07b18 $file_Section07b19 $file_Section07b20 $file_Section07b21 $file_Section08 $file_Section09 $file_Section101 $file_Section102 $file_Section103 $file_Section104 $file_Section105 $file_Section106 $file_Section107 $file_Section108 $file_Section109 $file_Section1010 $file_Section1011 $file_Section1012 $file_Section1013 $file_Section1014 $file_Section1016 $file_Section1017 $file_Section1018 $file_Section1019 $file_Section1020 $file_Section1021
do
#  echo '/zdummy {c: 0 :c}defasvar 
  echo ':dataset
' >> $myindex;

  case $myindex in
    $file_Section01)
      printf 'SubmissionDate .hhid name exch def
' >> $myindex ;;
    $file_Section02)
      printf 'QG01_37 .hhid name exch def
' >> $myindex ;;
    $file_Section03)
      printf 'QH02_114 .hhid name exch def
' >> $myindex ;;
    $file_Section04)
      printf 'QBC011_134 .hhid name exch def
' >> $myindex ;;
    $file_Section05)
      printf 'QA011_338 .hhid name exch def
' >> $myindex ;;
    $file_Section06)
      printf 'QVAU01_3904000 .hhid name exch def
' >> $myindex ;;
    $file_Section07a)
      printf 'QDA00_442 .hhid name exch def
' >> $myindex ;;
    $file_Section07b1)
      printf 'QDA0601_481 .hhid name exch def
' >> $myindex ;;
    $file_Section07b2)
      printf 'QDA0701_495 .hhid name exch def
' >> $myindex ;;
    $file_Section07b3)
      printf 'QDA0801_509 .hhid name exch def
' >> $myindex ;;
    $file_Section07b4)
      printf 'QDA0901_523 .hhid name exch def
' >> $myindex ;;
    $file_Section07b5)
      printf 'QDA01001_537 .hhid name exch def
' >> $myindex ;;
    $file_Section07b6)
      printf 'QDA1101_551 .hhid name exch def
' >> $myindex ;;
    $file_Section07b7)
      printf 'QDA1201_565 .hhid name exch def
' >> $myindex ;;
    $file_Section07b8)
      printf 'QDA1301_579 .hhid name exch def
' >> $myindex ;;
    $file_Section07b9)
      printf 'QDA1401_593 .hhid name exch def
' >> $myindex ;;
    $file_Section07b10)
      printf 'QDA1501_607 .hhid name exch def
' >> $myindex ;;
    $file_Section07b11)
      printf 'QDA1601_621 .hhid name exch def
' >> $myindex ;;
    $file_Section07b12)
      printf 'QDA1701_635 .hhid name exch def
' >> $myindex ;;
    $file_Section07b13)
      printf 'QDA1801_649 .hhid name exch def
' >> $myindex ;;
    $file_Section07b14)
      printf 'QDA1901_663 .hhid name exch def
' >> $myindex ;;
    $file_Section07b15)
      printf 'QDA2001_677 .hhid name exch def
' >> $myindex ;;
    $file_Section07b16)
      printf 'QDA2101_691 .hhid name exch def
' >> $myindex ;;
    $file_Section07b17)
      printf 'QDA2201_705 .hhid name exch def
' >> $myindex ;;
    $file_Section07b18)
      printf 'QDA2301_719 .hhid name exch def
' >> $myindex ;;
    $file_Section07b19)
      printf 'QDA2401_733 .hhid name exch def
' >> $myindex ;;
    $file_Section07b20)
      printf 'QDA2501_747 .hhid name exch def
' >> $myindex ;;
    $file_Section07b21)
      printf 'QDA2507_75335000 .hhid name exch def
' >> $myindex ;;
    $file_Section08)
      printf 'QV001_774 .hhid name exch def
' >> $myindex ;;
    $file_Section09)
      printf 'QT01_948 .hhid name exch def
' >> $myindex ;;
    $file_Section101)
      printf 'CH01_1027  .hhid name exch def
' >> $myindex ;;
    $file_Section102)
      printf 'CH02_1043  .hhid name exch def
' >> $myindex ;;
    $file_Section103)
      printf 'CH03_1059  .hhid name exch def
' >> $myindex ;;
    $file_Section104)
      printf 'CH04_1075  .hhid name exch def
' >> $myindex ;;
    $file_Section105)
      printf 'CH05_1091  .hhid name exch def
' >> $myindex ;;
    $file_Section106)
      printf 'CH06_1107  .hhid name exch def
' >> $myindex ;;
    $file_Section107)
      printf 'CH07_1123  .hhid name exch def
' >> $myindex ;;
    $file_Section108)
      printf 'CH08_1139  .hhid name exch def
' >> $myindex ;;
    $file_Section109)
      printf 'CH09_1155  .hhid name exch def
' >> $myindex ;;
    $file_Section1010)
      printf 'CH10_1171  .hhid name exch def
' >> $myindex ;;
    $file_Section1011)
      printf 'CH11_1187  .hhid name exch def
' >> $myindex ;;
    $file_Section1012)
      printf 'CH12_1203  .hhid name exch def
' >> $myindex ;;
    $file_Section1013)
      printf 'CH13_1219  .hhid name exch def
' >> $myindex ;;
    $file_Section1014)
      printf 'CH14_1235  .hhid name exch def
' >> $myindex ;;
    $file_Section1016)
      printf 'CH16_1267  .hhid name exch def
' >> $myindex ;;
    $file_Section1017)
      printf 'CH17_1283  .hhid name exch def
' >> $myindex ;;
    $file_Section1018)
      printf 'CH18_1299  .hhid name exch def
' >> $myindex ;;
    $file_Section1019)
      printf 'CH19_1315  .hhid name exch def
' >> $myindex ;;
    $file_Section1020)
      printf 'CH20_1331  .hhid name exch def
' >> $myindex ;;
    $file_Section1021)
      printf 'CH21_1347  .hhid name exch def
' >> $myindex ;;
    *)
      ;;
  esac

  #Wrap up DC entry file
  echo '\end{ingrid}
' >> $myindex;
done

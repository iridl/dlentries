#!/usr/bin/env python3
import csv
import re
import requests
import os.path as file
import os
import sys

path = '/Data/data1/noaa/indices/'

Data= {
    "nao": ['norm.nao.monthly.b5001.current.ascii.table'],
    "amm-pmm": ['AMM.txt','AMM.RAW.txt','PMM.txt','PMM.RAW.txt'],
    "amo": ['amon.us.long.data','amon.sm.long.data','amon.us.data','amon.sm.data'],
    "dmi": ['dmi.had.long.data','dmiwest.had.long.data','dmieast.had.long.data'],
    "pdo": ['ersst.v5.pdo.dat'],
    "sam": ['newsam.1957.2007.txt']
}

Title= {
    "nao": ['North Atlantic Oscillation Index'],
    "amm-pmm": ['The Atlantic Meridional Mode ', 'The RAW Atlantic Meridional Mode ','The Pacific Meridional Mode','The RAW Pacific Meridional Mode'],
    "amo": ['AMO unsmoothed from the Kaplan SST V2 index, long,','AMO smoothed from the Kaplan SST V2 index, long,','AMO unsmoothed, detrended from the Kaplan SST V2 short (1948 to present),','AMO smoothed/detrended from the Kaplan SST V2, short (1948 to present),'],
    "dmi": ['DMI HadISST1.1, long: Standard PSL Format, ','DMI WEST HadISST1.1, long: Standard PSL Format, ','DMI EAST HadISST1.1, long: Standard PSL Format, '],
    "pdo": ['Pacific Decadal Oscillation Index'],
    "sam": ['An observation-based Southern Hemisphere Annular Mode Index ']
}

Folder= {
    "nao": ['nao'],
    "amm-pmm": ['amm','amm-raw','pmm','pmm-raw'],
    "amo": ['amon-us_long','amon-sm_long','amon-us_short','amon-sm_short'],
    "dmi": ['dmi-had_long','dmiwest-had_long','dmieast-had_long'],
    "pdo": ['pdo'], #
    "sam": ['sam-had_long']
}

pathAux= {
    "nao": '',
    "amm-pmm": 'amm-pmm/',
    "amo": 'amo/',
    "dmi": 'dmi/',
    "pdo": 'pdo/',
    "sam": 'sam/'
}

URL= {
    "nao": 'https://www.cpc.ncep.noaa.gov/products/precip/CWlink/pna/' ,
    "amm-pmm": 'https://www.aos.wisc.edu/dvimont/MModes/RealTime/' ,
    "amo": 'https://psl.noaa.gov/data/correlation/',
    "dmi": 'https://psl.noaa.gov/gcos_wgsp/Timeseries/Data/',
    "pdo": 'https://www.ncei.noaa.gov/pub/data/cmb/ersst/v5/index/' , 
    "sam": 'http://www.nerc-bas.ac.uk/public/icd/gjma/'
}


def WriteFile (DateFile,Units,dataout,TitleF):
    if (file.exists(DateFile)):
        print('This month was processed before')
    else:
        with open(DateFile, 'w') as fileListoutput:
            if Units !='':
                fileListoutput.write('NOAA '+TitleF+'  units: '+Units+' \n')
            else:
                fileListoutput.write('NOAA '+TitleF+'  \n')
            fileListoutput.write('DL-Format, Monthly data\n')
            fileListoutput.write('\n')
            fileListoutput.write(dataout)
        print(dataout)

path = path+pathAux[[sys.argv[-1]][0]]

for Index, word in enumerate(Data[[sys.argv[-1]][0]]):
    #Create the URL for get the dat
    url = URL[[sys.argv[-1]][0]]+Data[[sys.argv[-1]][0]][Index]
    r = requests.get(url)

    #Create Folder by each index if not exist
    try:
        os.stat(path+Folder[[sys.argv[-1]][0]][Index])
    except:
        os.makedirs(path+Folder[[sys.argv[-1]][0]][Index])

    #Get the data from NOAA
    with open(path+Folder[[sys.argv[-1]][0]][Index]+'/'+[sys.argv[-1]][0]+'.data', 'wb') as f:
        f.write(r.content)
    data = open(path+Folder[[sys.argv[-1]][0]][Index]+'/'+[sys.argv[-1]][0]+'.data', 'r')


    #Read data from NOAA and convert to DL txt format
    reader = csv.reader(data, delimiter=" ")
    for row in reader:
        eachLine = ' '.join(row).split()
        #Cases NAO, SAM and PDO
        if [sys.argv[-1]][0] =='nao' or [sys.argv[-1]][0] =='sam' or [sys.argv[-1]][0] =='pdo' :

            if [sys.argv[-1]][0] =='nao' or [sys.argv[-1]][0] =='pdo' :
                Condition= (len(eachLine) >= 2 and eachLine[1]!='Jan' and eachLine[1]!='PDO' and eachLine[1]!='NAO')
            else:
                Condition=(len(eachLine) >= 2)

            if Condition :
                for i in range(1, len(eachLine)):
                    if eachLine[i] != '-99.99' :
                        dataout = eachLine[0]+'-'+str(i).zfill(2)+'\t'+eachLine[i]+'\n'
                        #the data provide by NOAA not use tab when is a missing value
                        #the file concatenate -99.99 (missing value) at the last month available
                        dataout = dataout.replace("-99.99", '')

                        DateFile = path+Folder[[sys.argv[-1]][0]][Index]+'/'+[sys.argv[-1]][0]+'_'+str(eachLine[0])+'-'+str(i).zfill(2)+'.txt'
                        WriteFile (DateFile,'Celsius',dataout,Title[[sys.argv[-1]][0]][Index])

        #Cases AMM-PMM
        elif [sys.argv[-1]][0] =='amm-pmm':
            if len(eachLine) == 4 :
                if eachLine[0].isnumeric() == True :
                    dataout = eachLine[0]+'-'+str(eachLine[1]).zfill(2)+'\t'+eachLine[2]+'\t'+eachLine[3]+'\n'

                    DateFile = path+Folder[[sys.argv[-1]][0]][Index]+'/'+Folder[[sys.argv[-1]][0]][Index]+'_'+str(eachLine[0])+'-'+str(eachLine[1]).zfill(2)+'.txt'
                    WriteFile (DateFile,'Celsius',dataout,Title[[sys.argv[-1]][0]][Index])

        #Cases AMO and DMI
        elif [sys.argv[-1]][0] =='amo' or [sys.argv[-1]][0] =='dmi' :

            if [sys.argv[-1]][0] =='amo':
                NameFile='amon'
            else:
                NameFile=[sys.argv[-1]][0]

            if len(eachLine) == 13 :
                for i in range(1, 13):
                    if eachLine[i] != '-99.990' and eachLine[i] != '-9999.000' :
                        dataout = eachLine[0]+'-'+str(i).zfill(2)+'\t'+eachLine[i]+'\n'

                        DateFile = path+Folder[[sys.argv[-1]][0]][Index]+'/'+NameFile+'_'+str(eachLine[0])+'-'+str(i).zfill(2)+'.txt'
                        WriteFile (DateFile,'',dataout,Title[[sys.argv[-1]][0]][Index])

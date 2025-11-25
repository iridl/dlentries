#!/usr/bin/env python3
import csv
import re
import requests
import os.path as file
import os
import sys
import math

path = '/Data/data1/noaa/indices/'

Data= {
    "romi.cpcolr": ['romi.cpcolr.1x.txt']
}

Title= {
    "romi.cpcolr": ['ROMI: Projection of 9 day running average OLR anomalies']
}

Folder= {
    "romi.cpcolr": ['romi.cpcolr']
}

pathAux= {
    "romi.cpcolr": ''
}

URL= {
    "romi.cpcolr": 'https://psl.noaa.gov/mjo/mjoindex/'
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
            fileListoutput.write('DL-Format, Daily data: Date, hour, PC1, PC2, amplitude, phase\n')
            fileListoutput.write('                       phase is calculated using: ((180+math.atan2(-PC1,PC2)*180/math.pi)/45)+1 \n')
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
        #Cases ROMI
        if [sys.argv[-1]][0] =='romi.cpcolr':
            if len(eachLine) == 7 :
                PC1=float(eachLine[4])
                PC2=float(eachLine[5])
                amplitude=float(eachLine[6])
                # Phase equation ((180+math.atan2(-PC1,PC2)*180/math.pi)/45)+1 provided by agmunoz
                phase = int((180+math.atan2(-PC1,PC2)*180/math.pi)/45)+1
                dataout = eachLine[0]+'-'+eachLine[1].zfill(2)+'-'+eachLine[2].zfill(2)+'\t'+eachLine[3]+'\t'+str(PC1)+'\t'+str(PC2)+'\t'+str(amplitude)+'\t'+str(phase)+'\n'
                DateFile = path+Folder[[sys.argv[-1]][0]][Index]+'/'+Folder[[sys.argv[-1]][0]][Index]+'_'+str(eachLine[0])+'-'+eachLine[1].zfill(2)+'-'+eachLine[2].zfill(2)+'.txt'
                WriteFile (DateFile,'',dataout,Title[[sys.argv[-1]][0]][Index])

#!/usr/local/bin/condarun updatescripts

import csv
import re
import requests
import os.path as file



#path = '/Users/xandre/ACTIVIDADES-PROYECTOS-IRI/NOAA_QBO/'
path = '/Data/data1/noaa/indices/qbo/'

url = 'https://psl.noaa.gov/data/correlation/qbo.data'
r = requests.get(url)

with open(path+'qbo.data', 'wb') as f:
    f.write(r.content)



data = open(path+'qbo.data', 'r')


 
reader = csv.reader(data, delimiter=" ")
for row in reader:
    eachLine = ' '.join(row).split() 
    if len(eachLine) == 13 :
        for i in range(1, 13):
            if eachLine[i] != '-999.00' :
                dataout = eachLine[0]+'-'+str(i).zfill(2)+'\t'+eachLine[i]+'\n'
                
                #print(dateLast)
                DateFile = path+'qbo_'+str(eachLine[0])+'-'+str(i).zfill(2)+'.txt'
                if (file.exists(DateFile)):
                    print('This month was processed before')
                else:
                    with open(DateFile, 'w') as fileListoutput:
                        fileListoutput.write('NOAA QBO index.  units: ms-1 \n') 
                        fileListoutput.write('DL-Format, Monthly data\n') 
                        fileListoutput.write('\n')
                        fileListoutput.write(dataout)
                    print(dataout)


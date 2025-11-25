#!/usr/bin/env python3
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
import os
import subprocess

#Path output
path = '/Data/data23/NASA/GES_DISC/MERRA2/DAILY/M2SDNXSLV.5.12.4/'
#Path with credentials files
credencials ='~/'

#For Old download data turn OldExec to 'True' and define the initial date (UserStart_date) and last date (UserEnd_date)
#For current download data  mantain OldExec in 'False'

OldExec=False
UserStart_date = '01/01/2022' # Format '%m/%d/%Y'
UserEnd_date = '05/01/2022' # Format '%m/%d/%Y'


if (OldExec):
    print('Download old data')
else :
    print('Download current data')
    UserStart_date = (datetime.now() - relativedelta(months=+1)).strftime('%m/%d/%Y')
    UserEnd_date = UserStart_date

start_date = datetime.strptime(UserStart_date, '%m/%d/%Y')
end_date = datetime.strptime(UserEnd_date, '%m/%d/%Y')

UserStart_date=UserEnd_date=None


while start_date <= end_date:
    current_month = start_date.strftime('%m') # Text Month  Ex. Jan
    current_year = start_date.strftime('%Y')  # Full year Ex. 2018
    current_path=os.path.join(path,current_year,current_month)
    
    #Check directory
    if not os.path.exists(current_path):
        # Create a new directory because it does not exist 
        os.makedirs(current_path)
        print("The new directory is created!")    
    #Move to the current path:
    os.chdir(current_path)
    print(os.getcwd())
    
    #Making the command instructions 
    Command='wget --load-cookies '+credencials+'.urs_cookies --save-cookies '+credencials+'.urs_cookies --keep-session-cookies -r -c -nH -nd -N -np -A nc4 --content-disposition "https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2SDNXSLV.5.12.4/'+current_year+'/'+current_month+'/"'
    #print(Command)

    try:
        subprocess.check_output(Command,stderr=subprocess.STDOUT, shell=True)
    except subprocess.CalledProcessError as e:
        print(e.output.decode())
        raise
    
    start_date += relativedelta(months=+1)


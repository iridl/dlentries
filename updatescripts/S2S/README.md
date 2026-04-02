# README
These scripts are used to download data from the ECMWF Data Servers.

## Prerequisites
* An API key from [ECMWF](https://www.ecmwf.int/en/computing/software/ecmwf-web-api) to run
the ecmwf_get_data.py script.
* A login to the aux.ecmwf.int ftp server configured in ~/.netrc  to run the get_rmms scripts. 
  * If you're testing, simply use your ~/.ecmwfapirc key formatted as ECMWF expects.  This script will pick it up.  
  * If you want to use a different key, you can set the environment variable: ECMWFAPIKEYS_FILE to point to a JSON 
  formatted ECMWFAPI Key or an array of keys.\
  For example:
    ```
    [
        {
            "url": "https://api.ecmwf.int/v1",
            "key": "yourkey",
            "email": "youremail@iri.columbia.edu"
        }
    ]
    ```

## Scripts

### get_rmms_lftp.py
This script is used to pull data from the aux.ecmwf.int
FTP site. The files top be pulled are defined in S2S_config.py under
the S2S_FTP_folders1 array.  This could probably be done better!

### ecmwf_get_data.py
Script to download model data from the ECMWF Data Server through the API. This script
sets the environment variables necessary to set the API Key.
Parameters are:
>-h, --help\
show this help message and exit

>--user *username*\
Which ECMWF API key do you want to use (from ~datag/ecmwfapikeys).\
> jefft, jpt11, jingyuan

>--models MODEL [MODEL ...]\
select at least one of the model types: currently acceptable are:
> * **cma**
> * **cnrm**
> * **cptec**
> * **eccc**
> * **ecmf**
> * **ecmf4147**
> * **hmcr**
> * **iapcas**
> * **isac**
> * **jma**
> * **kma**
> * **ncep**
> * **ukmo**
> * **eccc_ref**
> * **ecmf_ref**
> * **hmcr_ref**
> * **kma_ref**
> * **ukmo_ref**\
> but you can select as many as you want: --models kma hmcr ...

>--start YYYY-MM-DD\
Start Day of downloading model data (defaults to today).

>--end YYYY-MM-DD\
End Day to finish downloading data.\
Will only run 1 day if not defined

>--debug\
Turn on ECMWF Data server logging to the logfile

>--dryrun\
> Don't actually download anything

>--max_downloads MAX_DOWNLOADS\
Modify max parallel downloads from default of 10. Only change this to a lower value if you know what you're doing. as ECMWF has a maximum which will get you cut off if you abuse it.

>--goback GOBACK\
Instead of --end, select number of days to go back in time. Default is defined by the model. (60)

>  --days DAYS [DAYS ...]\
List of days to download: Possible values are: ["odd", "even"] ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] ["1", "2", "3", "4", "5", "6", "7"... "31"] for the actual dates.\
This is used to define which dates the data is available on.

>--tmpdir TMPDIR\
Modify default TMPDIR from /Data/tmp 

#### Environment variables for *testing* ecmwf_get_data.py
ECMWFAPIKEYS_FILE - Set your ECMWFAPI key (see pre-requisites section)
ECMWF_S2S_TOPLEVEL - set the toplevel directory of where the files will be downloaded

### ecmwf_get_pooled.py
This script is not meant to be called on its own.  
It is called from ecmwf_get_data.py, which sets the environment
variables necessary for this script to run. Currently, ECMWF limits the number of
parallel downloads (per user key) to 10.  This script creates a pool and insures
we always have up to 10 processes running in parallel, and no more.

## Notes
Running an individual tasks script will let you know what files are missing or
corrupt.  It does a filesystem check of all the files instead of attempting to download anything.
For example:
> \# condarun updatescripts ecmwf_cma_tasks.py

Will tell you what files are missing or corrupt from the start of the dataset to the end.
Since some variables are not available from the start of the dataset, this can gi ve you a
good idea of what is missing for specific dates.

## Important
**Do not run the script** multiple times at once without using different users. Otherwise your
access to ECMWF can get cut off for abusing the system.  Make sure that the cronjobs
do not/will not overlap.


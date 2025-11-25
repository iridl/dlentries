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
Who's ECMWF API key do you want to use (from ~datag/ecmwfapikeys).  If you're testing, using your ~/.ecmwfapirc file,\
> you can ignore this. 

>--models MODEL [MODEL ...]\
select at least of the model types: currently acceptable are:
> * **ecmf**
> * **hmcr**
> * **jma**
> * **kma**
> * **ncep**
> * **ukmo**\
> but you can select as many as you want: --models kma hmcr ...
> These don't currently handle the hindcast datasets yet.

>--start YYYY-MM-DD\
Start Day of downloading model data\
Will use model default if none is specified.

>--end YYYY-MM-DD\
End Day to finish downloading data.\
Will only run 1 day if not defined

>--debug\
Turn on extensive ECMWF Data server logging to the logfile

#### Environment variables for *testing* ecmwf_get_data.py
ECMWFAPIKEYS_FILE - Set your ECMWFAPI key (see pre-requisites section)
ECMWF_S2S_TOPLEVEL - set the toplevel directory of where the files will be downloaded

### ecmwf_get_pooled.py
This script is not meant to be called on its own.  
It is called from ecmwf_get_data.py, which sets the environment
variables necessary for this script to run. Currently, ECMWF limits the number of
parallel downloads (per user key) to 10.  This script creates a pool and insures
we always have up to 10 processes running in parallel, and no more.

## Development Details
### ECMWFModelTaskClass.py
This is the abstract model for calling ECMWF Data.  ALL ECMWF data calls are the
same, with only the task being different.  The task defines the variables from the
specific model you're downloading.  Each task is defined in the subclasses 

#### ecmwf_ecmf_tasks.py
* ECMF/REL/PF
* ECMF/REL/CF

#### ecmwf_hmcr_tasks.py
* HMCR/REL/PF
* HMCR/REL/CF
* HMCR/REL_new/PF
* HMCR/REL_new/CF

#### ecmwf_jma_tasks.py
* JMA/REL/PF
* JMA/REL/CF

#### ecmwf_kma_tasks.py
* KMA/REL/PF
* KMA/REL/CF
* KMA/REL_new/PF
* KMA/REL_new/CF

#### ecmwf_ncep_tasks.py
* NCEP/REL/PF
* NCEP/REL/CF

#### ecmwf_ukmo_tasks.py
* UKMO/REL/PF
* UKMO/REL/CF

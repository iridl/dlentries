#!/usr/local/bin/condarun updatescripts
#
# Script copies IRI NMME Seasonal Forecast files on a monthly basis from Jing Yuan's home space
# to /Data
#
# This will only be allowed to be run on the 15th or later for Seasonal Forecasts and the 18th or later
# for the Flexible Forecast
#
import paramiko
import datetime

# Remote Host: Where do we get the data from?
# optimus is the current actual primary server for /data/jingyuan
remote_host = "optimus.iri.columbia.edu"

# Need to make sure the private key for copying is installed in ~/.ssh
remote_user = "datag"
keyfile = "/home/datag/.ssh/forecast_rsa"

# Get dates
today = datetime.date.today()
day = today.day
mon = today.strftime("%b")
year = today.year

def create_sftp_client(host, username, keyfilepath):
    """
    create_sftp_client(host, username, keyfilepath) -> SFTPClient

    Creates a SFTP client connected to the supplied host on the supplied port authenticating as the user with
    supplied username and the private RSA key in a file with the supplied path.
    :rtype: SFTPClient object.
    """
    sftp = None
    key = None
    transport = None

    if keyfilepath is not None:
        # Get the RSA private key used to authenticate user.
        key = paramiko.RSAKey.from_private_key_file(keyfilepath)

    # Create Transport object using supplied method of authentication.
    # default FTP port = 222
    transport = paramiko.Transport(host, 22)
    transport.connect(hostkey=None, username=username, pkey=key)
    sftp = paramiko.SFTPClient.from_transport(transport)

    return sftp

    
if day < 15:
    print("Can not be published until the 15th of the month\n")
    exit(-1)


# Copy an input file to an output directory
def get_file(infile, outfile):

    client = create_sftp_client(remote_host, remote_user, keyfile)
    if client:
        print(f"Copying {infile} to {outfile} ...")
        client.get(infile, outfile)
        print(f"Done\n")
        client.close()
            

# FLEXIBLE Forecasts
INPUT_FLEXIBLE_DIR = f"/data/jingyuan/NMME_nc/forecast_{mon}_{year}"
OUTPUT_FLEXIBLE_DIR = "/Data/data21/iri/FD.3"

for f in ['forecast_coeff', 'forecast_clim_coeff', 'forecast_mean']:
    for x in ['tref', 'precip']:
        inputfile = f"{INPUT_FLEXIBLE_DIR}/{f}_{x}_{mon}{year}.nc"
        outputfile = f"{OUTPUT_FLEXIBLE_DIR}/{f}_{x}_{mon}{year}.nc"
        get_file(inputfile, outputfile)


# SEASONAL Forecasts
INPUT_SEASONAL_DIR = INPUT_FLEXIBLE_DIR
OUTPUT_SEASONAL_DIR = "/Data/data21/iri/FD/NMME_Seasonal_Forecast"

precipfile = f"forecast_precip_{mon}{year}.nc"
tempfile = f"forecast_tref_{mon}{year}.nc"

get_file(f"{INPUT_SEASONAL_DIR}/{precipfile}", f"{OUTPUT_SEASONAL_DIR}/Precipitation_ELR/{precipfile}")
get_file(f"{INPUT_SEASONAL_DIR}/{tempfile}", f"{OUTPUT_SEASONAL_DIR}/Temperature_ELR/{tempfile}")

"""
Configuration file for RMMS/SSW lftp mirroring
Jeff Turmelle 8/24/22

"""
import socket
import smtplib
import os
import logging
import pathlib
import json
from email.message import EmailMessage
from datetime import datetime

# don't submit more than this many jobs at a time to ECMWF Data Server
ECMWF_max_processes = 10

# Where are the scripts?
S2S_script_directory = pathlib.Path(__file__).parent

lftp_binary = '/bin/lftp'
S2S_ftp_server1 = {'host': 'aux.ecmwf.int',
                   'options': [
                       'set xfer:log true',
                       'set ftp:sync-mode off',
                       'set mirror:parallel-transfer-count 8',
                       'set mirror:set-permissions false',
                       'set mirror:no-empty-dirs true'
                   ]}

# Remote Folder structure looks like this:
#   toplevel/
#       modelname/
#           real-time/
#           reforecasts/
#               year/ [4-digit]
#                   /months [2-digit]
#
S2S_AVAILABLE_MODELS=['cma', 'cnrm', 'eccc', 'ecmwf', 'hmcr', 'isac', 'jma', 'kma', 'ncep', 'ukmo']

# We may only want a subset of each folder, so we're spelling out exactly what we want.
S2S_FTP_folders1 = [
    {'toplevel': '/RMMS',
     'model_types': [
         {'name': 'reforecasts',
          'models': [
              {'remote': 'cma/reforecasts', 'local': 'CMA/REF/RMMS'}, # sat/wed, 79 days behind
              {'remote': 'eccc/reforecasts', 'local': 'ECCC/REF/RMMS'}, # sat/wed, 79 days behind
              {'remote': 'ecmwf/reforecasts', 'local': 'ECMF/REF/RMMS'}, # sat/wed, 79 days behind
              {'remote': 'hmcr/reforecasts', 'local': 'HMCR/REF/RMMS'}, # Sat, 79 days behind
              {'remote': 'kma/reforecasts', 'local': 'KMA/REF/RMMS'}, # Fri, 79 days behind
              {'remote': 'ukmo/reforecasts', 'local': 'UKMO/REF/RMMS'},  # Fri, 79 days behind
          ]
        },
         {'name': 'real-time',
          'models': [
              {'remote': 'cma/real-time', 'local': 'CMA/REL/RMMS'}, # sat/wed 65 days
              {'remote': 'cnrm/real-time', 'local': 'CNRM/REL/RMMS'}, # sat, 65 days
              {'remote': 'eccc/real-time', 'local': 'ECCC/REL/RMMS'}, # sat, 65 days
              {'remote': 'ecmwf/real-time', 'local': 'ECMF/REL/RMMS'}, # sat/wed 65 days
              {'remote': 'hmcr/real-time', 'local': 'HMCR/REL/RMMS'}, # sat, 65 days
              {'remote': 'isac/real-time', 'local': 'ISAC/REL/RMMS'}, # sat, 65 days
              {'remote': 'jma/real-time', 'local': 'JMA/REL/RMMS'}, # daily, 63 days
              {'remote': 'kma/real-time', 'local': 'KMA/REL/RMMS'}, # daily, 63 days
              {'remote': 'ncep/real-time', 'local': 'NCEP/REL/RMMS'}, # daily, 63 days
              {'remote': 'ukmo/real-time', 'local': 'UKMO/REL/RMMS'}, # daily, 63 days
          ]
          }]
     },
    {'toplevel': '/SSW',
     'model_types': [
         {'name': 'reforecasts',
          'models': [
              {'remote': 'cma/reforecasts', 'local': 'CMA/REF/SSW'}, # Wed/Sat, 79 days
              {'remote': 'eccc/reforecasts', 'local': 'ECCC/REF/SSW'}, # Sat, 79 days
              {'remote': 'ecmwf/reforecasts', 'local': 'ECMF/REF/SSW'}, # Wed/Sat, 79 days
              {'remote': 'hmcr/reforecasts', 'local': 'HMCR/REF/SSW'},
              {'remote': 'kma/reforecasts', 'local': 'KMA/REF/SSW'}, # Fri, 79 days
              {'remote': 'ukmo/reforecasts', 'local': 'UKMO/REF/SSW'} # Fri 79 Days
          ]
          },
         {'name': 'real-time',
          'models': [
              {'remote': 'cma/real-time', 'local': 'CMA/REL/SSW'}, # wed/sat 65 days
              {'remote': 'cnrm/real-time', 'local': 'CNRM/REL/SSW'}, # sat, 65 days
              {'remote': 'eccc/real-time', 'local': 'ECCC/REL/SSW'}, # sat, 65 days
              {'remote': 'ecmwf/real-time', 'local': 'ECMF/REL/SSW'}, # wed/sat 65 days
              {'remote': 'isac/real-time', 'local': 'ISAC/REL/SSW'}, # sat, 65 days
              {'remote': 'jma/real-time', 'local': 'JMA/REL/SSW'}, # daily, 63 days
              {'remote': 'kma/real-time', 'local': 'KMA/REL/SSW'}, # daily, 63 days
              {'remote': 'ncep/real-time', 'local': 'NCEP/REL/SSW'}, # daily, 63 days
              {'remote': 'ukmo/real-time', 'local': 'UKMO/REL/SSW'}, # daily, 63 days
          ]
          }]
     }
]


def S2S_ecmwf_toplevel_directory():
    """
    return where the toplevel folder where the files are being synced to
    :return:
    """
    toplevel = os.getenv("ECMWF_S2S_TOPLEVEL")
    if toplevel is None:
        toplevel = "/Data/data25/ECMWF/S2S"
    return toplevel


def S2S_logs_directory():
    return f"{S2S_ecmwf_toplevel_directory()}/logs"


def S2S_configure_logging(log_dir, log_file, level=logging.DEBUG):
    logfile = None
    try:
        if not os.path.isdir(log_dir):
            os.makedirs(log_dir)
        logfile = f'{log_dir}/{log_file}'
        logging.basicConfig(filename=logfile, encoding='utf-8', format='%(asctime)s: %(message)s',
                            level=level)
    except Exception as e:
        print(f"Failed configuring logging: {e}")

    return logfile


def S2S_ecmwf_api_keys():
    """
        returns array of keys if they exist.
        IF ~/.ecmwfapirc exists, this is a special case and returns None.
        raises an exception:
            FileNotFoundError: if no keys exist
            OSError: if it can't open file
            JSONDecodeError: if the file isn't formatted properly
    """
    #
    # This script allows you to specify multiple user keys that can be used individually.  This allows
    # for running multiple instances of the script with different users.  The default key file is in
    # ~/.ecmwfapikeys, but can be overridden by the ENV variable ECMF_API_KEYS_FILE.
    env_keyfile = os.getenv("ECMWFAPIKEYS_FILE")
    default_file = f"{os.path.expanduser( '~' )}/.ecmwfapirc"
    s2s_keys_file = f"{os.path.expanduser( '~' )}/.ecmwfapikeys"

    keyfile = None
    if env_keyfile is not None:
        keyfile = env_keyfile
    elif os.path.exists(default_file):
        return None
    elif os.path.exists(s2s_keys_file):
        keyfile = s2s_keys_file
    else:
        raise FileNotFoundError(f"No ECMWFAPI Key file found: {{")

    with open(keyfile, 'r') as kf:
        allkeys = json.load(kf)

    # make sure the keys are formatted properly
    for key in allkeys:
        if 'url' not in key or 'key' not in key or 'email' not in key:
            return json.JSONDecodeError('ECMWF API Key incorrect', keyfile, 0)

    return allkeys

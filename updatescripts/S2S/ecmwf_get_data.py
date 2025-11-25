#!/usr/local/bin/condarun updatescripts
# Wrapper script to call ecmwf_get_pooled.py to get model data from ECMWF using the ECMWFDataServer API.
# We need to do it this way because we need to set the ECMWF Keys Environment in order to pass credentials
# properly to the server.
#
# ecmwf_get_pooled will pool all the tasks and run them simultaneously.
#
#
import argparse
import subprocess
import os
from datetime import datetime
import logging

from S2S_config import S2S_ecmwf_api_keys
from S2S_config import S2S_script_directory
from S2S_config import S2S_logs_directory
from S2S_config import S2S_configure_logging
from S2S_config import ECMWF_max_processes

from ecmwf_cma_tasks import CMAModel
from ecmwf_cnrm_tasks import CNRMModel
from ecmwf_cptec_tasks import CPTECModel
from ecmwf_eccc_ref_tasks import ECCC_REF_Model
from ecmwf_eccc_tasks import ECCCModel
from ecmwf_ecmf_tasks import ECMFModel
from ecmwf_ecmf4147_tasks import ECMF4147Model
from ecmwf_ecmf_ref_tasks import ECMF_REF_Model
from ecmwf_hmcr_tasks import HMCRModel
from ecmwf_iapcas_tasks import IAPCASModel
from ecmwf_isac_tasks import ISACModel
from ecmwf_jma_tasks import JMAModel
from ecmwf_kma_tasks import KMAModel
from ecmwf_ncep_tasks import NCEPModel
from ecmwf_ukmo_tasks import UKMOModel

available_models = {
    
    "cma": CMAModel,
    "cnrm": CNRMModel,
    "cptec": CPTECModel,
    "eccc": ECCCModel,
    "eccc_ref": ECCC_REF_Model,
    "ecmf": ECMFModel,
    "ecmf4147": ECMF4147Model,
    "ecmf_ref": ECMF_REF_Model,
    "hmcr": HMCRModel,
    "iapcas": IAPCASModel,
    "isac": ISACModel,
    "jma": JMAModel,
    "kma": KMAModel,
    "ncep": NCEPModel,
    "ukmo": UKMOModel
}

# returns None if using ~/.ecmwfapirc
ECMWFAPIKEYS = S2S_ecmwf_api_keys()

if __name__ == '__main__':
    lockname = "ecmwf_get_data"
    usernames = []  # holds all the available ECMWF user API keys
    executable_arguments = [f"{S2S_script_directory}/ecmwf_get_pooled.py"]
    today = datetime.today()
    model_class = None
    start = None
    end = None
    timeout = None

    parser = argparse.ArgumentParser(description="Download models from ECMWF.")

    if ECMWFAPIKEYS is not None:
        for k in ECMWFAPIKEYS:
            # This is just for the parser help
            k['username'] = k['email'].split('@')[0]
            usernames.append(k['username'])
        parser.add_argument('--user', type=str, required=True, default='x',
                            help=f"Whose key do you want to use: {','.join(usernames)}")

    parser.add_argument('--models', type=str, required=True, nargs='+',
                        help=f"select the model types: {available_models.keys()}.")
    parser.add_argument('--start', type=str,
                        help="Start Day in the form YYYY-MM-DD.  Will use model default if non is specified.")
    parser.add_argument('--end', type=str,
                        help="End Day in the form YYYY-MM-DD.  Will only run 1 day if not defined")
    parser.add_argument('--timeout', type=int,
                        help="timeout of process in seconds")
    parser.add_argument('--debug', action="store_true",
                        help="Turn on ECMWFDataserver logging")
    parser.add_argument('--max_downloads', type=int, default=ECMWF_max_processes,
                        help=f"modify max parallel downloads from default of {ECMWF_max_processes}")
    args = parser.parse_args()

    if args.debug:
        executable_arguments.extend(["--debug"])
    if args.timeout:
        timeout = args.timeout

    executable_arguments.extend(["--max_downloads", str(args.max_downloads)])
    #
    # Make sure the user key exists and set the environment variables for login to ECMWFDataserver
    #
    key = None
    if ECMWFAPIKEYS is not None:
        for k in ECMWFAPIKEYS:
            if k['username'] == args.user:
                key = k
                break
        if key is None:
            print(f"Incorrect key, must choose one of {usernames}")
            parser.print_usage()
            exit(1)
        else:
            for k in ["url", "key", "email"]:
                # Set ENVIRONMENT variables to be passed to the job that will set the ECMWFAPI API keys
                os.environ[f"ECMWF_API_{k.upper()}"] = key[k]
    # else
        # We're using ~/.ecmwfapirc and no environment variables are necessary

    #
    # Check the Start and End Times.  Set start and end as datetime values, so we can
    # later check that all the output folders exists for the target files.
    # use strptime to make sure the values are formatted properly
    if args.start is not None:
        try:
            start = datetime.strptime(args.start, "%Y-%m-%d")
        except ValueError as e:
            print(f"Error in start: {e}")
            parser.print_usage()
            exit(1)
        else:
            executable_arguments.extend(["--start", args.start])

    if args.end is not None:
        if args.start is None:
            print(f"Error, can't have end without start")
            exit(1)
        try:
            end = datetime.strptime(args.end, "%Y-%m-%d")
        except ValueError as e:
            print(f"Error in end: {e}")
            parser.print_usage()
            exit(1)
        else:
            executable_arguments.extend(["--end", args.end])

    if end is not None and end < start:
        print(f"End is before Start")
        exit(-1)

    # Set up the logfile.  This is try/except because S2S_configure_logging creates the folder/file if it doesn't exist.
    logger = logging.getLogger(__name__)
    try:
        logdir = f"{S2S_logs_directory()}/{today.year}"
        logfile = f"ecmwf_get_data_{today.year}{today.month:02d}{today.day:02d}-{today.hour:02d}{today.minute:02d}{today.second:02d}.log"
        logfile = S2S_configure_logging(S2S_logs_directory(), logfile)
        print(f"logfile is {logfile}")
    except Exception as e:
        print(e)
        exit(1)

    # Make sure the model exists and use model_class as the ModelTaskClass and
    if args.models is None:
        print(f"You must select at least one model from: {available_models.keys()}")
        parser.print_usage()
        exit(1)
    else:
        executable_arguments.append("--model")
        for m in args.models:
            if m not in available_models.keys():
                print(f"You must select models from: {available_models.keys()}. {m} is not a valid model")
                parser.print_usage()
                exit(1)
            else:
                executable_arguments.append(m)

    p = None

    try:
        executable_arguments.extend(["--logfile", logfile])
        logger.info(f"Calling {' '.join(executable_arguments)}")
        p = subprocess.run(executable_arguments, capture_output=True, timeout=timeout)
        p.check_returncode()
    except subprocess.TimeoutExpired as e:
        print(f"Process timed out and killed {e}")
        logger.info(f"Process timed out and killed {e}")
    except subprocess.CalledProcessError as e:
        print(f"Process exited incorrectly {e}: {p.returncode} ")
        logger.info(f"Process exited incorrectly {e}")
    else:
        print("Finished")
        logger.info("Finished")

    exit(0)
